//
//  HomePageView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-11-13.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class HomePageView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let myCoursesCellId = "myCoursesCellId"
    let myActivityCellId = "myActivityCellId"
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myCourses {
            return 4
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myCourses {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myCoursesCellId, for: indexPath) as! myCoursesCell
            cell.layer.cornerRadius = cell.frame.height / 2
            cell.layer.masksToBounds = false
            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.layer.shadowRadius = 3
            cell.layer.shadowOpacity = 0.5
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myActivityCellId, for: indexPath) as! activityCell

        
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.myCourses {
            return CGSize(width: self.frame.width/4.5, height: self.frame.width/4.5)
        } else {
            return CGSize(width: uploadNotesView.frame.width, height: 150)
        }
    }
    
    var myCourses: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let mc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mc.translatesAutoresizingMaskIntoConstraints = false
        mc.clipsToBounds = true
        mc.backgroundColor = UIColor.white
        mc.layer.masksToBounds = true
        mc.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return mc
    }()
    
    var myActivity: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.clipsToBounds = true
        ma.backgroundColor = UIColor.white
        ma.layer.masksToBounds = true
        ma.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        return ma
    }()
    
    var uploadNotesButton: UIButton = {
        let un = UIButton()
        un.translatesAutoresizingMaskIntoConstraints = false
        un.clipsToBounds = true
        un.setTitleColor(Constants.themeColor, for: .normal)
        un.setTitle("Upload your notes", for: .normal)
        un.addTarget(self, action: #selector(uplaodNotes), for: .touchUpInside)
        un.addTarget(self, action: #selector(reset), for: .allTouchEvents)
        return un
    }()
    
    func uplaodNotes() {
        uploadNotesButton.backgroundColor = UIColor.lightGray
    }
    
    func reset() {
        uploadNotesView.backgroundColor = UIColor.white
    }
    
    var uploadNotesView: UIView = {
        let un = UIView()
        un.translatesAutoresizingMaskIntoConstraints = false
        un.clipsToBounds = true
        un.backgroundColor = UIColor.white
        return un
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = UIColor.white
        addSubview(myCourses)
        addSubview(uploadNotesView)
        addSubview(myActivity)
        uploadNotesView.addSubview(uploadNotesButton)
        
        myCourses.delegate = self
        myCourses.dataSource = self
        myCourses.register(myCoursesCell.self, forCellWithReuseIdentifier: myCoursesCellId)
        
        myActivity.delegate = self
        myActivity.dataSource = self
        myActivity.register(activityCell.self, forCellWithReuseIdentifier: myActivityCellId)
        
        NSLayoutConstraint.activate([myCourses.leftAnchor.constraint(equalTo: leftAnchor), myCourses.rightAnchor.constraint(equalTo: rightAnchor), myCourses.topAnchor.constraint(equalTo: topAnchor, constant: 35), myCourses.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4.5 + 15)])
        
        NSLayoutConstraint.activate([uploadNotesView.topAnchor.constraint(equalTo: myCourses.bottomAnchor), uploadNotesView.heightAnchor.constraint(equalToConstant: 50), uploadNotesView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10), uploadNotesView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)])
        
        NSLayoutConstraint.activate([myActivity.leftAnchor.constraint(equalTo: leftAnchor, constant: 10), myActivity.rightAnchor.constraint(equalTo: rightAnchor, constant: -10), myActivity.topAnchor.constraint(equalTo: uploadNotesView.bottomAnchor, constant: 10), myActivity.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        
        uploadNotesView.layer.masksToBounds = false
        uploadNotesView.layer.shadowOffset = CGSize(width: 1, height: 1)
        uploadNotesView.layer.shadowRadius = 3
        uploadNotesView.layer.shadowOpacity = 0.5
        
        
        NSLayoutConstraint.activate([uploadNotesButton.centerXAnchor.constraint(equalTo: uploadNotesView.centerXAnchor), uploadNotesButton.centerYAnchor.constraint(equalTo: uploadNotesView.centerYAnchor), uploadNotesButton.widthAnchor.constraint(equalTo: uploadNotesView.widthAnchor), uploadNotesButton.heightAnchor.constraint(equalTo: uploadNotesView.heightAnchor)])
//        self.uploadNotesView.layer.shadowColor = UIColor.black.cgColor
//        self.uploadNotesView.layer.shadowOpacity = 10
//        self.uploadNotesView.layer.shadowOffset = CGSize.zero
//        self.uploadNotesView.layer.shadowRadius = 100
        
        
//        uploadNotesView.layer.borderColor = UIColor.clear.cgColor
//        uploadNotesView.layer.masksToBounds = true
//
//        uploadNotesView.layer.shadowColor = UIColor.lightGray.cgColor
//        uploadNotesView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        uploadNotesView.layer.shadowRadius = 5
//        uploadNotesView.layer.shadowOpacity = 1.0
//
//        uploadNotesView.layer.masksToBounds = false
//        uploadNotesView.layer.shadowPath = UIBezierPath(roundedRect: uploadNotesView.bounds, cornerRadius: uploadNotesView.layer.cornerRadius).cgPath
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
