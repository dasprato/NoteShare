//
//  CollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-31.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class NewCommentsCollectionViewCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            print("Single Comment Fetched")
            commentLabel.text = comment?.message
            userName.text = comment?.messageOwner
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(commentLabel)
        addSubview(userName)
        NSLayoutConstraint.activate([userName.topAnchor.constraint(equalTo: topAnchor), userName.leftAnchor.constraint(equalTo: leftAnchor)])
        NSLayoutConstraint.activate([commentLabel.leftAnchor.constraint(equalTo: userName.leftAnchor), commentLabel.topAnchor.constraint(equalTo: userName.bottomAnchor), commentLabel.rightAnchor.constraint(equalTo: rightAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var commentLabel: FlexibleTextView = {
        let ds = FlexibleTextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.textAlignment = .left
        ds.textColor = UIColor.lightGray
        ds.font = UIFont.systemFont(ofSize: 14)
        ds.layer.cornerRadius = 10.0
        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        return ds
    }()
    
    private var userName: FlexibleTextView = {
        let ds = FlexibleTextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.textAlignment = .left
        ds.textColor = UIColor.gray
        ds.text = "Prato Das"
         ds.font = UIFont.boldSystemFont(ofSize: 14)
        ds.layer.cornerRadius = 10.0
        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        return ds
    }()
}

