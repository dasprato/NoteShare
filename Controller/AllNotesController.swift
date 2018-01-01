//
//  AllNotesController.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class AllNotesController: UIViewController {

    let allNotesView = AllNotesView()
    var arrayOfNotes = [Note]()
    var titleForNavBar = ""
    var listener: ListenerRegistration!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotes()
        
        view.backgroundColor = UIColor.white
        view.addSubview(allNotesView)
        NSLayoutConstraint.activate([allNotesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), allNotesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), allNotesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), allNotesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        let addNotesButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.setRightBarButtonItems([addNotesButton], animated: true)
        navigationItem.title = titleForNavBar
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.themeColor]
        navigationController?.navigationBar.shadowImage = UIImage()

        setupObservers()
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showError), name: NSNotification.Name(rawValue: "noNoteFoundError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showNote), name: NSNotification.Name(rawValue: "showNote"), object: nil)
        
    }

    
    @objc func showNote() {
        let viewControllerToPush = NotesController()
        guard let unwrappedCurrentCell = allNotesView.currentCell else { return }
        let cell = allNotesView.allNotesCollectionView.cellForItem(at: unwrappedCurrentCell) as? AllNotesCollectionViewCell
        guard let unwrappedCell = cell else { return }
        viewControllerToPush.titleForNavBar = unwrappedCell.noteName.text!
        viewControllerToPush.note = arrayOfNotes[(allNotesView.currentCell?.row)!]
        


        self.navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    @objc func addNote() {
        print("Trying to add a Note")
    }
    
                fileprivate func fetchNotes() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        db.settings = settings
        listener = db.collection("Courses").document(titleForNavBar).collection("Notes")
            .addSnapshotListener { snapshot, error in
            if error != nil {
                self.arrayOfNotes.removeAll()
                self.allNotesView.arrayOfNotes = self.arrayOfNotes
                DispatchQueue.main.async {
                    self.allNotesView.allNotesCollectionView.reloadData()
                }
                return
            } else {
                self.arrayOfNotes.removeAll()
                
                for document in (snapshot?.documents)! {
                    if let noteName = document.data()["noteName"] as? String,
                        let lectureInformation = document.data()["lectureInformation"] as? String,
                        let noteDescription = document.data()["noteDescription"] as? String,
                        let forCourse = document.data()["forCourse"] as? String,
                        let storageReference = document.data()["storageReference"] as? String,
                        let noteSize = document.data()["noteSize"] as? Int,
                        let rating = document.data()["rating"] as? Int
                    {
                        self.arrayOfNotes.append(Note(forCourse: forCourse, lectureInformation: lectureInformation, noteDescription: noteDescription, noteName: noteName, noteSize: noteSize, rating: rating, storageReference: storageReference))
                        self.allNotesView.arrayOfNotes = self.arrayOfNotes
                        DispatchQueue.main.async {
                           self.allNotesView.allNotesCollectionView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    func showError() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print("No notes found")
    }
    
                override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if listener != nil {
        listener.remove()
        }
        print("listener removed")
    }
    
}
