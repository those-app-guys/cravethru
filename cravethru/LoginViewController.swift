//
//  LoginViewController.swift
//  cravethru
//
//  Created by Eros Gonzalez on 7/30/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var verifyError: UILabel!
    
    static let location_manager = CLLocationManager() // Gives access to the location manager throughout the scope of the controller
    static var restaurants = [VenueRecommendations.Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.underlined()
        passwordTextField.underlined()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let emailText = emailTextField.text!
        let passwordText = passwordTextField.text!
        
        if emailText == "" && passwordText == ""{
            LoginViewController.location_manager.delegate = self
            LoginViewController.location_manager.desiredAccuracy = kCLLocationAccuracyBest
            LoginViewController.location_manager.requestWhenInUseAuthorization()
        }
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) {(user, error) in
            if error != nil{
                print (error!)
            }
            else if let user = Auth.auth().currentUser{
                if !user.isEmailVerified{
                    self.verifyError.textColor = UIColor.red
                }
                else{
                    self.verifyError.textColor = UIColor.white
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Login View -> Status = Authorized When In Use!")
            let user_lat = LoginViewController.location_manager.location?.coordinate.latitude
            let user_lon = LoginViewController.location_manager.location?.coordinate.longitude
            print("\nLatitude: \(String(describing: user_lat)) | Longitude: \(String(describing: user_lon))\n")
            
            FoursquarePlacesAPI.foursquare_business_search(latitude: user_lat!, longitude: user_lon!, open_now: true) { (result) in
                switch result {
                case .success(let restaurants):
                    print("Venue Recommendations Request = Success!")
                    //                    self.populateAnnotations(restaurants: restaurants)
                    
                    LoginViewController.restaurants = restaurants.response.groups.first!.items
                    
                    // Segue to Home View after getting Foursquare Data
                    //  - Had to add Dispatch... due to background threading error perfomed (setAnimationsEnabled)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "LoginSegue", sender: self)
                    }
                    break
                    
                case .failure(let error):
                    print("Venue Recommendations Request = Fail!")
                    print("\n\nError message: ", error, "\n\n")
                    break
                }
            }
            
            break
            
        case .denied:
            print("Login View -> Status = Denied!")
            /*
             HANDLE WHEN USER DENIES REQUEST HERE
            */
            break
        case .notDetermined:
            print("Login View -> Status = Not Determined!")
            break
        
        // May not handle these cases below
        case .restricted:
            print("Login View -> Status = Restricted!")
            break
        case .authorizedAlways:
            print("Login View -> Status = Authorized Always")
            break
        @unknown default:
            print("Login View -> Reached Default?")
            break
        }
    }
    
}

extension UITextField{
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
