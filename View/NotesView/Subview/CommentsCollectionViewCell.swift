//
//  CommentsCollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-31.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class CommentsCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(comment)
        contentView.addSubview(userName)
        contentView.addSubview(dateAndTime)
        NSLayoutConstraint.activate([userName.topAnchor.constraint(equalTo: topAnchor, constant: 8), userName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)])
        NSLayoutConstraint.activate([dateAndTime.topAnchor.constraint(equalTo: userName.topAnchor), dateAndTime.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
        NSLayoutConstraint.activate([comment.leftAnchor.constraint(equalTo: userName.leftAnchor), comment.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var comment: UILabel = {
        let ds = UILabel()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.textAlignment = .center
        ds.textColor = UIColor.lightGray
        ds.text = "Nyc moov gd lck"
        return ds
    }()
    
    var userName: UILabel = {
        let ds = UILabel()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.text = "Prato Das"
        ds.textAlignment = .center
        ds.font = UIFont.boldSystemFont(ofSize: ds.font.pointSize)
        ds.textColor = UIColor.gray

        
        return ds
    }()
    
    var dateAndTime: UILabel = {
        let ds = UILabel()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.textAlignment = .center
        ds.textColor = UIColor.lightGray
        ds.adjustsFontSizeToFitWidth = true
        ds.text = "Tues | Sept 20th"
        return ds
    }()
}
