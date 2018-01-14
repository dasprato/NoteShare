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
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomePageCollectionViewCell
            cell.backgroundColor = UIColor(red: 135/255, green: 190/255, blue: 242/255, alpha: 1)
        tappedOnCell(withTitle: cell.labelForCell.text!)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomePageCollectionViewCell
            cell.backgroundColor = UIColor(red: 152/255, green: 204/255, blue: 232/255, alpha: 1)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHomePageCollectionView), name: NSNotification.Name.init("reloadHomePageCollectionView"), object: nil)
    }
    
    @objc func reloadHomePageCollectionView() {
        DispatchQueue.main.async {
            self.homePageCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomePageCollectionViewCell
        cell.backgroundColor = UIColor(red: 152/255, green: 204/255, blue: 232/255, alpha: 1)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfHomePages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePageCollectionViewCellId, for: indexPath) as! HomePageCollectionViewCell
        cell.iconForLabel.image = UIImage(named: arrayOfHomePages[indexPath.row].iconForTitle)
        cell.labelForCell.text = arrayOfHomePages[indexPath.row].titleLabel
            cell.backgroundColor = UIColor(red: 152/255, green: 204/255, blue: 232/255, alpha: 1)
            cell.labelForCell.textColor = UIColor.white
        cell.labelForCell.font = UIFont.boldSystemFont(ofSize: cell.labelForCell.font.pointSize)
        cell.layer.borderColor = UIColor(red: 135/255, green: 190/255, blue: 242/255, alpha: 1).cgColor
        cell.layer.borderWidth = 3.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
    }
    
    
    var homePageCollectionView: UICollectionView = {
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
        return ma
    }()
    


    
    fileprivate func setupHomeCollectionView() {
        addSubview(homePageCollectionView)
        
        homePageCollectionView.delegate = self
        homePageCollectionView.dataSource = self
        homePageCollectionView.register(HomePageCollectionViewCell.self, forCellWithReuseIdentifier: homePageCollectionViewCellId)
        
        NSLayoutConstraint.activate([homePageCollectionView.leftAnchor.constraint(equalTo: leftAnchor), homePageCollectionView.rightAnchor.constraint(equalTo: rightAnchor), homePageCollectionView.topAnchor.constraint(equalTo: topAnchor), homePageCollectionView.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = UIColor.white
        
        populateHomePageArray()
        setupHomeCollectionView()
        setupObservers()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
