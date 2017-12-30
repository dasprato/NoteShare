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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(allNotesView)
        NSLayoutConstraint.activate([allNotesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), allNotesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), allNotesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), allNotesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        let addNotesButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.setRightBarButtonItems([addNotesButton], animated: true)
        navigationItem.title = titleForNavBar
        fetchNotes()
    }
    
    @objc func addNote() {
        print("Trying to add a Note")
    }
    
    fileprivate func fetchNotes() {
        let db = Firestore.firestore()
        db.collection("Courses").document(titleForNavBar).collection("Notes").addSnapshotListener { snapshot, error in
            if error != nil {
                self.arrayOfNotes.removeAll()
                return
            } else {
                self.arrayOfNotes.removeAll()
                for document in (snapshot?.documents)! {
                    if let noteName = document.data()["noteName"] as? String {
//                        self.arrayOfNotes.append(Note(forCourse: forCourse, lectureInformation: document.data()["forCourse"], noteDescription: document.data()["forCourse"], noteName: document.data()["forCourse"], noteSize: document.data()["forCourse"], rating: document.data()["forCourse"], storageReference: document.data()["forCourse"]))
                        self.arrayOfNotes.append(Note(noteName: noteName))
                        self.allNotesView.arrayOfNotes = self.arrayOfNotes
                        DispatchQueue.main.async {
                           self.allNotesView.allNotesCollectionView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    
}
