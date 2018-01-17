//
//  HomePageView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//



import UIKit
import Firebase

class HomePageView: UIView {
    
    let myNotesMyCoursesCollectionViewCellId = "myNotesMyCoursesCollectionViewCellId"
    let mainCollectionViewCellId = "mainCollectionViewCellId"
    let myNotesCollectionViewCellId = "myNotesCollectionViewCellId"
    let myCoursesCollectionViewCellId = "myCoursesCollectionViewCellId"
    var arrayOfHomePages = [HomePage]()
    var currentCarNumber: Int = 0
    var previousCarNumber: Int = 0
    var listenerForCourses: ListenerRegistration?
    var listenerForNotes: ListenerRegistration?
    var arrayOfNotes = [Note]()
    func populateHomePageArray() {
        arrayOfHomePages.append(HomePage(titleLabel: "My Notes", iconForTitle: ""))
        arrayOfHomePages.append(HomePage(titleLabel: "My Courses", iconForTitle: ""))
    }
    

    
    func setupObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadHomePageCollectionView), name: NSNotification.Name.init("reloadHomePageCollectionView"), object: nil)
    }
    
    @objc func reloadHomePageCollectionView() {
        DispatchQueue.main.async {
            self.myNotesMyCoursesCollectionView.reloadData()
        }
    }
    func tappedOnCell(withTitle title: String) {
        switch title {
        case "My Notes":
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openMyNotes"), object: nil)
        case "My Courses":
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openMyCourses"), object: nil)
        default:
            print(title)
        }

        
    }
    

    
    
    var myNotesCollectionView: UICollectionView = {
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
        ma.tag = 3
        ma.alwaysBounceVertical = true
        ma.showsVerticalScrollIndicator = false
        return ma
    }()
    
    var myCoursesCollectionView: UICollectionView = {
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
        ma.tag = 4
        ma.alwaysBounceVertical = true
        ma.showsVerticalScrollIndicator = false
        return ma
    }()
    
    var myNotesMyCoursesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.clipsToBounds = true
        ma.backgroundColor = UIColor.white
        ma.layer.masksToBounds = true
        ma.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        ma.tag = 0
        return ma
    }()
    
    
    var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.clipsToBounds = true
        ma.backgroundColor = UIColor.white
        ma.layer.masksToBounds = true
        ma.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        ma.tag = 1
        ma.isPagingEnabled = true
        return ma
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myNotesMyCoursesCollectionView.layer.shadowColor = UIColor.lightGray.cgColor
        myNotesMyCoursesCollectionView.layer.shadowOffset = CGSize(width: 0, height: 0)
        myNotesMyCoursesCollectionView.layer.shadowOpacity = 1.0
        myNotesMyCoursesCollectionView.layer.masksToBounds = false
        myNotesMyCoursesCollectionView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: myNotesMyCoursesCollectionView.frame.width, height: myNotesMyCoursesCollectionView.frame.height), cornerRadius: myNotesMyCoursesCollectionView.layer.cornerRadius).cgPath
    }
    
    fileprivate func setupMyNotesMyCoursesCollectionView() {

    }
    
    fileprivate func setupMainCollectionView() {
        addSubview(mainCollectionView)
        addSubview(myNotesMyCoursesCollectionView)
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: mainCollectionViewCellId)
        
        NSLayoutConstraint.activate([mainCollectionView.leftAnchor.constraint(equalTo: leftAnchor), mainCollectionView.rightAnchor.constraint(equalTo: rightAnchor), mainCollectionView.topAnchor.constraint(equalTo: myNotesMyCoursesCollectionView.bottomAnchor), mainCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        
        
        
        myNotesMyCoursesCollectionView.delegate = self
        myNotesMyCoursesCollectionView.dataSource = self
        myNotesMyCoursesCollectionView.register(HomePageCollectionViewCell.self, forCellWithReuseIdentifier: myNotesMyCoursesCollectionViewCellId)
        
        NSLayoutConstraint.activate([myNotesMyCoursesCollectionView.leftAnchor.constraint(equalTo: leftAnchor), myNotesMyCoursesCollectionView.rightAnchor.constraint(equalTo: rightAnchor), myNotesMyCoursesCollectionView.topAnchor.constraint(equalTo: topAnchor), myNotesMyCoursesCollectionView.heightAnchor.constraint(equalToConstant: 40)])
        
        
        myNotesCollectionView.delegate = self
        myNotesCollectionView.dataSource = self
        myNotesCollectionView.register(MyNotesCollectionViewCell.self, forCellWithReuseIdentifier: myNotesCollectionViewCellId)
        
        myCoursesCollectionView.delegate = self
        myCoursesCollectionView.dataSource = self
        myCoursesCollectionView.register(MyCoursesCollectionViewCell.self, forCellWithReuseIdentifier: myCoursesCollectionViewCellId)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = UIColor.white
        
        populateHomePageArray()
        setupMyNotesMyCoursesCollectionView()
        setupMainCollectionView()
        setupObservers()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension HomePageView {
    fileprivate func fetchNotes() {
        let db = Firestore.firestore()
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        listenerForNotes = db.collection("Users").document((Auth.auth().currentUser?.uid)!).collection("favortieNotes")
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    self.arrayOfNotes.removeAll()
                    DispatchQueue.main.async {
                        self.myNotesCollectionView.reloadData()
                    }
                    return
                } else {
                    self.arrayOfNotes.removeAll()
                    
                    for document in (snapshot?.documents)! {
                        if let noteName = document.data()["noteName"] as? String,
                            let lectureInformation = document.data()["lectureInformation"] as? String,
                            let noteDescription = document.data()["noteDescription"] as? String,
                            let forCourse = document.data()["forCourse"] as? String,
                            let storageReference = document.data()["storageReference"] as? String,
                            let noteSize = document.data()["noteSize"] as? Int,
                            let rating = document.data()["rating"] as? Int,
                            let referencePath = document.data()["referencePath"] as? String,
                            let timeStamp = document.documentID as? String
                        {
                            self.arrayOfNotes.append(Note(forCourse: forCourse, lectureInformation: lectureInformation, noteDescription: noteDescription, noteName: noteName, noteSize: noteSize, rating: rating, referencePath: referencePath, storageReference: storageReference, timeStamp: timeStamp))
                            
                            
                        }
                    }
                    
                }
        }
        
    }
}

