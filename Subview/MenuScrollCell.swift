//
//  UserCell.swift
//  Chat
//
//  Created by Prato Das on 2017-08-23.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class MenuScrollCell: UITableViewCell {
    
    static var colorOfText: UIColor = UIColor.black
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        textLabel?.textColor = MenuScrollCell.colorOfText
    }
    
    let pageIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Constants.themeColor
        return imageView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(pageIcon)

        NSLayoutConstraint.activate([pageIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8), pageIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor), pageIcon.widthAnchor.constraint(equalToConstant: frame.height), pageIcon.heightAnchor.constraint(equalToConstant: frame.height)])
        pageIcon.layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
