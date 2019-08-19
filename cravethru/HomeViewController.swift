//
//  ViewController.swift
//  cravethru
//
//  Created by Raymond Esteybar on 7/7/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Start of Crave Thru!")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Trigger another requestLocation() b/c
            // 1st attempt would have suffered a permission failure
            //            LoginViewController.location_manager.requestLocation()
            print("Home View -> Status = Authorized When In Use!")
        }
        if status == .denied {
            print("Home View -> Status = Denied!")
        }
    }
    
    private func setupNavigationBarItems() {
        
    }
}

