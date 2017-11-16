//
//  CoursesController.swift
//  NoteShare
//
//  Created by Prato Das on 2017-11-14.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class CoursesController: UIViewController, LeftMenuDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    

    
    func leftMenuDidSelectViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    let leftMenu = LeftMenu()
    let courseView = CourseView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(courseView)
        view.addSubview(closeButton)

        leftMenu.delegate = self
        
        NSLayoutConstraint.activate([closeButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10), closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10), closeButton.heightAnchor.constraint(equalToConstant: 23), closeButton.widthAnchor.constraint(equalToConstant: 70)])

        NSLayoutConstraint.activate([courseView.rightAnchor.constraint(equalTo: view.rightAnchor), courseView.leftAnchor.constraint(equalTo: view.leftAnchor), courseView.heightAnchor.constraint(equalToConstant: 1000), courseView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)])
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    var closeButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.clipsToBounds = true
        mb.setTitleColor(Constants.themeColor, for: .normal)
        mb.setTitle("Close", for: .normal)
        mb.isUserInteractionEnabled = true
        mb.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        mb.contentHorizontalAlignment = .left
        return mb
    }()


    
    
    func closeView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    

}
