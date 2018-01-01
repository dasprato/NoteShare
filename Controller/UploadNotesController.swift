//
//  UploadNotesController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-01.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit


class UploadNotesController: UIViewController {

    var course: Course!
    var uploadNotesView = UploadNotesView()
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadNotesView.course = course
        view.backgroundColor = UIColor.white
        view.addSubview(uploadNotesView)
        NSLayoutConstraint.activate([uploadNotesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), uploadNotesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), uploadNotesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), uploadNotesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeView(_:)))
        navigationItem.setLeftBarButtonItems([closeButton], animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
        
  
    }

    @objc func closeView(_ viewController: UIViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

    

    
    
    
}
