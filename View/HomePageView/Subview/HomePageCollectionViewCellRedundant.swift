//
//  activityCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-11-14.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class HomePageCollectionViewCellRedundant: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = UIColor.white
        addSubview(cellView)
        cellView.addSubview(profilePicture)
        addSubview(likeButton)
        addSubview(dislikeButton)
        
        NSLayoutConstraint.activate([cellView.leftAnchor.constraint(equalTo: likeButton.rightAnchor), cellView.topAnchor.constraint(equalTo: topAnchor), cellView.bottomAnchor.constraint(equalTo: bottomAnchor), cellView.rightAnchor.constraint(equalTo: rightAnchor)])
        cellView.layer.masksToBounds = false
        cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 0.5
        NSLayoutConstraint.activate([profilePicture.leftAnchor.constraint(equalTo: cellView.leftAnchor), profilePicture.topAnchor.constraint(equalTo: cellView.topAnchor), profilePicture.widthAnchor.constraint(equalToConstant: 64), profilePicture.heightAnchor.constraint(equalToConstant: 64)])
        profilePicture.layer.cornerRadius = 64 / 2
        
        NSLayoutConstraint.activate([likeButton.leftAnchor.constraint(equalTo: leftAnchor), likeButton.topAnchor.constraint(equalTo: topAnchor), likeButton.heightAnchor.constraint(equalToConstant: 32), likeButton.widthAnchor.constraint(equalToConstant: 32)])
        
        NSLayoutConstraint.activate([dislikeButton.leftAnchor.constraint(equalTo: leftAnchor), dislikeButton.topAnchor.constraint(equalTo: likeButton.bottomAnchor), dislikeButton.heightAnchor.constraint(equalToConstant: 32), dislikeButton.widthAnchor.constraint(equalToConstant: 32)])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profilePicture: UIImageView = {
        let pp = UIImageView()
        pp.translatesAutoresizingMaskIntoConstraints = false
        pp.clipsToBounds = true
        
        pp.backgroundColor = Constants.themeColor
        return pp
    }()
    
    var cellView: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = true
        return cv
    }()
    
    var likeButton: UIButton = {
        let ub = UIButton()
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.clipsToBounds = true
        ub.setTitle("👍", for: .normal)
        return ub
    }()
    
    var dislikeButton: UIButton = {
        let db = UIButton()
        db.translatesAutoresizingMaskIntoConstraints = false
        db.clipsToBounds = true
        db.setTitle("👎", for: .normal)
        return db
    }()
}
