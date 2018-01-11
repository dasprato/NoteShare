//
//  HomePage.swift
//  NoteShare
//
//  Created by Prato Das on 2017-10-02.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class HomePageController: UIViewController, LeftMenuDelegate, UINavigationControllerDelegate {
    

    
    func leftMenuDidSelectViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    let homePageView = HomePageView()
    
    let leftMenu = LeftMenu()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.themeColor
        view.addSubview(homePageView)
//        view.addSubview(leftMenu)
        
        
//        leftMenu.delegate = self
        NSLayoutConstraint.activate([homePageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), homePageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), homePageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), homePageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        
//        NSLayoutConstraint.activate([leftMenu.leftAnchor.constraint(equalTo: view.leftAnchor), leftMenu.topAnchor.constraint(equalTo: view.topAnchor), leftMenu.heightAnchor.constraint(equalTo: view.heightAnchor), leftMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)])
//        leftMenu.isHidden = true
        
        self.hideKeyboardWhenTappedAround()
        NSLayoutConstraint.activate([userImage.heightAnchor.constraint(equalToConstant: 40), userImage.widthAnchor.constraint(equalToConstant: 40)])
        let barUserImage = UIBarButtonItem(customView: userImage)
        
        let barUserName = UIBarButtonItem(customView: userName)
        navigationItem.setLeftBarButtonItems([barUserImage], animated: true)
        setupObservers()
        
        
        let barSettings = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(openSettings))
        let barLogout = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: nil)
                let barSearch = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: nil)
        navigationItem.setRightBarButtonItems([barLogout, barSettings, barSearch], animated: true)
    }
    

    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name.init("reloadHomePageCollectionView"), object: self, userInfo: nil)
    }
    func showMenu() {
        leftMenu.isHidden = false
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(openAllCourses), name: NSNotification.Name(rawValue: "openAllCourses"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMyNotes), name: NSNotification.Name(rawValue: "openMyNotes"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMyCourses), name: NSNotification.Name(rawValue: "openMyCourses"), object: nil)
    }
    
    
    var userImage: UIImageView = {
        let pp = UIImageView()
        pp.translatesAutoresizingMaskIntoConstraints = false
        pp.sd_setImage(with: URL(string: "https://scontent.fyto1-1.fna.fbcdn.net/v/t1.0-9/26167731_1580968031970582_2119099227383639033_n.jpg?oh=a20c561f3d5402711b7f2e42ef1d1d7d&oe=5AF07D7C"), placeholderImage: UIImage(), options: [.continueInBackground, .progressiveDownload])
        pp.clipsToBounds = true
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 10
        pp.backgroundColor = UIColor.white
        return pp
    }()
    
    var userName: UILabel = {
        let lfc = UILabel()
        lfc.translatesAutoresizingMaskIntoConstraints = false
        lfc.text = "Prato Das"
        lfc.font = UIFont.boldSystemFont(ofSize: lfc.font.pointSize)
        lfc.textColor = Constants.themeColor
        return lfc
    }()
    
    
    @objc func openAllCourses() {
        self.navigationController?.pushViewController(AllCoursesController(), animated: true)
    }
    
    
    @objc func openMyNotes() {
        self.navigationController?.pushViewController(MyNotesController(), animated: true)
    }
    
    
    @objc func openSettings() {
        self.navigationController?.pushViewController(SettingsController(), animated: true)
    }
    
    
    @objc func openMyCourses() {
        self.navigationController?.pushViewController(MyCoursesController(), animated: true)
    }
    
    
    


}
