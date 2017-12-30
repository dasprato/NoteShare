//
//  HomePageCollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class HomePageCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(labelForCell)
        addSubview(iconForLabel)
        iconForLabel.isHidden = true
        NSLayoutConstraint.activate([labelForCell.centerYAnchor.constraint(equalTo: centerYAnchor), labelForCell.centerXAnchor.constraint(equalTo: centerXAnchor)])
        NSLayoutConstraint.activate([iconForLabel.rightAnchor.constraint(equalTo: labelForCell.leftAnchor), iconForLabel.topAnchor.constraint(equalTo: topAnchor), iconForLabel.bottomAnchor.constraint(equalTo: bottomAnchor), iconForLabel.widthAnchor.constraint(equalTo: heightAnchor)])
        iconForLabel.layer.cornerRadius = frame.height / 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var iconForLabel: UIImageView = {
        let pp = UIImageView()
        pp.translatesAutoresizingMaskIntoConstraints = false
        pp.clipsToBounds = true
        pp.backgroundColor = Constants.themeColor.withAlphaComponent(0.05)
        return pp
    }()
    
    var labelForCell: UILabel = {
        let lfc = UILabel()
        lfc.translatesAutoresizingMaskIntoConstraints = false
        return lfc
    }()
    
    

}
