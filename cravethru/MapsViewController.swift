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

    let location_manager = CLLocationManager() // Gives access to the location manager throughout the scope of the controller
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // .delegate            -> Handles responses asynchronously. Needs an 'extension' to be: = self
        // .request...Auth()    -> Triggers location permission dialog. User will see it once.
        // .requestLocation()   -> Triggers one-time location request.
        
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyBest
        location_manager.requestWhenInUseAuthorization()
        location_manager.requestLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

    @IBAction func hello_button(_ sender: Any) {
        print("Hello")
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
extension MapsViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Trigger another requestLocation() b/c
            // 1st attempt would have suffered a permission failure
            location_manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only interested in the first location
        if let location = locations.first {
            print("\n\tLocation: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\n\tError: \(error)")
    }
}
