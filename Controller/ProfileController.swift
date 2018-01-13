//
//  ProfileController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    let arrayOfFields = ["Name", "Email", "Field Of Study", "Year Of Study"]
    let profileTextAttributesCellId = "profileTextAttributesCellId"
    let profileImageCellId = "profileImageCellId"
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
    }
    
    @objc func onEditTapped() {
        let barSave = UIBarButtonItem(image: UIImage(named: "save")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onSaveTapped))
        navigationItem.setRightBarButtonItems([barSave], animated: true)
    }
    
    @objc func onSaveTapped() {
        let barPencil = UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onEditTapped))
        navigationItem.setRightBarButtonItems([barPencil], animated: true)
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
        ma.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        ma.showsVerticalScrollIndicator = false
        ma.keyboardDismissMode = .onDrag
        ma.bounces = true
        ma.alwaysBounceVertical = true
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
            cell.textString = String(describing: CurrentSessionUser.user!.yearOfStudy!)
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
