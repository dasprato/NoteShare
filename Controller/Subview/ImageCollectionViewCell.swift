//
//  ImageCollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-24.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5.0
        
        addSubview(profileImageView)
        NSLayoutConstraint.activate([profileImageView.leftAnchor.constraint(equalTo: leftAnchor), profileImageView.rightAnchor.constraint(equalTo: rightAnchor), profileImageView.topAnchor.constraint(equalTo: topAnchor), profileImageView.topAnchor.constraint(equalTo: topAnchor), profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        profileImageView.layer.cornerRadius = 5.0 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var profileImageView: UIImageView = {
        let pi = UIImageView()
        pi.translatesAutoresizingMaskIntoConstraints = false
        pi.clipsToBounds = true
        pi.contentMode = .scaleAspectFill
        pi.isUserInteractionEnabled = true
        return pi
    }()
    
    
}
