//
//  SignUpController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-11.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.themeColor
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), signUpButton.heightAnchor.constraint(equalToConstant: 40)])
        NSLayoutConstraint.activate([passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor), passwordField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8), passwordField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8), passwordField.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -8), passwordField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor), emailField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8), emailField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8), emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -8), emailField.heightAnchor.constraint(equalToConstant: 40)])
        // to completely get rid of the nav bar and status bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    
    var signUpButton: UIButton = {
        let lb = UIButton()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setTitle("Sign Up", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return lb
    }()
    
    
    @objc func handleSignUp() {
        print("Trying to sign up and send data to firebase")
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (User, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
//            let userref =  String(Int(Date().timeIntervalSince1970)) + userid
//            let ref = Database.database().reference(fromURL: "https://noteshare-7c70f.firebaseio.com/")
//
//            let usersReference = ref.child("users").child(userref)
//            let values = ["name": name, "userid": userid, "email": email]
//            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                if err != nil {
//                    print (err)
//                    err
//                }
//            })
            
            let firebaseUserDict: [String: Any?] = ["emailAddress": email, "fieldOfStudy": nil, "name": nil, "profilePictureStorageReference": nil, "yearOfStudy": 0]
            let db = Firestore.firestore()
            db.collection("Users").document(User!.uid).setData(firebaseUserDict)
            
            
            
            
            //successfully authenticated
            print("added to user list" + "\(String(describing: User?.uid))" + "\(String(describing: User?.email))")
            print("Trying to handle login")
            self.dismiss(animated: true, completion: nil)
            
//            self.present(UINavigationController(rootViewController: viewControllerToPresent), animated: true, completion: nil)
//            self.navigationController?.popToRootViewController(animated: true)
            HomePageController.userEmail =  (Auth.auth().currentUser?.email)!
            self.dismiss(animated: true, completion: nil)
        })
        
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
    

}
