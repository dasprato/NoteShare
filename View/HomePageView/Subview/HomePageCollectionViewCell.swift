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
        addSubview(labelForCell)
        addSubview(selectionUnderline)
        NSLayoutConstraint.activate([labelForCell.centerYAnchor.constraint(equalTo: centerYAnchor), labelForCell.centerXAnchor.constraint(equalTo: centerXAnchor)])
        
        NSLayoutConstraint.activate([selectionUnderline.bottomAnchor.constraint(equalTo: bottomAnchor), selectionUnderline.rightAnchor.constraint(equalTo: rightAnchor), selectionUnderline.leftAnchor.constraint(equalTo: leftAnchor), selectionUnderline.heightAnchor.constraint(equalToConstant: 2)])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var labelForCell: UILabel = {
        let lfc = UILabel()
        lfc.translatesAutoresizingMaskIntoConstraints = false
        return lfc
    }()

    
    var selectionUnderline: UIView = {
        let su = UIView()
        su.translatesAutoresizingMaskIntoConstraints = false
        return su
    }()
    

}
