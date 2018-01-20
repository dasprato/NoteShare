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

    var allNotesView = AllNotesView()
    var arrayOfNotes = [Note]()
    var titleForNavBar = ""
    var listener: ListenerRegistration!
    var course: Course!
    var firebaseCourse: FirebaseCourse!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(allNotesView)
        NSLayoutConstraint.activate([allNotesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), allNotesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), allNotesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), allNotesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        let addNotesButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadNote))
        navigationItem.title = titleForNavBar
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Constants.themeColor]
        navigationController?.navigationBar.shadowImage = UIImage()

        setupObservers()
        
        let barHome = UIBarButtonItem(image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onHomeTapped))
        navigationItem.setRightBarButtonItems([addNotesButton, barHome], animated: true)
    }
    
    @objc func onHomeTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showError), name: NSNotification.Name(rawValue: "noNoteFoundError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showNote), name: NSNotification.Name(rawValue: "showNote"), object: nil)
        
    }
    

    
    @objc func showNote() {
        let viewControllerToPush = NotesController()
        guard let unwrappedCurrentCell = allNotesView.currentCell else { return }
        if unwrappedCurrentCell.row > self.arrayOfNotes.count { return }
        viewControllerToPush.titleForNavBar = self.arrayOfNotes.reversed()[unwrappedCurrentCell.row].noteName!
        viewControllerToPush.note = arrayOfNotes.reversed()[(allNotesView.currentCell?.row)!]
        

        self.navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    @objc func uploadNote() {
        if self.course != nil {
        let viewControllerToPresent = UploadNotesController()
        viewControllerToPresent.course = self.course
        self.present(UINavigationController(rootViewController: viewControllerToPresent), animated: true, completion: nil)
        } else {
            let viewControllerToPresent = UploadNotesController()
            viewControllerToPresent.firebaseCourse = self.firebaseCourse
            self.present(UINavigationController(rootViewController: viewControllerToPresent), animated: true, completion: nil)
        }
    }
    
    fileprivate func fetchNotes() {
        let db = Firestore.firestore()

        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
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
                        let rating = document.data()["rating"] as? Int,
                        let referencePath = document.data()["referencePath"] as? String,
                        let timeStamp = document.documentID as? String
                    {
                        self.arrayOfNotes.append(Note(forCourse: forCourse, lectureInformation: lectureInformation, noteDescription: noteDescription, noteName: noteName, noteSize: noteSize, rating: rating, referencePath: referencePath, storageReference: storageReference, timeStamp: timeStamp, isFavorite: false))
                        

                        

                    }
                    
                }
                for i in 0..<self.arrayOfNotes.count {
                    for j in 0..<CurrentSessionUser.favoriteNotes.count {
                        
                        if CurrentSessionUser.favoriteNotes[j].timeStamp == self.arrayOfNotes[i].timeStamp {
                            self.arrayOfNotes[i].isFavorite = true
                        }
                    }
                }
                self.allNotesView.arrayOfNotes = self.arrayOfNotes
                
            }
        }
        
    }

    
    @objc func showError() {
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
        print("listener removed from this course")
        self.arrayOfNotes.removeAll()
        self.allNotesView.arrayOfNotes = self.arrayOfNotes
        
        
        removeShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeShadow()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchNotes()
        addShadow()
    }
    
}
