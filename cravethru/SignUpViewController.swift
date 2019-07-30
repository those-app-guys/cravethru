//
//  SignUpViewController.swift
//  cravethru
//
//  Created by Eros Gonzalez on 7/30/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var db: Firestore!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
        firstNameTextField.underlined()
        lastNameTextField.underlined()
        emailTextField.underlined()
        passwordTextField.underlined()
        confirmPassTextField.underlined()
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])

        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        confirmPassTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let firstNameText = firstNameTextField.text!
        let lastNameText = lastNameTextField.text!
        let emailText =  emailTextField.text!
        let passwordText = passwordTextField.text!
        let confirmPasswordText = confirmPassTextField.text!
        
        let alert = UIAlertController(title: "Crave-Thru", message: "A verification email has been sent to \(emailText). Please verify your email adress before loging in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in self.performSegue(withIdentifier: "BackToLogin", sender: self)}))
        
        self.present(alert, animated: true)
        
        if passwordText == confirmPasswordText{
            Auth.auth().createUser(withEmail: emailText, password: passwordText) { authResult, error in
                if error != nil{
                    print ("Sign in error")
                }
                else{
                    let user = Auth.auth().currentUser
                    user?.sendEmailVerification(completion: nil)

                    if let addUser = user {
                        let uid = addUser.uid
                        let date = addUser.metadata.creationDate

                        //Adding sign up information to database
                        self.addUserToDatabase(uid: uid, firstName: firstNameText, lastName: lastNameText, email: emailText, createdDate: date)
                    }
                    
                    
                    let alert = UIAlertController(title: "Crave-Thru", message: "A verification email has been sent to \(emailText). Please verify your email adress before loging in.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in self.performSegue(withIdentifier: "BackToLogin", sender: self)}))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func addUserToDatabase(uid: String, firstName: String, lastName: String, email: String, createdDate: Date?) -> Void{
        let dateString = timestampToString(date: createdDate!)
        
        db.collection("users").document(uid).setData([
            "email": email,
            "creationDate": dateString,
            "firstName": firstName,
            "lastName": lastName
            
        ]) {err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(uid)")
            }
        }
    }
    
    func timestampToString(date: Date) -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        
        let dateString = dateformatter.string(from: date)
        
        return dateString
    }

}
