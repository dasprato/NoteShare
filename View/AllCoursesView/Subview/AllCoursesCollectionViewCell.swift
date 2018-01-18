//
//  AllCoursesCollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class AllCoursesCollectionViewCell: UICollectionViewCell {
    
    var course: Course? {
        didSet {
            courseTitle.text = course?.code
            courseName.text = course?.name
            guard let bool = course?.isFavorite else { return }
            if bool {
                self.starIcon.tintColor = Constants.gold
            } else {
                self.starIcon.tintColor = UIColor.lightGray
            }
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        courseTitle.text = course?.code
        courseName.text = course?.name
        guard let bool = course?.isFavorite else { return }
        if bool {
            self.starIcon.tintColor = Constants.gold
        } else {
            self.starIcon.tintColor = UIColor.lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(courseTitle)
        addSubview(starIcon)
        addSubview(courseName)
        NSLayoutConstraint.activate([courseTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), courseTitle.topAnchor.constraint(equalTo: topAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([starIcon.centerYAnchor.constraint(equalTo: centerYAnchor), starIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), starIcon.heightAnchor.constraint(equalToConstant: 30), starIcon.widthAnchor.constraint(equalToConstant: 30)])
        
        NSLayoutConstraint.activate([courseName.leftAnchor.constraint(equalTo: courseTitle.leftAnchor), courseName.rightAnchor.constraint(equalTo: starIcon.leftAnchor, constant: 8), courseName.topAnchor.constraint(equalTo: courseTitle.bottomAnchor)])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var courseTitle: UILabel = {
        let ct = UILabel()
        ct.translatesAutoresizingMaskIntoConstraints = false
        ct.font = UIFont.systemFont(ofSize: ct.font.pointSize + 4)
        ct.textColor = Constants.themeColor
        return ct
    }()
    private var courseName: UILabel = {
        let cn = UILabel()
        cn.translatesAutoresizingMaskIntoConstraints = false
        cn.numberOfLines = 2
        cn.text = "This is a long piece of text demonstrating the descrtiption of the course"
        cn.font = UIFont.systemFont(ofSize: cn.font.pointSize - 4)
        cn.textColor = UIColor.gray
        return cn
    }()
    
    var starIcon: UIButton = {
        let si = UIButton(type: .system)
        si.translatesAutoresizingMaskIntoConstraints = false
        si.setImage(UIImage(named: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        return si
    }()
}
