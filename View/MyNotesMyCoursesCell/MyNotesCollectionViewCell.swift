//
//  MyNotesCollectionViewCell.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class MyNotesCollectionViewCell: UICollectionViewCell {
    var note: Note? {
        didSet {
            self.noteName.text = note?.noteName
            self.noteDescription.text = note?.noteDescription
            self.lectureDescription.text = note?.lectureInformation
            self.starIcon.tintColor = Constants.gold
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(noteName)
        addSubview(starIcon)
        addSubview(noteDescription)
        addSubview(lectureDescription)
        NSLayoutConstraint.activate([noteName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), noteName.topAnchor.constraint(equalTo: topAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([starIcon.centerYAnchor.constraint(equalTo: centerYAnchor), starIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), starIcon.heightAnchor.constraint(equalToConstant: 30), starIcon.widthAnchor.constraint(equalToConstant: 30)])
        
        NSLayoutConstraint.activate([noteDescription.leftAnchor.constraint(equalTo: noteName.leftAnchor), noteDescription.rightAnchor.constraint(equalTo: starIcon.leftAnchor, constant: 8), noteDescription.topAnchor.constraint(equalTo: noteName.bottomAnchor)])
        
        NSLayoutConstraint.activate([lectureDescription.leftAnchor.constraint(equalTo: noteName.leftAnchor), lectureDescription.rightAnchor.constraint(equalTo: starIcon.leftAnchor, constant: 8), lectureDescription.topAnchor.constraint(equalTo: noteDescription.bottomAnchor)])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var noteName: UILabel = {
        let ct = UILabel()
        ct.translatesAutoresizingMaskIntoConstraints = false
        ct.font = UIFont.systemFont(ofSize: ct.font.pointSize + 4)
        ct.textColor = Constants.themeColor
         ct.text = "Self.Note Title"
        return ct
    }()
    private var noteDescription: UILabel = {
        let cn = UILabel()
        cn.translatesAutoresizingMaskIntoConstraints = false
        cn.numberOfLines = 2
        cn.font = UIFont.systemFont(ofSize: cn.font.pointSize - 4)
        cn.textColor = UIColor.gray
        cn.text = "Self.Note Description"
        return cn
    }()
    
    private var lectureDescription: UILabel = {
        let cn = UILabel()
        cn.translatesAutoresizingMaskIntoConstraints = false
        cn.numberOfLines = 2
        cn.font = UIFont.systemFont(ofSize: cn.font.pointSize - 4)
        cn.textColor = UIColor.gray
        cn.text = "Lecture Description/ Professor Description"
        return cn
    }()
    
    var starIcon: UIButton = {
        let si = UIButton(type: .system)
        si.translatesAutoresizingMaskIntoConstraints = false
        si.setImage(UIImage(named: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        si.tintColor = UIColor.red
        return si
    }()
}

