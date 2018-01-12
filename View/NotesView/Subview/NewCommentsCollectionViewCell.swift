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
            if let timeStamp = comment?.timeStamp {
                let date = Date(timeIntervalSince1970: Double(timeStamp)!)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "ETZ")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "MMMM-dd HH:mm"
                let strDate = dateFormatter.string(from: date)
//                 dateLabel.text = strDate

//                let date = Date(timeIntervalSince1970: Double(timeStamp)!)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//
//                let textDate = String(describing: date)
               
            }
            

            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(commentLabel)
        contentView.addSubview(userName)
//        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([userName.topAnchor.constraint(equalTo: topAnchor), userName.leftAnchor.constraint(equalTo: leftAnchor)])
//        NSLayoutConstraint.activate([dateLabel.topAnchor.constraint(equalTo: topAnchor), dateLabel.rightAnchor.constraint(equalTo: rightAnchor)])
        NSLayoutConstraint.activate([commentLabel.leftAnchor.constraint(equalTo: leftAnchor), commentLabel.topAnchor.constraint(equalTo: userName.bottomAnchor), commentLabel.bottomAnchor.constraint(equalTo: bottomAnchor), commentLabel.rightAnchor.constraint(equalTo: rightAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var commentLabel: UITextView = {
        let ds = UITextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.textAlignment = .left
        ds.textColor = UIColor.gray
        ds.font = UIFont.systemFont(ofSize: 16)
        ds.layer.cornerRadius = 10.0
        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        ds.isUserInteractionEnabled = false
        return ds
    }()
    
    private var userName: FlexibleTextView = {
        let ds = FlexibleTextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.textAlignment = .left
        ds.textColor = UIColor.lightGray
        ds.text = "Prato Das"
         ds.font = UIFont.boldSystemFont(ofSize: 8)
        ds.layer.cornerRadius = 10.0
        ds.isUserInteractionEnabled = false
        return ds
    }()
    
//    private var dateLabel: FlexibleTextView = {
//        let ds = FlexibleTextView()
//        ds.translatesAutoresizingMaskIntoConstraints = false
//        ds.textAlignment = .left
//        ds.textColor = UIColor.lightGray
//        ds.font = UIFont.systemFont(ofSize: 12)
//        ds.layer.cornerRadius = 10.0
//        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
//        ds.isUserInteractionEnabled = false
//        return ds
//    }()
}

