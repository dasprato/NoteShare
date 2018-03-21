//
//  AllCoursesView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class AllCoursesView: UIView {

    var currentCell: IndexPath?
    let allCoursesCollectionViewCellId = "allCoursesCollectionViewCellId"
    var firstTime = true
    
    override var description: String {
        return(self.allCoursesCollectionViewCellId)
    }
    var arrayOfCourses: [Course]? {
        didSet {
            DispatchQueue.main.async {
                self.allCoursesCollectionView.reloadData()
                if (self.firstTime) {
                self.allCoursesCollectionView.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 20, options: .curveEaseOut, animations: {
                    self.allCoursesCollectionView.alpha = 1
                }, completion: { (_) in
                    return
                })
                self.firstTime = false
                }
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
        ma.alwaysBounceVertical = true
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeColor))
        cell.starIcon.addGestureRecognizer(tapGesture)
        
        let tapGestureForAllNoteView = UITapGestureRecognizer(target: self, action: #selector(tappedOnCourse))
        cell.addGestureRecognizer(tapGestureForAllNoteView)
        cell.course = arrayOfCourses?[indexPath.row]
        cell.layer.cornerRadius = 10.0
        cell.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }


    
    
    @objc func tappedOnCourse(sender: UITapGestureRecognizer) {
        if let indexPath = self.allCoursesCollectionView.indexPathForItem(at: sender.location(in: self.allCoursesCollectionView)) {

            self.currentCell = indexPath
            NotificationCenter.default.post(name: NSNotification.Name.init("openAllNotes"), object: nil)
        } else {
      
        }
    }
    
    @objc func changeColor(sender: UITapGestureRecognizer) {
        if let indexPath = self.allCoursesCollectionView.indexPathForItem(at: sender.location(in: self.allCoursesCollectionView)) {

                let cell = allCoursesCollectionView.cellForItem(at: indexPath) as! AllCoursesCollectionViewCell
            
            let courseDict: [String: Any] = ["code": self.arrayOfCourses![indexPath.row].code, "department": self.arrayOfCourses![indexPath.row].department, "description": self.arrayOfCourses![indexPath.row].description, "division": self.arrayOfCourses![indexPath.row].division, "level": self.arrayOfCourses![indexPath.row].level, "name": self.arrayOfCourses![indexPath.row].name, "storageReference": "Courses/\(self.arrayOfCourses![indexPath.row].code!)"]
            
            let db = Firestore.firestore()
            db.collection("Courses").document(self.arrayOfCourses![indexPath.row].code!).setData(courseDict)
            
            
                if cell.starIcon.tintColor == UIColor.lightGray {
                    cell.starIcon.tintColor = Constants.gold
                    
                    let dict: [String: Any] = ["referencePath": "Courses/" + "\(self.arrayOfCourses![indexPath.row].code!)"]
                    let db = Firestore.firestore()
                    db.collection("Users").document((Auth.auth().currentUser?.uid)!).collection("favoriteCourses").document(self.arrayOfCourses![indexPath.row].code!).setData(dict)
                    arrayOfCourses![indexPath.row].isFavorite = true
                    
                    DispatchQueue.main.async {
                        
                        Messaging.messaging().subscribe(toTopic: "Notifications_" + "\(self.arrayOfCourses![indexPath.row].code!)")
                        print("Did subscribe to the topic:")
                        print("Notifications_" + "\(self.arrayOfCourses![indexPath.row].code!)")
                    }
                } else {
                    let db = Firestore.firestore()
                    cell.starIcon.tintColor = UIColor.lightGray
                    db.collection("Users").document((Auth.auth().currentUser?.uid)!).collection("favoriteCourses").document(self.arrayOfCourses![indexPath.row].code!).delete() { err in
                        if let err = err {
                        } else {
                        }
                    }
                    DispatchQueue.main.async {
                        Messaging.messaging().unsubscribe(fromTopic: "Notifications_" + "\(self.arrayOfCourses![indexPath.row].code!)")
                        print("Did unsubscribe to the topic")
                        print("Notifications_" + "\(self.arrayOfCourses![indexPath.row].code!)")
                    }
                        arrayOfCourses![indexPath.row].isFavorite = false
                }
            
            

            

        } else {
        }
        
        
    }
    

}
