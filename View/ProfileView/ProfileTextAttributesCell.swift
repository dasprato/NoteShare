//
//  ProfileTextAttributesCell.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class ProfileTextAttributesCell: UICollectionViewCell {
    
    var titleOfMenuString: String? {
        didSet {
            titleOfMenu.text = titleOfMenuString
            textCell.placeholder = titleOfMenuString
            if titleOfMenuString == "Email" {
                textCell.isUserInteractionEnabled = false
            }
            
        }
    }
    
    var textString: String? {
        didSet {
            textCell.text = textString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Constants.themeColor.withAlphaComponent(0.2)
        layer.cornerRadius = 5.0
        addSubview(titleOfMenu)
        addSubview(textCell)
        
        NSLayoutConstraint.activate([titleOfMenu.centerYAnchor.constraint(equalTo: centerYAnchor), titleOfMenu.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([textCell.centerYAnchor.constraint(equalTo: centerYAnchor), textCell.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), textCell.leftAnchor.constraint(equalTo: titleOfMenu.rightAnchor, constant: 8), textCell.heightAnchor.constraint(equalTo: heightAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleOfMenu: UILabel = {
        let tom = UILabel()
        tom.translatesAutoresizingMaskIntoConstraints = false
        tom.font = UIFont.boldSystemFont(ofSize: 14)
        tom.textColor = UIColor.darkGray
        tom.isUserInteractionEnabled = false
        return tom
    }()
    
    
    var textCell: UITextField = {
        let tom = UITextField()
        tom.translatesAutoresizingMaskIntoConstraints = false
        tom.font = UIFont.systemFont(ofSize: 14)
        tom.textColor = UIColor.gray
        tom.clipsToBounds = true
        tom.textAlignment = .right
        return tom
    }()
}
