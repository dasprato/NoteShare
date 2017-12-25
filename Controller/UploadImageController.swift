//
//  UploadImageController.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-24.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class UploadImageController: UIViewController, LeftMenuDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    
    func leftMenuDidSelectViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    let leftMenu = LeftMenu()
    
    fileprivate func setupView() {
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(closeButton)
        view.addSubview(profileImageView)
        view.addSubview(uploadButton)
        view.addSubview(resultLabel)
        view.addSubview(viewAllButton)
        
        
        NSLayoutConstraint.activate([closeButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8), closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8), closeButton.heightAnchor.constraint(equalToConstant: 44)])
        
                NSLayoutConstraint.activate([viewAllButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8), viewAllButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8), viewAllButton.heightAnchor.constraint(equalToConstant: 44)])
        
        NSLayoutConstraint.activate([profileImageView.topAnchor.constraint(equalTo: closeButton.topAnchor, constant: 44), profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8), profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8), profileImageView.heightAnchor.constraint(equalToConstant: view.frame.width - 16)])
        
        NSLayoutConstraint.activate([uploadButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8), uploadButton.rightAnchor.constraint(equalTo: profileImageView.rightAnchor), uploadButton.leftAnchor.constraint(equalTo: profileImageView.leftAnchor), uploadButton.heightAnchor.constraint(equalToConstant: 44)])
        
        NSLayoutConstraint.activate([resultLabel.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 8), resultLabel.widthAnchor.constraint(equalTo: uploadButton.widthAnchor), resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        uploadButton.backgroundColor = UIColor.darkGray
        uploadButton.setTitleColor(UIColor.white, for: .normal)
        uploadButton.layer.cornerRadius = 5.0
        profileImageView.layer.cornerRadius = 5.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenu.delegate = self
        setupView()
        self.hideKeyboardWhenTappedAround()

    }
    
    var closeButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.setTitleColor(Constants.themeColor, for: .normal)
        mb.setTitle("Close", for: .normal)
        mb.isUserInteractionEnabled = true
        mb.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        mb.contentHorizontalAlignment = .left
        return mb
    }()
    
    var viewAllButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.setTitleColor(Constants.themeColor, for: .normal)
        mb.setTitle("View All Uploaded Images", for: .normal)
        mb.isUserInteractionEnabled = true
        mb.addTarget(self, action: #selector(onViewAllTapped), for: .touchUpInside)
        mb.contentHorizontalAlignment = .right
        return mb
    }()
    
    @objc func onViewAllTapped() {
        print("Attempting to show all images")
        self.navigationController?.pushViewController(AllImagesController(), animated: true)
    }
    
    
    
    
    func closeView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    lazy var profileImageView: UIImageView = {
        let pi = UIImageView()
        pi.translatesAutoresizingMaskIntoConstraints = false
        pi.clipsToBounds = true
        pi.backgroundColor = Constants.themeColor.withAlphaComponent(0.05)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileImageTapped))
        pi.addGestureRecognizer(tapGesture)
        tapGesture.numberOfTapsRequired = 1
        pi.contentMode = .scaleAspectFit
        pi.isUserInteractionEnabled = true
        return pi
    }()
    
    lazy var uploadButton: UIButton = {
        let ub = UIButton()
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.setTitle("Upload", for: .normal)
        ub.addTarget(self, action: #selector(onUploadTapped), for: .touchUpInside)
        return ub
    }()
    
    var resultLabel: UILabel = {
        let rl = UILabel()
        rl.translatesAutoresizingMaskIntoConstraints = false
        rl.textAlignment = .center
        rl.textColor = UIColor.gray
        rl.font = UIFont.boldSystemFont(ofSize: rl.font.pointSize)
        return rl
    }()
    
    @objc func onUploadTapped() {
        // First just setting a name
        let imageName = UUID().uuidString
        // Then get the reference to Firebase Storage
        let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).jpg")
        // First get a jpeg representation of the image, I used the built in function UIImageJPEGRepresentation(imageName, compressionQuality)
        if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 1) {
            _ = storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                // NOTE for Sumit: This is the completion handler, meaning the code will execute when the process is complete
                
                // CHECK for error
                if error != nil {
                    print(error ?? "")
                    return // exit if error is faced to prevent any crashes
                }
                
                // Retrieving the downloadUrl
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    print("image URL is: " + "\n")
                    print(profileImageURL)
                    var dict: [String: Any] = ["url": profileImageURL]
                    let db = Firestore.firestore()
                    db.collection("imageURLs").document(imageName).setData(dict)
                    self.resultLabel.text = "Image Upload Success!"
                    self.profileImageView.image = UIImage()
                }
            })
        }
    }
    
    func onProfileImageTapped() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true

        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
