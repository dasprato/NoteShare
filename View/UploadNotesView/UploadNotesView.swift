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
    var firebaseCourse: FirebaseCourse!
    var imagesToSend: [UIImage]!
    static var classLevelMetaData: StorageMetadata!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
//        addSubview(uploadNote)
        addSubview(noteName)
        addSubview(noteDescription)
        addSubview(selectImageButton)
        addSubview(selectDocumentButton)
        addSubview(uploadMediaContentNote)
        addSubview(progressView)
        addSubview(lectureProfessorDescription)
//        addSubview(progressLabel)
//        addSubview(selectDocumentPicker)
//        NSLayoutConstraint.activate([uploadNote.topAnchor.constraint(equalTo: noteDescription.bottomAnchor, constant: 8), uploadNote.centerXAnchor.constraint(equalTo: centerXAnchor)])
        NSLayoutConstraint.activate([selectImageButton.topAnchor.constraint(equalTo: topAnchor, constant: 8), selectImageButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20)])
        
        NSLayoutConstraint.activate([selectDocumentButton.topAnchor.constraint(equalTo: topAnchor, constant: 8), selectDocumentButton.leftAnchor.constraint(equalTo: selectImageButton.rightAnchor, constant: 8)])
        
                NSLayoutConstraint.activate([uploadMediaContentNote.topAnchor.constraint(equalTo: lectureProfessorDescription.bottomAnchor, constant: 8), uploadMediaContentNote.centerXAnchor.constraint(equalTo: centerXAnchor)])
        
        
                        NSLayoutConstraint.activate([progressView.topAnchor.constraint(equalTo: topAnchor), progressView.centerXAnchor.constraint(equalTo: centerXAnchor), progressView.widthAnchor.constraint(equalTo: widthAnchor)])
