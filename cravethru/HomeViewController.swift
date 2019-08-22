//
//  ViewController.swift
//  cravethru
//
//  Created by Raymond Esteybar on 7/7/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    
    static let location_manager = CLLocationManager() // Gives access to the location manager throughout the scope of the controller
    static var restaurants = [VenueRecommendations.Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("***")
        print("Home View")
        print("***")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Checking Location Authorization
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            HomeViewController.location_manager.requestWhenInUseAuthorization()
            break
        
        // Show message to navigate user to enable Location Services
        case .denied, .restricted:
            show_settings_action()
        
            break
        
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
        
        HomeViewController.location_manager.delegate = self
        HomeViewController.location_manager.desiredAccuracy = kCLLocationAccuracyBest
        HomeViewController.location_manager.startUpdatingLocation()
    }
    
    private func setupNavigationBarItems() {
        
    }
    
    func show_settings_action() {
        let title = "Location Services disabled"
        let message = "Please enable Location Services in Settings for CraveThru to gather restaurants around your area."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settings_action = UIAlertAction(title: "Settings", style: .default) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        alert.addAction(settings_action)
        present(alert, animated: true, completion: nil)
    }
    
    func get_restaurants() {
        let user_lat = HomeViewController.location_manager.location?.coordinate.latitude
        let user_lon = HomeViewController.location_manager.location?.coordinate.longitude
        
        print("\nLatitude: \(String(describing: user_lat)) | Longitude: \(String(describing: user_lon))\n")
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        MapsViewController.region = MKCoordinateRegion(center: HomeViewController.location_manager.location!.coordinate, span: span)
        
        FoursquarePlacesAPI.foursquare_business_search(latitude: user_lat!, longitude: user_lon!, open_now: true) { (result) in
            switch result {
            case .success(let restaurants):
                print("Venue Recommendations Request = Success!")
                HomeViewController.restaurants = restaurants.response.groups.first!.items
                break
                
            case .failure(let error):
                print("Venue Recommendations Request = Fail!")
                print("\n\nError message: ", error, "\n\n")
                break
            }
        }
    }
}

extension HomeViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only interested in the first location
        if let user_location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            // Use's user's location go create region
            MapsViewController.region = MKCoordinateRegion(center: user_location.coordinate, span: span)            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            HomeViewController.location_manager.requestWhenInUseAuthorization()
            break
            
        // Show message to navigate user to enable Location Services
        case .denied, .restricted:
            show_settings_action()
            break
            
        case .authorizedAlways, .authorizedWhenInUse:
            get_restaurants()
            break
            
        @unknown default:
            break
        }
    }
}
