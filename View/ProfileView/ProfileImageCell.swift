//
//  ProfileImageCell.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {
    var urlOfImage: String? {
        didSet {
            
            profileImageView.sd_setImage(with: URL(string: urlOfImage!), placeholderImage: UIImage(), options: [.continueInBackground, .progressiveDownload])
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor), profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor), profileImageView.widthAnchor.constraint(equalTo: heightAnchor), profileImageView.heightAnchor.constraint(equalTo: heightAnchor)])
        profileImageView.layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profileImageView: UIImageView = {
        let tom = UIImageView()
        tom.translatesAutoresizingMaskIntoConstraints = false
        tom.backgroundColor = UIColor.red
        tom.clipsToBounds = true
        return tom
    }()
    
    
}
