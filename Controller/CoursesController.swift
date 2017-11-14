//
//  CoursesController.swift
//  NoteShare
//
//  Created by Prato Das on 2017-11-14.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class CoursesController: UIViewController, LeftMenuDelegate, UINavigationControllerDelegate {
    

    
    func leftMenuDidSelectViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    let leftMenu = LeftMenu()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green

        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(menuButton)
        view.addSubview(leftMenu)
        view.addSubview(testText)
        leftMenu.delegate = self
        
        NSLayoutConstraint.activate([leftMenu.leftAnchor.constraint(equalTo: view.leftAnchor), leftMenu.topAnchor.constraint(equalTo: view.topAnchor), leftMenu.heightAnchor.constraint(equalTo: view.heightAnchor), leftMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)])
        leftMenu.isHidden = true
        
        NSLayoutConstraint.activate([menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10), menuButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10), menuButton.heightAnchor.constraint(equalToConstant: 100), menuButton.widthAnchor.constraint(equalToConstant: 100)])
        
        NSLayoutConstraint.activate([testText.centerXAnchor.constraint(equalTo: view.centerXAnchor), testText.centerYAnchor.constraint(equalTo: view.centerYAnchor), testText.heightAnchor.constraint(equalToConstant: 100), testText.widthAnchor.constraint(equalToConstant: 100)])
        
        
    }
    
    var menuButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.clipsToBounds = true
        mb.titleLabel?.textColor = UIColor.blue
        mb.setTitle("Close", for: .normal)
        mb.isUserInteractionEnabled = true
        mb.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        mb.contentHorizontalAlignment = .left
        return mb
    }()
    
    var testText: UITextField = {
        let tt = UITextField()
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.clipsToBounds = true
        tt.isUserInteractionEnabled = true
        tt.backgroundColor = UIColor.white
        tt.textColor = UIColor.red
        return tt
    }()
    
    func closeView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    

}
