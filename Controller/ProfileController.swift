//
//  ProfileController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    var imageToSend: UIImage?
    let arrayOfFields = ["Name", "Email", "Field Of Study", "Year Of Study"]
    let profileTextAttributesCellId = "profileTextAttributesCellId"
    let profileImageCellId = "profileImageCellId"
    var listener: ListenerRegistration?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.register(ProfileTextAttributesCell.self, forCellWithReuseIdentifier: profileTextAttributesCellId)
        profileCollectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: profileImageCellId)
        
        view.addSubview(profileCollectionView)
        NSLayoutConstraint.activate([profileCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), profileCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), profileCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), profileCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        
        let barPencil = UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onEditTapped))
        navigationItem.setRightBarButtonItems([barPencil], animated: true)
        
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel , target: self, action: #selector(closeView(_:)))
        navigationItem.setLeftBarButtonItems([closeButton], animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    @objc func closeView(_ viewController: UIViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

    @objc func onEditTapped() {
        let barSave = UIBarButtonItem(image: UIImage(named: "save")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onSaveTapped))
        profileCollectionView.isUserInteractionEnabled = true
        
        
        navigationItem.setRightBarButtonItems([barSave], animated: true)
    }
    
    @objc func onSaveTapped() {
    
        let barEdit = UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onEditTapped))
        profileCollectionView.isUserInteractionEnabled = false
        
        navigationItem.setRightBarButtonItems([barEdit], animated: true)
        let name = profileCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! ProfileTextAttributesCell
        let email = profileCollectionView.cellForItem(at: IndexPath(row: 2, section: 0)) as! ProfileTextAttributesCell
        let fieldOfStudy = profileCollectionView.cellForItem(at: IndexPath(row: 3, section: 0)) as! ProfileTextAttributesCell
        let yearOfStudy = profileCollectionView.cellForItem(at: IndexPath(row: 4, section: 0)) as! ProfileTextAttributesCell
        let nameString = name.textCell.text
        let emailString = email.textCell.text
        let fieldOfStudyString = fieldOfStudy.textCell.text
        let yearOfStudyInt = Int(yearOfStudy.textCell.text!)
        
        if imageToSend == nil {
            let firebaseUserDict: [String: Any?] = ["emailAddress": emailString, "fieldOfStudy": fieldOfStudyString, "name": nameString, "profilePictureStorageReference": CurrentSessionUser.user?.profilePictureStorageReference, "yearOfStudy": yearOfStudyInt]
            let db = Firestore.firestore()
            db.collection("Users").document((Auth.auth().currentUser?.uid)!).setData(firebaseUserDict)
        }
        
        if imageToSend != nil {
            
            // First just setting a name
            let imageName = UUID().uuidString
            // Then get the reference to Firebase Storage
            let storageRef = Storage.storage().reference().child("userImages_V_0.3_Implementation").child("\(imageName).jpg")
            //         First get a jpeg representation of the image, I used the built in function UIImageJPEGRepresentation(imageName, compressionQuality)
            if let uploadData = UIImageJPEGRepresentation(imageToSend!, 0) {
                _ = storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

                    // CHECK for error
                    if error != nil {
                        print(error ?? "")
                        return // exit if error is faced to prevent any crashes
                    }
                    
                    // Retrieving the downloadUrl
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let dict: [String: Any] = ["url": profileImageURL]
                        let db = Firestore.firestore()
                        let firebaseUserDict: [String: Any?] = ["emailAddress": emailString, "fieldOfStudy": fieldOfStudyString, "name": nameString, "profilePictureStorageReference": profileImageURL, "yearOfStudy": yearOfStudyInt]
                        db.collection("Users").document((Auth.auth().currentUser?.uid)!).setData(firebaseUserDict)
                    }
                })
            }

        }

    }
    
    

    var profileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.clipsToBounds = true
        ma.backgroundColor = UIColor.white
        ma.layer.masksToBounds = true
        ma.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        ma.showsVerticalScrollIndicator = false
        ma.keyboardDismissMode = .onDrag
        ma.bounces = true
        ma.alwaysBounceVertical = true
        ma.isUserInteractionEnabled = false
        return ma
    }()

}

extension ProfileController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfFields.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileImageCellId, for: indexPath) as! ProfileImageCell
            cell.urlOfImage = CurrentSessionUser.user?.profilePictureStorageReference
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileImageTapped))
            cell.addGestureRecognizer(tapGesture)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileTextAttributesCellId, for: indexPath) as! ProfileTextAttributesCell
        cell.titleOfMenuString = self.arrayOfFields[indexPath.row - 1]
        switch indexPath.row - 1 {
        case 0:
            cell.textString = CurrentSessionUser.user?.name
        case 1:
            cell.textString = CurrentSessionUser.user?.emailAddress
        case 2:
            cell.textString = CurrentSessionUser.user?.fieldOfStudy
        case 3:
            guard let unwrappedYear = CurrentSessionUser.user?.yearOfStudy else { break }
            cell.textString = String(describing: unwrappedYear)
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width / 2)
            
        }
        return CGSize(width: collectionView.frame.width - 16, height: 32)
    }

}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func onProfileImageTapped() {
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
            let cell = profileCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! ProfileImageCell
            cell.galleryImage = selectedImage
            imageToSend = selectedImage
            print("============")
            print(selectedImage)
             print("============")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
