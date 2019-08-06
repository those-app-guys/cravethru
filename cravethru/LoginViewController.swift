//
//  LoginViewController.swift
//  cravethru
//
//  Created by Eros Gonzalez on 7/30/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var verifyError: UILabel!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        //fast login for debugging
        let emailText = "egonzalez-lopez@csumb.edu"
        let passwordText = "test123"
//        let emailText = emailTextField.text!
//        let passwordText = passwordTextField.text!
        
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
