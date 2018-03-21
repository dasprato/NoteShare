//
//  myCoursesCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-11-13.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class myCoursesCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Constants.themeColor
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true


    }
    
    var courseImage: UIImageView = {
        let ci = UIImageView()
        ci.translatesAutoresizingMaskIntoConstraints = false
        ci.clipsToBounds = true
        ci.backgroundColor = UIColor.orange
        return ci
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
