//
//  AllNotesView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class AllNotesView: UIView {
    var currentCell: IndexPath?
    let allNotesCollectionViewCellId = "allNotesCollectionViewCellId"
        var arrayOfNotes = [Note]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
        allNotesCollectionView.delegate = self
        allNotesCollectionView.dataSource = self
        allNotesCollectionView.register(AllNotesCollectionViewCell.self, forCellWithReuseIdentifier: allNotesCollectionViewCellId)
        addSubview(allNotesCollectionView)
        NSLayoutConstraint.activate([allNotesCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), allNotesCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), allNotesCollectionView.topAnchor.constraint(equalTo: topAnchor), allNotesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
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
        return arrayOfNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: allNotesCollectionViewCellId, for: indexPath) as! AllNotesCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeColor))
        cell.starIcon.addGestureRecognizer(tapGesture)
        cell.courseTitle.text = arrayOfNotes[indexPath.row].noteName
        cell.courseName.text = "Lecture Section: Not Available At This Time. Sorry!"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        currentCell = indexPath
        let cell = allNotesCollectionView.cellForItem(at: currentCell!) as! AllNotesCollectionViewCell
        if cell.starIcon.tintColor == UIColor.lightGray {
            cell.starIcon.tintColor = UIColor.red
        } else {
            cell.starIcon.tintColor = UIColor.lightGray
        }
    }
    @objc func changeColor() {
        
    }
}

