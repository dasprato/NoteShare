//
//  AllNotesView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class AllNotesView: UIView {
    var currentCell: IndexPath?
    let allNotesCollectionViewCellId = "allNotesCollectionViewCellId"
    
    var arrayOfNotes: [Note]? {
        didSet {
            DispatchQueue.main.async {
                self.allNotesCollectionView.reloadData()
                self.allNotesCollectionView.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 20, options: .curveEaseOut, animations: {
                    self.allNotesCollectionView.alpha = 1
                }, completion: { (_) in
                    return
                })
                
            }

        }
    }
    
    var reversedArrayOfNotes: [Note]? {
        didSet {

            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
        allNotesCollectionView.delegate = self
        allNotesCollectionView.dataSource = self
        allNotesCollectionView.register(AllNotesCollectionViewCell.self, forCellWithReuseIdentifier: allNotesCollectionViewCellId)
        addSubview(allNotesCollectionView)
        NSLayoutConstraint.activate([allNotesCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), allNotesCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), allNotesCollectionView.topAnchor.constraint(equalTo: topAnchor), allNotesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        if arrayOfNotes?.count == 0 {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noNoteFoundError"), object: nil)
        }
        

        
    }
    
    override func didAddSubview(_ subview: UIView) {
        self.allNotesCollectionView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.allNotesCollectionView.alpha = 1
        }, completion: { (_) in
            return
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var allNotesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.clipsToBounds = true
        ma.backgroundColor = UIColor.white
        ma.layer.masksToBounds = true
        ma.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        ma.showsVerticalScrollIndicator = false
        ma.keyboardDismissMode = .onDrag
        return ma
    }()
}


extension AllNotesView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfNotes == nil {
            return 0
        } else {
            return arrayOfNotes!.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: allNotesCollectionViewCellId, for: indexPath) as! AllNotesCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.note = self.arrayOfNotes?.reversed()[indexPath.row]
        cell.layer.cornerRadius = 10.0
        cell.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeColor))
        let tapOnNote = UITapGestureRecognizer(target: self, action: #selector(showNote))
        cell.addGestureRecognizer(tapOnNote)
        cell.starIcon.addGestureRecognizer(tapGesture)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    



    @objc func showNote(sender: UITapGestureRecognizer) {
        if let indexPath = self.allNotesCollectionView.indexPathForItem(at: sender.location(in: self.allNotesCollectionView)) {
            
            self.currentCell = indexPath
            NotificationCenter.default.post(name: NSNotification.Name.init("showNote"), object: nil)
        } else {
            print("collection view was tapped")
        }
    }
    
    
    @objc func changeColor(sender: UITapGestureRecognizer) {
        if let indexPath = self.allNotesCollectionView.indexPathForItem(at: sender.location(in: self.allNotesCollectionView)) {
            print("you can do something with the cell or index path here")
            let cell = allNotesCollectionView.cellForItem(at: indexPath) as! AllNotesCollectionViewCell
            if cell.starIcon.tintColor == UIColor.lightGray {
                cell.starIcon.tintColor = UIColor.red
            } else {
                cell.starIcon.tintColor = UIColor.lightGray
            }
            
            
            let dict: [String: Any] = ["referencePath": "\(self.arrayOfNotes!.reversed()[indexPath.row].referencePath)"]
            let db = Firestore.firestore()
            db.collection("Users").document((Auth.auth().currentUser?.uid)!).collection("favoriteNotes").document((self.arrayOfNotes?.reversed()[indexPath.row].timeStamp)!).setData(dict)
        } else {
            print("collection view was tapped")
        }
        
        
    }
}

