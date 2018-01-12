//
//  SignUpCollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-12.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class SignUpCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    var title: String? {
        didSet {
            nameOfMedia.text = title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 152/255, green: 204/255, blue: 232/255, alpha: 1)
        layer.cornerRadius = 5.0
//        labelForCell.font = UIFont.boldSystemFont(ofSize: cell.labelForCell.font.pointSize)
        layer.borderColor = UIColor(red: 135/255, green: 190/255, blue: 242/255, alpha: 1).cgColor
        layer.borderWidth = 1.0
        contentView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        contentView.addSubview(nameOfMedia)
        
        NSLayoutConstraint.activate([button.leftAnchor.constraint(equalTo: leftAnchor), button.centerYAnchor.constraint(equalTo: centerYAnchor), button.heightAnchor.constraint(equalTo: heightAnchor), button.widthAnchor.constraint(equalTo: heightAnchor)])
        
        
        NSLayoutConstraint.activate([nameOfMedia.centerXAnchor.constraint(equalTo: centerXAnchor), nameOfMedia.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    lazy var button: UIButton = {
        let lb = UIButton(type: .system)
        lb.translatesAutoresizingMaskIntoConstraints = false
        let imageForLogin = UIImage(named: "login")?.withRenderingMode(.alwaysOriginal)
        lb.setImage(imageForLogin, for: .normal)
        lb.tintColor = UIColor.white
        lb.contentMode = .scaleAspectFit
        lb.addTarget(self, action: #selector(go), for: .touchUpInside)
        return lb
    }()
    
    
    
    var nameOfMedia: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = Constants.themeColor
        lb.backgroundColor = UIColor.clear
        return lb
    }()
    
    @objc func go() {
        print("Tapped")
    }
    

    
    
    
}
