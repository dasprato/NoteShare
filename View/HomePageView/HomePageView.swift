//
//  HomePageView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//



import UIKit

class HomePageView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let homePageCollectionViewCellId = "homePageCollectionViewCellId"
    var arrayOfHomePages = [HomePage]()
    
    func populateHomePageArray() {
        arrayOfHomePages.append(HomePage(titleLabel: "My Notes", iconForTitle: ""))
        arrayOfHomePages.append(HomePage(titleLabel: "My Courses", iconForTitle: ""))
        arrayOfHomePages.append(HomePage(titleLabel: "All Courses", iconForTitle: ""))
        arrayOfHomePages.append(HomePage(titleLabel: "Settings", iconForTitle: ""))
        arrayOfHomePages.append(HomePage(titleLabel: "Logout", iconForTitle: ""))
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomePageCollectionViewCell
        if indexPath.row != arrayOfHomePages.count - 1 {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        tappedOnCell(withTitle: cell.labelForCell.text!)
        
        
    }
    
    func tappedOnCell(withTitle title: String) {
        switch title {
        case "My Notes":
            print(title)
        case "My Courses":
            print(title)
        case "All Courses":
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openAllCourses"), object: nil)
        case "Settings":
            print(title)
        case "Logout":
            print(title)
        default:
            print(title)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomePageCollectionViewCell
        if indexPath.row != arrayOfHomePages.count - 1 {
        cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.red
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfHomePages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePageCollectionViewCellId, for: indexPath) as! HomePageCollectionViewCell
        cell.iconForLabel.image = UIImage(named: arrayOfHomePages[indexPath.row].iconForTitle)
        cell.labelForCell.text = arrayOfHomePages[indexPath.row].titleLabel
        if indexPath.row == arrayOfHomePages.count - 1 {
            cell.backgroundColor = UIColor.red
            cell.labelForCell.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.white
            cell.labelForCell.textColor = Constants.themeColor
        }
        cell.labelForCell.font = UIFont.boldSystemFont(ofSize: cell.labelForCell.font.pointSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    
    var homePageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.clipsToBounds = true
        ma.backgroundColor = Constants.themeColor
        ma.layer.masksToBounds = true
        ma.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return ma
    }()
    


    
    fileprivate func setupHomeCollectionView() {
        addSubview(homePageCollectionView)
        
        homePageCollectionView.delegate = self
        homePageCollectionView.dataSource = self
        homePageCollectionView.register(HomePageCollectionViewCell.self, forCellWithReuseIdentifier: homePageCollectionViewCellId)
        
        NSLayoutConstraint.activate([homePageCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), homePageCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), homePageCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor), homePageCollectionView.heightAnchor.constraint(equalTo: heightAnchor)])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = Constants.themeColor
        
                populateHomePageArray()
        setupHomeCollectionView()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
