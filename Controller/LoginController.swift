//
//  LoginController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-11.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), loginButton.widthAnchor.constraint(equalToConstant: 40), loginButton.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor)])
    }
    
    
    var loginButton: UIButton = {
        let lb = UIButton()
        lb.translatesAutoresizingMaskIntoConstraints = false
        let imageForLogin = UIImage(named: "login")?.withRenderingMode(.alwaysTemplate)
        lb.setImage(imageForLogin, for: .normal)
        lb.tintColor = Constants.themeColor
        lb.contentMode = .scaleAspectFit
        lb.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return lb
    }()
    
    
    var signUpButton: UIButton = {
        let lb = UIButton()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setTitle("Have not signed up? Sign Up", for: .normal)
        lb.setTitleColor(Constants.themeColor, for: .normal)
        lb.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return lb
    }()
    
    
    @objc func handleSignUp() {
        
        print("Trying to handle sign up")
        self.navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    @objc func handleLogin() {
        
        print("Trying to handle login")
        
        let email = "pratodas@ymail.com"
        let password = "1234567"
        
        if email == "" || password == "" {
            self.createAlert(title: "Empty, Empty", message: "Looks like one of the text fields are empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            var title = ""
            var message = ""
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
                }
                self.createAlert(title: title, message: message)
                return
            }
            
            //successfully logged in our user
            self.dismiss(animated: true, completion: nil)
            
            let firebaseUser = FirebaseUser(emailAddress: user?.email, fieldOfStudy: "", yearOfStudy: 0, profilePictureStorageReference: "https://scontent.fyto1-1.fna.fbcdn.net/v/t1.0-9/26167731_1580968031970582_2119099227383639033_n.jpg?oh=a20c561f3d5402711b7f2e42ef1d1d7d&oe=5AF07D7C", name: "Prato Das")
            
            let viewControllerToPresent = HomePageController()
            viewControllerToPresent.user = user
            viewControllerToPresent.firebaseUser = firebaseUser
            
            self.present(UINavigationController(rootViewController: viewControllerToPresent), animated: true, completion: nil)

            
            
        })
        
        

    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
