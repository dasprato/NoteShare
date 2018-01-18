//
//  MyNotesNoteController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-16.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase
class MyNotesNoteController: UIViewController {

    var note: Note!
    var arrayOfComments = [Comment]()
    var titleForNavBar = ""
    var notesSize = 0
    let notesView = NotesView()
    var listener: ListenerRegistration!
    
    var notesViewBottomAnchorWhenHidden: NSLayoutConstraint!
    var notesViewBottomAnchorWhenShown: NSLayoutConstraint!
    
    override func viewDidLoad() {
//        fetchComments()
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
        let barDownload = UIBarButtonItem(image: UIImage(named: "download")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(download))
        navigationItem.setRightBarButtonItems([barDownload], animated: true)
        setupObservers()
        
    }
    
    @objc func download() {
        print(123)
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
        guard let _ = note else { return }
        listener = db.collection("Courses").document(note.forCourse!).collection("Notes").document(note.timeStamp!).collection("Comments").addSnapshotListener { snapshot, error in
            if error != nil {
                self.arrayOfComments.removeAll()
                return
            } else {
                self.arrayOfComments.removeAll()
                for document in (snapshot?.documents)! {
                    
                    if let message = document.data()["message"] as? String,
                        let timeStamp = document.data()["timeStamp"] as? String,
                        let profileStorageReference = document.data()["profileStorageReference"] as? String,
                        let messageOwnerEmail = document.data()["messageOwnerEmail"] as? String
                    {
                        
                        
                        
                        if self.arrayOfComments.count == 0 {
                            self.arrayOfComments.append(Comment(message: message, timeStamp: timeStamp, sameOwner: false,  profileStorageReference: profileStorageReference, messageOwnerEmail: messageOwnerEmail))
                        }
                        else {
                            if messageOwnerEmail == self.arrayOfComments[self.arrayOfComments.count - 1].messageOwnerEmail {
                                self.arrayOfComments.append(Comment(message: message, timeStamp: timeStamp, sameOwner: true, profileStorageReference: profileStorageReference, messageOwnerEmail: messageOwnerEmail))
                            } else {
                                self.arrayOfComments.append(Comment(message: message, timeStamp: timeStamp, sameOwner: false, profileStorageReference: profileStorageReference, messageOwnerEmail: messageOwnerEmail))
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
        
        
        let sUrl = note.storageReference
        UIApplication.shared.openURL(NSURL(string: sUrl!) as! URL)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if listener != nil {
        listener.remove()
        }
    }
    




}