extension HomePageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // collectionView.tag == 0 for the toggle and 1 for the main page itself
    // 3 is for myNotes and 4 is for myCourses

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return arrayOfHomePages.count
        } else if collectionView.tag == 1 {
            return 2
        } else if collectionView.tag == 3 {
            return arrayOfNotes.count
        } else {
            return 7
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myNotesMyCoursesCollectionViewCellId, for: indexPath) as! HomePageCollectionViewCell
            cell.labelForCell.text = arrayOfHomePages[indexPath.row].titleLabel
            if indexPath.row == 0 {
                cell.selectionUnderline.backgroundColor = Constants.themeColor
                cell.labelForCell.textColor = Constants.themeColor
            }
            else {
                cell.selectionUnderline.backgroundColor = UIColor.white
                cell.labelForCell.textColor = Constants.lightColor
            }
            cell.labelForCell.font = UIFont.boldSystemFont(ofSize: cell.labelForCell.font.pointSize)
            return cell
        }
        else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCollectionViewCellId, for: indexPath)
            switch indexPath.row {
            case 0:
                cell.contentView.addSubview(myNotesCollectionView)

                NSLayoutConstraint.activate([myNotesCollectionView.leftAnchor.constraint(equalTo: cell.leftAnchor), myNotesCollectionView.rightAnchor.constraint(equalTo: cell.rightAnchor), myNotesCollectionView.bottomAnchor.constraint(equalTo: cell.bottomAnchor), myNotesCollectionView.topAnchor.constraint(equalTo: cell.topAnchor)])
            case 1:
                cell.contentView.addSubview(myCoursesCollectionView)
                NSLayoutConstraint.activate([myCoursesCollectionView.leftAnchor.constraint(equalTo: cell.leftAnchor), myCoursesCollectionView.rightAnchor.constraint(equalTo: cell.rightAnchor), myCoursesCollectionView.bottomAnchor.constraint(equalTo: cell.bottomAnchor), myCoursesCollectionView.topAnchor.constraint(equalTo: cell.topAnchor)])
            default:
                break
            }

            return cell
        }
        else if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myNotesCollectionViewCellId, for: indexPath) as! MyNotesCollectionViewCell
            cell.layer.cornerRadius = 10.0
            cell.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMyNotesNoteController)))
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myCoursesCollectionViewCellId, for: indexPath) as! MyCoursesCollectionViewCell
            cell.layer.cornerRadius = 10.0
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMyCoursesNotes)))
            cell.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
            return cell
        }
    }
    
    
    @objc func openMyCoursesNotes() {
        NotificationCenter.default.post(name: NSNotification.Name.init("openMyCoursesNotes"), object: nil)
    }
    @objc func openMyNotesNoteController() {
        NotificationCenter.default.post(name: NSNotification.Name.init("openMyNotesNoteController"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
        } else if collectionView.tag == 1 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width - 16, height: 80)
        }
    }
    
    //called when the cell is about to be displayed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            self.currentCarNumber = indexPath.row
            if self.previousCarNumber != self.currentCarNumber {
                print("Current:")
                print(indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            self.previousCarNumber = indexPath.row
            if self.previousCarNumber != self.currentCarNumber {
                scrolledHomeCollectionView()
                print("Previous:")
                print(indexPath.row)
            }
        }
    }
    
    func scrolledHomeCollectionView() {
        if self.currentCarNumber == 0 {
            let cell = myNotesMyCoursesCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! HomePageCollectionViewCell
            let cell1 = myNotesMyCoursesCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! HomePageCollectionViewCell
            
            let changeColor = CATransition()
            changeColor.type = kCATransitionFade
            changeColor.duration = 0.2
            
            CATransaction.begin()
            cell.selectionUnderline.backgroundColor = Constants.themeColor
            cell.labelForCell.textColor = Constants.themeColor
            cell.selectionUnderline.layer.add(changeColor, forKey: nil)
            cell.labelForCell.layer.add(changeColor, forKey: nil)
            CATransaction.setCompletionBlock {
            }
            CATransaction.commit()
            
            CATransaction.begin()
            cell1.selectionUnderline.backgroundColor = UIColor.white
            cell1.selectionUnderline.layer.add(changeColor, forKey: nil)
            cell1.labelForCell.textColor = Constants.lightColor
            cell1.selectionUnderline.layer.add(changeColor, forKey: nil)
            cell1.labelForCell.layer.add(changeColor, forKey: nil)
            CATransaction.setCompletionBlock {
            }
            CATransaction.commit()
        } else {
            let cell = myNotesMyCoursesCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! HomePageCollectionViewCell
            let cell1 = myNotesMyCoursesCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! HomePageCollectionViewCell
            
            
            let changeColor = CATransition()
            changeColor.type = kCATransitionFade
            changeColor.duration = 0.2
            
            CATransaction.begin()
            cell.selectionUnderline.backgroundColor = Constants.themeColor
            cell.selectionUnderline.layer.add(changeColor, forKey: nil)
            cell.labelForCell.textColor = Constants.themeColor
            cell.selectionUnderline.layer.add(changeColor, forKey: nil)
            cell.labelForCell.layer.add(changeColor, forKey: nil)
            CATransaction.setCompletionBlock {
            }
            CATransaction.commit()
            
            CATransaction.begin()
            cell1.selectionUnderline.backgroundColor = UIColor.white
            cell1.selectionUnderline.layer.add(changeColor, forKey: nil)
            cell1.labelForCell.textColor = Constants.lightColor
            cell1.selectionUnderline.layer.add(changeColor, forKey: nil)
            cell1.labelForCell.layer.add(changeColor, forKey: nil)
            CATransaction.setCompletionBlock {
            }
            CATransaction.commit()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !mainCollectionView.isDragging && !mainCollectionView.isDecelerating {
        if collectionView.tag == 0 {
            if indexPath.row == 0 {
                mainCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
                let cell = myNotesMyCoursesCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! HomePageCollectionViewCell
                let cell1 = myNotesMyCoursesCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! HomePageCollectionViewCell
                
                let changeColor = CATransition()
                changeColor.type = kCATransitionFade
                changeColor.duration = 0.2
                
                CATransaction.begin()
                cell.selectionUnderline.backgroundColor = Constants.themeColor
                cell.labelForCell.textColor = Constants.themeColor
                cell.selectionUnderline.layer.add(changeColor, forKey: nil)
                cell.labelForCell.layer.add(changeColor, forKey: nil)
                CATransaction.setCompletionBlock {
                }
                CATransaction.commit()
                
                CATransaction.begin()
                cell1.selectionUnderline.backgroundColor = UIColor.white
                cell1.selectionUnderline.layer.add(changeColor, forKey: nil)
                cell1.labelForCell.textColor = Constants.lightColor
                cell1.selectionUnderline.layer.add(changeColor, forKey: nil)
                cell1.labelForCell.layer.add(changeColor, forKey: nil)
                CATransaction.setCompletionBlock {
                }
                CATransaction.commit()
            } else {
                mainCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
                let cell = myNotesMyCoursesCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! HomePageCollectionViewCell
                let cell1 = myNotesMyCoursesCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! HomePageCollectionViewCell

                
                let changeColor = CATransition()
                changeColor.type = kCATransitionFade
                changeColor.duration = 0.2

                CATransaction.begin()
                cell.selectionUnderline.backgroundColor = Constants.themeColor
                cell.selectionUnderline.layer.add(changeColor, forKey: nil)
                cell.labelForCell.textColor = Constants.themeColor
                cell.selectionUnderline.layer.add(changeColor, forKey: nil)
                cell.labelForCell.layer.add(changeColor, forKey: nil)
                CATransaction.setCompletionBlock {
                }
                CATransaction.commit()
                
                CATransaction.begin()
                cell1.selectionUnderline.backgroundColor = UIColor.white
                cell1.selectionUnderline.layer.add(changeColor, forKey: nil)
                cell1.labelForCell.textColor = Constants.lightColor
                cell1.selectionUnderline.layer.add(changeColor, forKey: nil)
                cell1.labelForCell.layer.add(changeColor, forKey: nil)
                CATransaction.setCompletionBlock {
                }
                CATransaction.commit()
            }
            
        }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
}