//                NSLayoutConstraint.activate([selectDocumentPicker.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 8), selectDocumentPicker.centerXAnchor.constraint(equalTo: centerXAnchor)])
        
        NSLayoutConstraint.activate([noteName.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 8), noteName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), noteName.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
        
        NSLayoutConstraint.activate([noteDescription.topAnchor.constraint(equalTo: noteName.bottomAnchor, constant: 8), noteDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), noteDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
        
                NSLayoutConstraint.activate([lectureProfessorDescription.topAnchor.constraint(equalTo: noteDescription.bottomAnchor, constant: 8), lectureProfessorDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), lectureProfessorDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
        


//        NSLayoutConstraint.activate([progressLabel.leftAnchor.constraint(equalTo: leftAnchor), progressLabel.rightAnchor.constraint(equalTo: rightAnchor), progressLabel.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 8)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    lazy var uploadMediaContentNote: UIButton = {
        let un = UIButton(type: .system)
        un.translatesAutoresizingMaskIntoConstraints = false
        
        un.setImage(UIImage(named: "upload")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
    
    
    var lectureProfessorDescription: FlexibleTextView = {
        let nn = FlexibleTextView()
        nn.translatesAutoresizingMaskIntoConstraints = false
        nn.textAlignment = .left
        nn.textColor = UIColor.gray
        nn.layer.cornerRadius = 10.0
        nn.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        nn.font = UIFont.systemFont(ofSize: 16)
        nn.placeholder = "Lecture/ Professor Description Here"
        return nn
    }()
    
    
    var progressView: UIProgressView = {
        let pv = UIProgressView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.trackTintColor = UIColor.clear
        pv.tintColor = Constants.themeColor
        return pv
    }()

    lazy var selectImageButton: UIButton = {
        let un = UIButton(type: .system)
        un.translatesAutoresizingMaskIntoConstraints = false
        un.setImage(UIImage(named: "images")?.withRenderingMode(.alwaysOriginal), for: .normal)
        un.addTarget(self, action: #selector(launchImagePicker), for: .touchUpInside)
        return un
    }()
    

    
    lazy var selectDocumentButton: UIButton = {
        let un = UIButton(type: .system)
        un.translatesAutoresizingMaskIntoConstraints = false
        un.setImage(UIImage(named: "documents")?.withRenderingMode(.alwaysOriginal), for: .normal)
        un.addTarget(self, action: #selector(launchDocumentPicker), for: .touchUpInside)
        return un
    }()
    
    
    lazy var selectDocumentPicker: UIButton = {
        let un = UIButton()
        un.translatesAutoresizingMaskIntoConstraints = false
        un.setTitle("Select Document", for: .normal)
        un.backgroundColor = Constants.themeColor
        un.addTarget(self, action: #selector(launchDocumentPicker), for: .touchUpInside)
        un.layer.cornerRadius = 10.0
        return un
    }()
    
    @objc func launchImagePicker() {
        NotificationCenter.default.post(name: Notification.Name.init("launchImagePicker"), object: nil)
        print("trying to open image picker and notificaiton sent")
    }
    
    @objc func launchDocumentPicker() {
        NotificationCenter.default.post(name: Notification.Name.init("launchDocumentPicker"), object: nil)
        print("trying to document picker and notificaiton sent")
    }
    

    
    
    @objc func onUploadTapped() {

        if self.noteName.text.isEmpty {
            print("No note name supplied")
            NotificationCenter.default.post(name: Notification.Name.init("uploadError"), object: nil)
            return
        }
        
        var noteDescriptionText = "No note description supplied"
        var lectureInformationText = "No note lecture information supplied"
        
        let noteNameText = self.noteName.text
        if !self.noteDescription.text.isEmpty {
            noteDescriptionText = self.noteDescription.text
        }
        if !self.lectureProfessorDescription.text.isEmpty {
            lectureInformationText = self.lectureProfessorDescription.text
        }

        
        
        // First just setting a name
        let imageName = UUID().uuidString
        // Then get the reference to Firebase Storage
        let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName)")
        //         First get a jpeg representation of the image, I used the built in function UIImageJPEGRepresentation(imageName, compressionQuality)
        
        // Create an empty PDF document
        let pdfDocument = PDFDocument()
        
        // Load or create your UIImage
        if self.imagesToSend != nil {
            if self.imagesToSend.count > 0 {
                NotificationCenter.default.post(name: Notification.Name.init("uploadStarted"), object: nil)
            for i in 0..<self.imagesToSend.count {
                let image = UIImage(cgImage: imagesToSend[i].cgImage!, scale: 1, orientation: .downMirrored)
                let pdfPage = PDFPage(image: image)
                pdfDocument.insert(pdfPage!, at: i)
                }
            }
            
        } else {
            NotificationCenter.default.post(name: Notification.Name.init("uploadError"), object: nil)
            return
        }
        


        // Get the raw data of your PDF document
        NotificationCenter.default.post(name: Notification.Name.init("uploadingBegan"), object: nil)
        let pdfData = pdfDocument.dataRepresentation()
            let imageUploadTask = storageRef.putData(pdfData!, metadata: nil, completion: { (metadata, error) in
                // NOTE for Sumit: This is the completion handler, meaning the code will execute when the process is complete
                
                // CHECK for error
                if error != nil {
                    print(error ?? "")
                    return // exit if error is faced to prevent any crashes
                }
                
                // Retrieving the downloadUrl

                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    
                    UploadNotesView.classLevelMetaData = metadata!
                    // TODO
                    self.sendToFirebase(wtihMetaData: metadata!, withNoteName: noteNameText!, withNoteDescription: noteDescriptionText, withLectureInformation: lectureInformationText, withUrl: profileImageURL)
                    
                    NotificationCenter.default.post(name: NSNotification.Name.init("closeNoteUpload"), object: nil)
                }
            })
            
            // Update the progress bar
            imageUploadTask.observe(.progress, handler: { [weak self] (snapshot) in
                guard let strongSelf = self else {return}
                guard let progress = snapshot.progress else { return }
                self?.progressLabel.text = String((Double(progress.fractionCompleted)  * 100))

                if progress.isFinished {
                    self?.progressView.progress = Float(0)
                    return
                }
                self?.progressView.progress = Float(progress.fractionCompleted)
                
            })

        
    }
    
    func sendToFirebase(wtihMetaData metadata: StorageMetadata, withNoteName noteNameText: String, withNoteDescription noteDescriptionText: String, withLectureInformation lectureInformationText: String,  withUrl profileImageURL: String) {
        
        let noteReferenceName = "\(String(describing: Date().timeIntervalSince1970))"
        var courseDict = [String: Any]()
        if course != nil {
        courseDict = ["code": self.course.code, "department": self.course.department, "description": self.course.description, "division": self.course.division, "level": self.course.level, "name": self.course.name, "storageReference": "Courses/\(self.course.code!)"]
                    self.note = Note(forCourse: self.course.code!, lectureInformation: lectureInformationText, noteDescription: noteDescriptionText, noteName: noteNameText, noteSize: Int((metadata.size) / 1024 / 1024), rating: 0, referencePath: "Courses/" + self.course.code! + "/Notes/" + noteReferenceName, storageReference: profileImageURL, timeStamp: noteReferenceName, isFavorite: false)
            

        } else {
            courseDict = ["code": self.firebaseCourse.code, "department": self.firebaseCourse.department, "description": self.firebaseCourse.description, "division": "", "level": self.firebaseCourse.level, "name": self.firebaseCourse.name, "storageReference": "Courses/\(self.firebaseCourse.code!)"]
                    self.note = Note(forCourse: self.firebaseCourse.code, lectureInformation: lectureInformationText, noteDescription: noteDescriptionText, noteName: noteNameText, noteSize: Int((metadata.size) / 1024 / 1024), rating: 0, referencePath: "Courses/" + self.firebaseCourse.code! + "/Notes/" + noteReferenceName, storageReference: profileImageURL, timeStamp: noteReferenceName, isFavorite: false)
        }

        let noteDict: [String: Any] = ["forCourse": self.note.forCourse, "lectureInformation": self.note.lectureInformation, "noteDescription": self.note.noteDescription, "noteName": self.note.noteName, "noteSize": self.note.noteSize, "rating": self.note.rating, "storageReference": self.note.storageReference, "referencePath": self.note.referencePath, "timeStamp": self.note.timeStamp]
        let db = Firestore.firestore()
        
        if course != nil { db.collection("Courses").document(self.course.code!).setData(courseDict); db.collection("Courses").document(self.course.code!).collection("Notes").document(noteReferenceName).setData(noteDict)
        } else { db.collection("Courses").document(self.firebaseCourse.code!).setData(courseDict); db.collection("Courses").document(self.firebaseCourse.code!).collection("Notes").document(noteReferenceName).setData(noteDict) }
        
        self.noteName.text = ""
        self.noteDescription.text = ""
        self.lectureProfessorDescription.text = ""
    }
    
    var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.textColor = Constants.themeColor
        progressLabel.font = UIFont.boldSystemFont(ofSize: progressLabel.font.pointSize * 2)
        return progressLabel
    }()

}
