//
//  OwnCommentCollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//



import UIKit
import Firebase
class OwnCommentCollectionViewCell: UICollectionViewCell {
    
    
    var commentLabelTieToWidth: NSLayoutConstraint!
    var commentLabelTieToEstimate: NSLayoutConstraint!
    var comment: Comment? {
        didSet {
            print("Single Comment Fetched")
            commentLabel.text = comment?.message
            userName.text = comment?.messageOwner
            if comment?.messageOwner == Auth.auth().currentUser?.email {
                commentLabel.backgroundColor = UIColor.lightGray
                commentLabel.textColor = Constants.themeColor
            }
            if comment?.messageOwner != Auth.auth().currentUser?.email {
                commentLabel.backgroundColor = Constants.themeColor
                commentLabel.textColor = UIColor.white
            }
            
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
                
                let size = CGSize(width: frame.width - 8, height: frame.height - 15 - 16)
                let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
                let estimatedFrame = NSString(string: (comment?.message)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                if estimatedFrame.width + 11 > frame.width {
                    commentLabel.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
                    layoutIfNeeded()
                    contentView.layoutIfNeeded()
                    commentLabelTieToWidth = commentLabel.widthAnchor.constraint(equalToConstant: frame.width)
                    commentLabelTieToWidth.isActive = true
                }
                else {
                    commentLabelTieToEstimate = commentLabel.widthAnchor.constraint(equalToConstant: estimatedFrame.width + 11)
                    commentLabelTieToEstimate.isActive = true
                    layoutIfNeeded()
                    contentView.layoutIfNeeded()
                }
                
            }
            
            
            
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if commentLabelTieToEstimate != nil {
            commentLabelTieToEstimate.isActive = false
        }
        if commentLabelTieToWidth != nil {
            commentLabelTieToWidth.isActive = false
        }
        
        
        
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(commentLabel)
        contentView.addSubview(userName)
        //        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([userName.topAnchor.constraint(equalTo: topAnchor), userName.rightAnchor.constraint(equalTo: rightAnchor), userName.heightAnchor.constraint(equalToConstant: 16)])
        //        NSLayoutConstraint.activate([dateLabel.topAnchor.constraint(equalTo: topAnchor), dateLabel.rightAnchor.constraint(equalTo: rightAnchor)])
        NSLayoutConstraint.activate([commentLabel.rightAnchor.constraint(equalTo: rightAnchor), commentLabel.topAnchor.constraint(equalTo: userName.bottomAnchor), commentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
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


