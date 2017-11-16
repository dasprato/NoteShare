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
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.white
        view.addSubview(homePageView)
        view.addSubview(menuButton)
        view.addSubview(leftMenu)
        
        
        leftMenu.delegate = self
        NSLayoutConstraint.activate([homePageView.leftAnchor.constraint(equalTo: view.leftAnchor), homePageView.rightAnchor.constraint(equalTo: view.rightAnchor), homePageView.bottomAnchor.constraint(equalTo: view.bottomAnchor), homePageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)])
        
        NSLayoutConstraint.activate([leftMenu.leftAnchor.constraint(equalTo: view.leftAnchor), leftMenu.topAnchor.constraint(equalTo: view.topAnchor), leftMenu.heightAnchor.constraint(equalTo: view.heightAnchor), leftMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)])
        leftMenu.isHidden = true
        
        NSLayoutConstraint.activate([menuButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10), menuButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10), menuButton.heightAnchor.constraint(equalToConstant: 23), menuButton.widthAnchor.constraint(equalToConstant: 70)])
        
        
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    var menuButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.clipsToBounds = true
        mb.setTitleColor(Constants.themeColor, for: .normal)
        mb.setTitle("Menu", for: .normal)
        mb.isUserInteractionEnabled = true
        mb.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        mb.contentHorizontalAlignment = .left
        return mb
    }()
    
    func showMenu() {
        leftMenu.isHidden = false
    }


}
