//
//  UploadNotesView.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-01.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import PDFKit
class UploadNotesView: UIView {
    
    var course: Course!
    var note: Note!
    var imagesToSend: [UIImage]!
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(uploadNote)
        addSubview(noteName)
        addSubview(noteDescription)
        addSubview(selectImageButton)
        NSLayoutConstraint.activate([uploadNote.topAnchor.constraint(equalTo: noteDescription.bottomAnchor, constant: 8), uploadNote.centerXAnchor.constraint(equalTo: centerXAnchor)])
        NSLayoutConstraint.activate([selectImageButton.topAnchor.constraint(equalTo: uploadNote.bottomAnchor, constant: 8), selectImageButton.centerXAnchor.constraint(equalTo: centerXAnchor)])
        
        NSLayoutConstraint.activate([noteDescription.topAnchor.constraint(equalTo: noteName.bottomAnchor, constant: 8), noteDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), noteDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
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
        nn.font = UIFont.systemFont(ofSize: 16)
        nn.placeholder = "Note Name Here"
        return nn
    }()
    
    var noteDescription: FlexibleTextView = {
        let nn = FlexibleTextView()
        nn.translatesAutoresizingMaskIntoConstraints = false
        nn.textAlignment = .left
        nn.textColor = UIColor.gray
        nn.layer.cornerRadius = 10.0
        nn.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        nn.font = UIFont.systemFont(ofSize: 16)
        nn.placeholder = "Note Description Here"
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

    lazy var selectImageButton: UIButton = {
        let un = UIButton()
        un.translatesAutoresizingMaskIntoConstraints = false
        un.setTitle("Select Image", for: .normal)
        un.backgroundColor = Constants.themeColor
        un.addTarget(self, action: #selector(launchImagePicker), for: .touchUpInside)
        un.layer.cornerRadius = 10.0
        return un
    }()
    
    @objc func launchImagePicker() {
        NotificationCenter.default.post(name: Notification.Name.init("launchImagePicker"), object: nil)
        print("trying to open image picker and notificaiton sent")
    }
    
    @objc func onUploadTapped() {

        ///////////////
        // First just setting a name
        let imageName = UUID().uuidString
        // Then get the reference to Firebase Storage
        let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName)")
        //         First get a jpeg representation of the image, I used the built in function UIImageJPEGRepresentation(imageName, compressionQuality)
        
        // Create an empty PDF document
        let pdfDocument = PDFDocument()
        
        // Load or create your UIImage
        if self.imagesToSend.count > 0 {
        for i in 0..<self.imagesToSend.count {
            let image = UIImage(cgImage: imagesToSend[i].cgImage!, scale: 1, orientation: .downMirrored)
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: i)
        }

    }
        
        
        // Get the raw data of your PDF document
        let pdfData = pdfDocument.dataRepresentation()
        
        if let profileImage = UIImage(named: "UofTLogo") {
            _ = storageRef.putData(pdfData!, metadata: nil, completion: { (metadata, error) in
                // NOTE for Sumit: This is the completion handler, meaning the code will execute when the process is complete
                
                // CHECK for error
                if error != nil {
                    print(error ?? "")
                    return // exit if error is faced to prevent any crashes
                }
                
                // Retrieving the downloadUrl
                guard let noteNameText = self.noteName.text else { return }
                guard let noteDescriptionText = self.noteDescription.text else { return }
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    let courseDict: [String: Any] = ["code": self.course.code, "department": self.course.department, "description": self.course.description, "division": self.course.division, "level": self.course.level, "name": self.course.name]
                    self.note = Note(forCourse: self.course.code, lectureInformation: "My Own Lecture", noteDescription: noteDescriptionText, noteName: noteNameText, noteSize: Int((metadata?.size)! / 1024 / 1024), rating: 0, storageReference: profileImageURL)
                    let noteDict: [String: Any] = ["forCourse": self.course.code, "lectureInformation": self.note.lectureInformation, "noteDescription": self.note.noteDescription, "noteName": self.note.noteName, "noteSize": self.note.noteSize, "rating": self.note.rating, "storageReference": self.note.storageReference]
                    let db = Firestore.firestore()
                    
                    db.collection("Courses").document(self.course.code).setData(courseDict)
                    db.collection("Courses").document(self.course.code).collection("Notes").document(self.note.noteName).setData(noteDict)
                    
                    self.noteName.text = ""
                    self.noteDescription.text = ""
                    

                }
            })
        }
        /////
        
    }
    

}
