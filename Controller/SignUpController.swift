//
//  SignUpController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-11.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit


class SignUpController: UIViewController {

    
    var userEmail: String? {
        didSet {
            let viewControllerToPush = SignUpPasswordViewController()
            viewControllerToPush.emailAddress = userEmail
            if userEmail != "" {
                viewControllerToPush.emailField.isUserInteractionEnabled = false
                viewControllerToPush.emailField.backgroundColor = UIColor(red: 152/255, green: 204/255, blue: 232/255, alpha: 1)
            }
            self.navigationController?.pushViewController(viewControllerToPush, animated: true)
        }
    }
    
    let arrayOfUIImages = [UIImage(named: "facebook"), UIImage(named: "gmail"), UIImage(named: "email")]
    let arrayOfMediaNames = ["Facebook", "Gmail", "Email"]
    let signUpCollectionViewCellId = "signUpCollectionViewCellId"
    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = Constants.themeColor

        view.addSubview(signUpCollectionView)
//        view.addSubview(googleSingnInButton)

        
        
        NSLayoutConstraint.activate([signUpCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), signUpCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), signUpCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), signUpCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor)])
//
        
        

        
//
        
        
        signUpCollectionView.delegate = self
        signUpCollectionView.dataSource = self
        signUpCollectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: signUpCollectionViewCellId)
        // to completely get rid of the nav bar and status bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationItem.title = ""
        navigationItem.title = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSignIntoGoogle), name: NSNotification.Name.init("didSignIntoGoogle"), object: nil)
        GIDSignIn.sharedInstance().uiDelegate = self
        

        

    }

    var signUpCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.backgroundColor = Constants.themeColor
        ma.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        ma.bounces = true
        ma.bouncesZoom = true
        ma.alwaysBounceVertical = true
        return ma
    }()
    var googleSingnInButton: GIDSignInButton = {
        let gsib = GIDSignInButton()
        gsib.translatesAutoresizingMaskIntoConstraints = false
        return gsib
    }()
    

}

extension SignUpController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfUIImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: signUpCollectionViewCellId, for: indexPath) as! SignUpCollectionViewCell
        cell.image = arrayOfUIImages[indexPath.row]
        cell.title = arrayOfMediaNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 16, height: 40)
    }
    
    
}


extension SignUpController {
    func handleEmailLogin() {
        self.userEmail = ""
    }
}

extension SignUpController: GIDSignInUIDelegate {
    
    func handleGoogleSingIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func didSignIntoGoogle() {
        userEmail = CurrentSessionUser.gmailEmail
    }
}
extension SignUpController: FBSDKLoginButtonDelegate {
    @objc func handleFacebookLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err ?? "")
                return
            }
            self.showEmailAddress()
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        showEmailAddress()
    }
    
    
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credintials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
//
//        Auth.auth().signIn(with: credintials) { (user, error) in
//            if error != nil {
//                print("Something went wrong with our facebook user:", error ?? "")
//                return
//            }
//            print("Successfully logged in user: ", user ?? "")
//        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            
            
            guard let unwrappedResult = result as? [String: String] else { return }
            CurrentSessionUser.name = unwrappedResult["name"]!
            let url = "https://graph.facebook.com/\(unwrappedResult["id"]!)/picture?type=large&return_ssl_resources=1"
            print("The url for the profiel picture from facebook is:")
            print(url)
            CurrentSessionUser.profileImageUrl = url
            self.userEmail = unwrappedResult["email"]!

            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            handleFacebookLogin()
        case 1:
            handleGoogleSingIn()
        case 2:
            handleEmailLogin()
        default:
            break
        }
    }
}
