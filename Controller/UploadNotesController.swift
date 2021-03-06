//
//  UploadNotesController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-01.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import ImagePicker
class UploadNotesController: UIViewController, ImagePickerDelegate, UIDocumentPickerDelegate {

    var course: Course!
    var firebaseCourse: FirebaseCourse!
    var uploadNotesView = UploadNotesView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if course != nil { uploadNotesView.course = course } else { uploadNotesView.firebaseCourse = firebaseCourse }
        view.backgroundColor = UIColor.white
        view.addSubview(uploadNotesView)
        NSLayoutConstraint.activate([uploadNotesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), uploadNotesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), uploadNotesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), uploadNotesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeView(_:)))
        navigationItem.setLeftBarButtonItems([closeButton], animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
  
        setupObservers()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(launchImagePicker), name: NSNotification.Name.init("launchImagePicker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(launchDocumentPicker), name: NSNotification.Name.init("launchDocumentPicker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeView(_:)), name: NSNotification.Name.init("closeNoteUpload"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(createAlert), name: NSNotification.Name.init("uploadError"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(uploadingBegan), name: NSNotification.Name.init("uploadingBegan"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(uploadStarted), name: NSNotification.Name.init("uploadStarted"), object: nil)
        

    }
    @objc func closeView(_ viewController: UIViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadStarted() {
        self.navigationController?.navigationBar.topItem?.title = "Starting..."
    
    }
    
    @objc func uploadingBegan() {
        self.navigationController?.navigationBar.topItem?.title = "Uploading..."
        
    }
    let imagePickerController = ImagePickerController()
    @objc func launchImagePicker() {
        
        self.present(imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
    }
    
    
    
    @objc func createAlert() {
        let alert = UIAlertController(title: "Error", message: "Either the note or the note name is missing", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func launchDocumentPicker() {
        var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.pdf"], in: UIDocumentPickerMode.import)
//        var documentPicker = UIDocumentPickerViewController(documentTypes: [""], in: UIDocumentPickerMode.import)
        //var documentPicker = UIDocumentPickerViewController(documentTypes: [".pdf"], in: UIDocumentPickerMode)
        documentPicker.delegate = self
//        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
    }

    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        uploadNotesView.imagesToSend = images
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

    

    

    
    
    
}
