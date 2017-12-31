//
//  CollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-31.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class NewCommentsCollectionViewCell: UICollectionViewCell {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(comment)
        addSubview(userName)
        NSLayoutConstraint.activate([userName.topAnchor.constraint(equalTo: topAnchor), userName.leftAnchor.constraint(equalTo: leftAnchor)])
        NSLayoutConstraint.activate([comment.leftAnchor.constraint(equalTo: userName.leftAnchor), comment.topAnchor.constraint(equalTo: userName.bottomAnchor), comment.rightAnchor.constraint(equalTo: rightAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var comment: FlexibleTextView = {
        let ds = FlexibleTextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.textAlignment = .left
        ds.textColor = UIColor.lightGray
        ds.font = UIFont.systemFont(ofSize: 14)
        ds.layer.cornerRadius = 10.0
        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        return ds
    }()
    
    var userName: FlexibleTextView = {
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

