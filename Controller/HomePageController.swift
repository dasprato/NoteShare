//
//  HomePage.swift
//  NoteShare
//
//  Created by Prato Das on 2017-10-02.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class HomePageController: UIViewController, LeftMenuDelegate, UINavigationControllerDelegate {
    

    
    static var userEmail: String = ""
    var listener: ListenerRegistration?
    var user: User? {
        didSet {

            guard let email = user?.email else { return }
//            userName.text = email
        }
    }
    
    var firebaseUser: FirebaseUser? {
        didSet {
            guard let url = firebaseUser?.profilePictureStorageReference else { return }
            userImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(), options: [.continueInBackground, .progressiveDownload])
        }
    }
    func leftMenuDidSelectViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    let homePageView = HomePageView()
    
    let leftMenu = LeftMenu()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchUser()
        checkIfUserIsLoggedIn()
        
        view.backgroundColor = UIColor.white
        view.addSubview(homePageView)
//        view.addSubview(leftMenu)
        
        
//        leftMenu.delegate = self
        NSLayoutConstraint.activate([homePageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), homePageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), homePageView.bottomAnchor.constraint(equalTo: view.bottomAnchor), homePageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        
//        NSLayoutConstraint.activate([leftMenu.leftAnchor.constraint(equalTo: view.leftAnchor), leftMenu.topAnchor.constraint(equalTo: view.topAnchor), leftMenu.heightAnchor.constraint(equalTo: view.heightAnchor), leftMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)])
//        leftMenu.isHidden = true
        
        self.hideKeyboardWhenTappedAround()
        if HomePageController.userEmail != "" {
            userName.text = HomePageController.userEmail
        }
        
        NSLayoutConstraint.activate([userImage.heightAnchor.constraint(equalToConstant: 40), userImage.widthAnchor.constraint(equalToConstant: 40)])
//        let barUserImage = UIBarButtonItem(customView: userImage)
        let barUserImage = UIBarButtonItem(image: userImage.image, style: .plain, target: self, action: #selector(openProfile))
//        let barUserName = UIBarButtonItem(customView: userName)
        navigationItem.setLeftBarButtonItems([barUserImage], animated: true)
        setupObservers()
        
        
//        let barSettings = UIBarButtonItem(image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openSettings))
        let barLogout = UIBarButtonItem(image: UIImage(named: "logout")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
                let barSearch = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openAllCourses))
        navigationItem.setRightBarButtonItems([barLogout, barSearch], animated: true)
        
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
//        navigationController?.navigationBar.isTranslucent = false

