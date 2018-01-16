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
        cell.note = arrayOfNotes![indexPath.row]
        cell.layer.cornerRadius = 10.0
        cell.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentCell = indexPath
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showNote"), object: nil)
    }

    @objc func changeColor() {
        
    }
}

