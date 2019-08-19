//
//  MapsViewController.swift
//  cravethru
//
//  Created by Raymond Esteybar on 7/17/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {

//    let location_manager = CLLocationManager() // Gives access to the location manager throughout the scope of the controller
    @IBOutlet weak var map_view: MKMapView!
    @IBOutlet var dim_view: UIView!
    
    let temp: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // .delegate            -> Handles responses asynchronously. Needs an 'extension' to be: = self
        // .request...Auth()    -> Triggers location permission dialog. User will see it once.
        // .requestLocation()   -> Triggers one-time location request.
        
//        location_manager.delegate = self
//        location_manager.desiredAccuracy = kCLLocationAccuracyBest
//        location_manager.requestWhenInUseAuthorization()
//        location_manager.requestLocation()
        
//        let user_lat = location_manager.location?.coordinate.latitude
//        let user_lon = location_manager.location?.coordinate.longitude
        
//        let user_lat = LoginViewController.location_manager.location?.coordinate.latitude
//        let user_lon = LoginViewController.location_manager.location?.coordinate.longitude
//        print("\nLatitude: \(String(describing: user_lat)) | Longitude: \(String(describing: user_lon))\n")
//        
//        FoursquarePlacesAPI.foursquare_business_search(latitude: user_lat!, longitude: user_lon!, open_now: true) { (result) in
//            switch result {
//            case .success(let restaurants):
//                print("Success!")
//                self.populateAnnotations(restaurants: restaurants)
//                break
//                
//            case .failure(let error):
//                print("\n\nError message: ", error, "\n\n")
//                break
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Layered as:
        //  - Maps
        //  - Dim View
        //  - Bottom Sheet
        add_dim_view()
        add_bottom_sheet_view()
    }
    
    func add_bottom_sheet_view() {
        // 1. Init Bottom Sheet View Controller
        let bottom_sheet_vc = BottomSheetViewController()
        
        // 2. Add Bottom Sheet View Controller as a child view
        self.addChild(bottom_sheet_vc)
        self.view.addSubview(bottom_sheet_vc.view)
        bottom_sheet_vc.didMove(toParent: self)
        
        // 3. Adjust bottom sheet frame & initial position
        let width = view.frame.width
        let height = view.frame.height
        bottom_sheet_vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    func add_dim_view() {
        // Dim Effect of Bottom Sheet
        //  - Setting up Dim Effect to be called in Bottom Sheet View
        NotificationCenter.default.addObserver(self, selector: #selector(notification_dim_on(_:)), name: Notification.Name("dim_on"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notification_dim_off(_:)), name: Notification.Name("dim_off"), object: nil)
        
        dim_view.bounds = self.view.bounds
        self.view.addSubview(dim_view)
        
        let frame = self.view.frame
        let nav_bar_height = UIApplication.shared.statusBarFrame.size.height
        let bottom_sheet_height = frame.height
        let maps_view_height = UIScreen.main.bounds.height
        
        // Ex: iPhone X
        //  - Top    = 94.0
        //  - Mid    = 562.0
        //  - Bottom = 712.0 (Variable declaration found in beginning of function)
        let top = maps_view_height - bottom_sheet_height + nav_bar_height
        let width = view.frame.width
        let height = view.frame.height
        
        dim_view.alpha = 0
        dim_view.center = self.view.center
        dim_view.frame = CGRect(x: 0, y: top, width: width, height: height)
    }
    
    func animate_dim(dim_level : CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.dim_view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.dim_view.alpha = dim_level
        }
    }
    
    func populateAnnotations(restaurants : VenueRecommendations) {
        restaurants.response.groups.first?.items.forEach({ (restaurant) in
            let annotation = MKPointAnnotation()
            
            //  - Store ea. restaurant's info
            annotation.title = restaurant.venue.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.venue.location.lat, longitude: restaurant.venue.location.lng)
            
            DispatchQueue.main.async {
                self.map_view.addAnnotation(annotation)
            }
        })
    }
    
    
    @objc func notification_dim_on(_ notification: Notification) {
        animate_dim(dim_level: 0.4)
    }
    
    @objc func notification_dim_off(_ notification: Notification) {
        animate_dim(dim_level: 0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
 NOTES on what is going on BELOW:
    - extension         -> Puts into class extension that in the class body. Organizes code to group
                           related delegate methods
 
    - locationManager(_:didChangeAuthStat)  -> Gets called when user responds to the permission dialog
                                               If user chose "Allow", the tatus becomes:
                                                    CLAuthorizationStatus.AuthorizedWhenInUse
 
 */

// Processes Location Manager responses (The Asynchronous ones)
// Responses include:
//      - Authorization & Location requests that were sent earlier in viewDidLoad
//      - Handles incoming location data
extension MapsViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Trigger another requestLocation() b/c
            // 1st attempt would have suffered a permission failure
            LoginViewController.location_manager.requestLocation()
        }
    }
    
    /*
 
     Region
     ________________        __
     |              |        |
     |              |        |
     |              |       Span
     |              |        |
     |______________|        __
     
     |--------------|
            Span
    */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only interested in the first location
        if let user_location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            // Use's user's location go create region
            let region = MKCoordinateRegion(center: user_location.coordinate, span: span)
            
            // Sets Screen to user's location
            map_view.setRegion(region, animated: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\n\tError: \(error)")
    }
}