//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
//        self.navigationController?.navigationBar.layer.masksToBounds = false

        navigationController?.navigationItem.title = ""
        navigationItem.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        removeShadow()
        NSLayoutConstraint.activate([userImage.heightAnchor.constraint(equalToConstant: 40), userImage.widthAnchor.constraint(equalToConstant: 40)])
        //        let barUserImage = UIBarButtonItem(customView: userImage)
        let barUserImage = UIBarButtonItem(image: UIImage(named: "profileIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openProfile))
        navigationItem.setLeftBarButtonItems([barUserImage], animated: true)
        if HomePageController.userEmail != "" {
            userName.text = HomePageController.userEmail
        } else {
            guard let unwrappedEmail = Auth.auth().currentUser?.email else {return}
            userName.text = unwrappedEmail
        }

        fetchNotes()
        fetchCourses()
        fetchUser()


        
        
    }
    
    func fetchUser() {
        let db = Firestore.firestore()
        
        let settings = FirestoreSettings()
        db.settings = settings
        guard let unwrappedID = Auth.auth().currentUser?.uid else { return }
        listener = db.collection("Users").document((Auth.auth().currentUser?.uid)!).addSnapshotListener { snapshot, error in
            if error != nil {
                return
            } else {
                if (snapshot?.exists)! {
                var emailAddress = ""
                var fieldOfStudy = ""
                var name = ""
                var profilePictureStorageReference = ""
                var yearOfStudy = 0
                var dict = snapshot?.data()
                
                emailAddress = (dict!["emailAddress"] as? String) ?? ""
                fieldOfStudy = (dict!["fieldOfStudy"]  as? String) ?? ""
                name = (dict!["name"]  as? String) ?? ""
                profilePictureStorageReference = (dict!["profilePictureStorageReference"] as? String) ?? ""
                    yearOfStudy = (dict?["yearOfStudy"] as? Int) ?? 0
                CurrentSessionUser.user = FirebaseUser(emailAddress: emailAddress, fieldOfStudy: fieldOfStudy, yearOfStudy: yearOfStudy, profilePictureStorageReference: profilePictureStorageReference, name: name)
                print("The user for the current sessoin is:")
                print("---------------")
                print(dict)
                print("---------------")
            }
            }
        }

    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let viewControllerToPresent = LoginController()
        
        self.present(UINavigationController(rootViewController: viewControllerToPresent), animated: true, completion: nil)
        CurrentSessionUser.favoriteCoursesReferencePath.removeAll()
        CurrentSessionUser.favoriteNotesReferencePath.removeAll()
        self.homePageView.arrayOfNotesReferencePath = CurrentSessionUser.favoriteNotesReferencePath
        self.homePageView.arrayOfCoursesReferencePath = CurrentSessionUser.favoriteCoursesReferencePath
    }
    

    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name.init("reloadHomePageCollectionView"), object: self, userInfo: nil)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(openMyNotes), name: NSNotification.Name(rawValue: "openMyNotes"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMyCourses), name: NSNotification.Name(rawValue: "openMyCourses"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMyCoursesNotes), name: NSNotification.Name(rawValue: "openMyCoursesNotes"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(openMyNotesNoteController), name: NSNotification.Name(rawValue: "openMyNotesNoteController"), object: nil)
    }
    
    
    var userImage: UIImageView = {
        let pp = UIImageView()
        pp.translatesAutoresizingMaskIntoConstraints = false
        pp.clipsToBounds = true
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 10
        pp.backgroundColor = UIColor.white
        return pp
    }()
    
    var userName: UILabel = {
        let lfc = UILabel()
        lfc.translatesAutoresizingMaskIntoConstraints = false
        lfc.font = UIFont.boldSystemFont(ofSize: lfc.font.pointSize)
        lfc.textColor = Constants.themeColor
        return lfc
    }()
    
    
    @objc func openProfile() {
        self.present(UINavigationController(rootViewController: ProfileController()), animated: true, completion: nil)
    }
    
    
    @objc func openAllCourses() {
        self.navigationController?.pushViewController(AllCoursesController(), animated: true)

    }
    
    
    @objc func openMyNotes() {
        let viewControllerToPush = NotesController()
        
//        guard let unwrappedCurrentCell = homePageView.currentCell else { return }
        
//        viewControllerToPush.titleForNavBar = self.arrayOfNotes.reversed()[unwrappedCurrentCell.row].noteName
        viewControllerToPush.note = homePageView.selectedNote
        print("The note passed on is:")
        (viewControllerToPush.note.noteName)
        
        self.navigationController?.pushViewController(viewControllerToPush, animated: true)
        


    }
    
    
    @objc func openSettings() {
        self.navigationController?.pushViewController(SettingsController(), animated: true)
        
    }
    
    
    @objc func openMyCourses() {
        self.navigationController?.pushViewController(MyCoursesController(), animated: true)
        
    }
    
    @objc func openMyCoursesNotes() {
        let viewControllerToPush = AllNotesController()
        
        //        guard let unwrappedCurrentCell = homePageView.currentCell else { return }
        
        viewControllerToPush.titleForNavBar = homePageView.selectedCourse.code ?? ""
        viewControllerToPush.firebaseCourse = homePageView.selectedCourse
        self.navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    @objc func openMyNotesNoteController() {
        let viewControllerToPush = NotesController()
        
        //        guard let unwrappedCurrentCell = homePageView.currentCell else { return }
        
        viewControllerToPush.titleForNavBar = homePageView.selectedNote.noteName!
        viewControllerToPush.note = homePageView.selectedNote

        
        self.navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
//            userName.text =  Auth.auth().currentUser?.email
        }
    }
    
    
    



}

extension UIViewController {
    
    
    @objc func addShadow() {
        
        let changeColor = CATransition()
        changeColor.type = kCATransitionFade
        changeColor.duration = 0.2
        
        
        CATransaction.begin()
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.add(changeColor, forKey: nil)
        CATransaction.setCompletionBlock {
        }
        CATransaction.commit()
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    @objc func removeShadow() {
        let changeColor = CATransition()
        changeColor.type = kCATransitionFade
        changeColor.duration = 0.2
        CATransaction.begin()
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.white.cgColor
        self.navigationController?.navigationBar.layer.add(changeColor, forKey: nil)
        CATransaction.setCompletionBlock {
        }
        CATransaction.commit()
        
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
    }
    
}
