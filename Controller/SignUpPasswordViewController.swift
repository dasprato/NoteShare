//
//  SignUpPasswordViewController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-12.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class SignUpPasswordViewController: UIViewController {
    
    var emailAddress: String? {
        didSet {
            emailField.text = emailAddress
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.themeColor
        
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), signUpButton.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor), passwordField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8), passwordField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8), passwordField.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -8), passwordField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor), emailField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8), emailField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8), emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -8), emailField.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    var emailField: UITextField = {
        let ef = UITextField()
        ef.translatesAutoresizingMaskIntoConstraints = false
        ef.placeholder = "Your email"
        ef.layer.cornerRadius = 5.0
        ef.backgroundColor = UIColor.white
        ef.textColor = Constants.themeColor
        ef.contentMode = .center
        ef.textAlignment = .center
        return ef
    }()

    @objc func handleSignUp() {
        print("Trying to sign up and send data to firebase")
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        var title = ""
        var message = ""
        Auth.auth().createUser(withEmail: email, password: password, completion: { (User, error) in
            
            if error != nil {
                print(error ?? "")
                if error.debugDescription.lowercased().range(of: "error_user_not_found") != nil {
                    title = "User Not Found"
                    message = "Looks like you never registered!"
                }
                else if error.debugDescription.lowercased().range(of: "error_wrong_password") != nil {
                    title = "Wrong Password"
                    message = "Please check your password and retry!"
                    
                }
                else if error.debugDescription.lowercased().range(of: "error_invalid_email") != nil {
                    title = "Invalid Email"
                    message = "That email is not a real one!"
                } else if  error.debugDescription.lowercased().range(of: "error_email_already_in_use") != nil {
                    title = "Email In Use"
                    message = "Looks like you signed up already! Try the password reset options"
                }
                    
                self.createAlert(title: title, message: message)
                return
            }

            let firebaseUserDict: [String: Any] = ["emailAddress": email, "fieldOfStudy": "", "name": "", "profilePictureStorageReference": CurrentSessionUser.profileImageUrl, "yearOfStudy": 0]
            let db = Firestore.firestore()
            db.collection("Users").document(User!.uid).setData(firebaseUserDict)
            
            //successfully authenticated
            
            HomePageController.userEmail =  (Auth.auth().currentUser?.email)!
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    var signUpButton: UIButton = {
        let lb = UIButton()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setTitle("Sign Up", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return lb
    }()
    
    var passwordField: UITextField = {
        let ef = UITextField()
        ef.translatesAutoresizingMaskIntoConstraints = false
        ef.placeholder = "Your password"
        ef.layer.cornerRadius = 5.0
        ef.backgroundColor = UIColor.white
        ef.textColor = Constants.themeColor
        ef.contentMode = .center
        ef.textAlignment = .center
        ef.isSecureTextEntry = true
        return ef
    }()
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
