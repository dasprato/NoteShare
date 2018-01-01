//
//  NotesController.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-31.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class NotesController: UIViewController, UITextFieldDelegate {
    
    var note = Note(forCourse: "", lectureInformation: "", noteDescription: "", noteName: "", noteSize: 0, rating: 0, storageReference: "")
    var arrayOfComments = [Comment]()
    var titleForNavBar = ""
    var notesSize = 0
    let notesView = NotesView()
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        fetchComments()
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(notesView)
        NSLayoutConstraint.activate([notesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), notesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), notesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), notesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        navigationItem.title = titleForNavBar
        notesView.downloadSize.text = "Download Size: " + String(describing: note.noteSize) + " MB"
        notesView.noteDescription.text = note.noteDescription
        notesView.note = note
        navigationController?.navigationBar.shadowImage = UIImage()

    }

    
    
    
    func fetchComments() {
        let db = Firestore.firestore()
        print("Tehe title is: ")
       print(titleForNavBar)
        print("Name of note: ")
        print(note.noteName)
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
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
                        let messageOwner = document.data()["messageOwner"] as? String
                    {
                        self.arrayOfComments.append(Comment(message: message, messageOwner: messageOwner, timeStamp: timeStamp))
                        self.notesView.arrayOfComments = self.arrayOfComments
                        print("number Of Comments:")
                        print(self.arrayOfComments.count)

                    }
                }
                
            }
        }
        

    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener.remove()
        print("listener removed")
    }



}
