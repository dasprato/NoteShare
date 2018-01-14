//
//  NotesController.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-31.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import Firebase
import M13PDFKit

class NotesController: UIViewController, UITextFieldDelegate {
    
    var note = Note(forCourse: "", lectureInformation: "", noteDescription: "", noteName: "", noteSize: 0, rating: 0, storageReference: "")
    var arrayOfComments = [Comment]()
    var titleForNavBar = ""
    var notesSize = 0
    let notesView = NotesView()
    var listener: ListenerRegistration!
    
    var notesViewBottomAnchorWhenHidden: NSLayoutConstraint!
    var notesViewBottomAnchorWhenShown: NSLayoutConstraint!
    
    override func viewDidLoad() {
        fetchComments()
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(notesView)

        notesViewBottomAnchorWhenHidden = notesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        notesViewBottomAnchorWhenShown = notesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([notesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), notesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), notesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), notesViewBottomAnchorWhenHidden])
        
        navigationItem.title = titleForNavBar
        notesView.downloadSize.text = String(describing: note.noteSize) + " MB"
        notesView.noteDescription.text = note.noteDescription
        notesView.note = note
        navigationController?.navigationBar.shadowImage = UIImage()
        setupObservers()
    }
    
    
    
    @objc func keyboardOnChatWindowIsShown() {
        notesViewBottomAnchorWhenHidden.isActive = false
        notesViewBottomAnchorWhenShown.isActive = true
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardOnChatWindowWentAway() {
        notesViewBottomAnchorWhenHidden.isActive = true
        notesViewBottomAnchorWhenShown.isActive = false
        self.view.layoutIfNeeded()
    }

    
    
    
    func fetchComments() {
        let db = Firestore.firestore()

        let settings = FirestoreSettings()
        db.settings = settings
        listener = db.collection("Courses").document(note.forCourse).collection("Notes").document(note.noteName).collection("Comments").addSnapshotListener { snapshot, error in
            if error != nil {
                self.arrayOfComments.removeAll()
                return
            } else {
                self.arrayOfComments.removeAll()
                for document in (snapshot?.documents)! {

                    if let message = document.data()["message"] as? String,
                        let timeStamp = document.data()["timeStamp"] as? String,
                        let messageOwner = document.data()["messageOwner"] as? String,
                        let profilePictureStorageReference = document.data()["profilePictureStorageReference"] as? String,
                        let messageOwnerEmail = document.data()["messageOwnerEmail"] as? String
                    {
                        if self.arrayOfComments.count == 0 {
                            self.arrayOfComments.append(Comment(message: message, messageOwner: messageOwner, timeStamp: timeStamp, sameOwner: false,  profilePictureStorageReference: profilePictureStorageReference, messageOwnerEmail: messageOwnerEmail))
                        }
                        else {
                            if messageOwner == self.arrayOfComments[self.arrayOfComments.count - 1].messageOwner {
                                self.arrayOfComments.append(Comment(message: message, messageOwner: messageOwner, timeStamp: timeStamp, sameOwner: true, profilePictureStorageReference: profilePictureStorageReference, messageOwnerEmail: messageOwnerEmail))
                            } else {
                                self.arrayOfComments.append(Comment(message: message, messageOwner: messageOwner, timeStamp: timeStamp, sameOwner: false, profilePictureStorageReference: profilePictureStorageReference, messageOwnerEmail: messageOwnerEmail))
                            }
                        }

                    }
                }
                self.notesView.arrayOfComments = self.arrayOfComments
                
            }
        }
        

    }
    
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onViewNoteTapped), name: NSNotification.Name.init("onViewNoteTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardOnChatWindowIsShown), name: NSNotification.Name.init("keyboardOnChatWindowIsShown"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardOnChatWindowWentAway), name: NSNotification.Name.init("keyboardOnChatWindowWentAway"), object: nil)
    }
    
    @objc func onViewNoteTapped() {
//        let viewControllerToPush = WebNotesController()
//        viewControllerToPush.stringUrl = self.note.storageReference
//
//
//
//        self.navigationController?.pushViewController(viewControllerToPush, animated: true)
//
        //Create the document for the viewer when the segue is performed.
//        var viewer: PDFKBasicPDFViewer = PdfViewer() as PDFKBasicPDFViewer
//
//        //Load the document (pdfUrl represents the path on the phone of the pdf document you wish to load)
//        var document: PDFKDocument = PDFKDocument(contentsOfFile: note.storageReference, password: nil)
//        viewer.loadDocument(document)

        let sUrl = note.storageReference
        UIApplication.shared.openURL(NSURL(string: sUrl) as! URL)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener.remove()
    }
    



}
