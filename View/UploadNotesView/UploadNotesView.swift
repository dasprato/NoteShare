//
//  UploadNotesView.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-01.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class UploadNotesView: UIView {
    
    var course: Course!
    var note: Note!
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(uploadNote)
        addSubview(noteName)
        
        NSLayoutConstraint.activate([uploadNote.topAnchor.constraint(equalTo: noteName.bottomAnchor), uploadNote.centerXAnchor.constraint(equalTo: centerXAnchor)])
        NSLayoutConstraint.activate([noteName.topAnchor.constraint(equalTo: topAnchor), noteName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), noteName.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var uploadNote: UIButton = {
        let un = UIButton()
        un.translatesAutoresizingMaskIntoConstraints = false
        un.setTitle("Upload Note", for: .normal)
        un.backgroundColor = Constants.themeColor
        un.addTarget(self, action: #selector(onUploadTapped), for: .touchUpInside)
        un.layer.cornerRadius = 10.0
        return un
    }()
    
    var noteName: FlexibleTextView = {
        let nn = FlexibleTextView()
        nn.translatesAutoresizingMaskIntoConstraints = false
        nn.textAlignment = .left
        nn.textColor = UIColor.gray
        nn.layer.cornerRadius = 10.0
        nn.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        nn.font = UIFont.systemFont(ofSize: 14)
        nn.placeholder = "Note Name Here"
        return nn
    }()
    
//    var noteNameLabel: FlexibleTextView = {
//        let nn = FlexibleTextView()
//        nn.translatesAutoresizingMaskIntoConstraints = false
//        nn.textAlignment = .left
//        nn.text = "Note Name"
//        nn.textColor = UIColor.gray
//        nn.layer.cornerRadius = 10.0
//        nn.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
//        nn.font = UIFont.systemFont(ofSize: 14)
//        nn.isUserInteractionEnabled = false
//        return nn
//    }()

    
    @objc func onUploadTapped() {
        let courseDict: [String: Any] = ["code": course.code, "department": course.department, "description": course.description, "division": course.division, "level": course.level, "name": course.name]
        note = Note(forCourse: course.code, lectureInformation: "My Own Lecture", noteDescription: "My Own Description", noteName: noteName.text!, noteSize: 145, rating: 0, storageReference: "emptyStringForNow")
        let noteDict: [String: Any] = ["forCourse": course.code, "lectureInformation": note.lectureInformation, "noteDescription": note.noteDescription, "noteName": note.noteName, "noteSize": note.noteSize, "rating": note.rating, "storageReference": note.storageReference]
        let db = Firestore.firestore()

        db.collection("Courses").document(course.code).setData(courseDict)
        db.collection("Courses").document(course.code).collection("Notes").document(note.noteName).setData(noteDict)
    }
    

}
