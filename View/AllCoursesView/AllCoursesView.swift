//
//  AllCoursesView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class AllCoursesView: UIView {

    var currentCell: IndexPath?
    let allCoursesCollectionViewCellId = "allCoursesCollectionViewCellId"
    
    var arrayOfCourses: [Course]? {
        didSet {
            DispatchQueue.main.async {
                self.allCoursesCollectionView.reloadData()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
        allCoursesCollectionView.delegate = self
        allCoursesCollectionView.dataSource = self
        allCoursesCollectionView.register(AllCoursesCollectionViewCell.self, forCellWithReuseIdentifier: allCoursesCollectionViewCellId)
        addSubview(allCoursesCollectionView)
        NSLayoutConstraint.activate([allCoursesCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), allCoursesCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), allCoursesCollectionView.topAnchor.constraint(equalTo: topAnchor), allCoursesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var allCoursesCollectionView: UICollectionView = {
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


extension AllCoursesView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfCourses != nil {
            return arrayOfCourses!.count

        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: allCoursesCollectionViewCellId, for: indexPath) as! AllCoursesCollectionViewCell
        cell.backgroundColor = UIColor.white
//        cell.layer.borderColor = UIColor.lightGray.cgColor
//        cell.layer.borderWidth = 0.5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeColor))
        cell.course = arrayOfCourses?[indexPath.row]
        cell.layer.cornerRadius = 10.0
        cell.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        currentCell = indexPath
//        let cell = allCoursesCollectionView.cellForItem(at: currentCell!) as! AllCoursesCollectionViewCell
//        if cell.starIcon.tintColor == UIColor.lightGray {
//            cell.starIcon.tintColor = UIColor.red
//        } else {
//            cell.starIcon.tintColor = UIColor.lightGray
//        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openAllNotes"), object: nil)
    }
    @objc func changeColor() {

    }
}
