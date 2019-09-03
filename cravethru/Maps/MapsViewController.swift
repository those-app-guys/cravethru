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
    static var region = MKCoordinateRegion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        map_view.setRegion(MapsViewController.region, animated: false)
        populateAnnotations(restaurants: HomeViewController.restaurants)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        map_view.removeAnnotations(map_view.annotations)    // For memory issues when repopulating the pins over and over again when segueing to Maps View
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
    
    func populateAnnotations(restaurants : [VenueRecommendations.Restaurant]) {
        restaurants.forEach({ (restaurant) in
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
