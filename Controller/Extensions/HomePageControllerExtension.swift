//
//  HomePageControllerExtension.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-17.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension HomePageController {
func fetchNotes() {
    
    let db = Firestore.firestore()
    
    let settings = FirestoreSettings()
    settings.isPersistenceEnabled = true
    db.settings = settings
    
    
    guard let unwrappedUserId = Auth.auth().currentUser?.uid else { return }
    print("UID from app delegate is:\(unwrappedUserId)")
    let listenerForNotes = db.collection("Users").document(unwrappedUserId).collection("favoriteNotes").addSnapshotListener { snapshot, error in
        if error != nil {
            CurrentSessionUser.favoriteNotesReferencePath.removeAll()
            self.homePageView.arrayOfCoursesReferencePath = CurrentSessionUser.favoriteCoursesReferencePath
            return
        } else {
            CurrentSessionUser.favoriteNotesReferencePath.removeAll()
            
            for document in (snapshot?.documents)! {
                if let noteName = document.data()["referencePath"] as? String
                {
                    CurrentSessionUser.favoriteNotesReferencePath.append(noteName)
                    
                    
                }
            }
            self.homePageView.arrayOfNotesReferencePath = CurrentSessionUser.favoriteNotesReferencePath
            
        }
    }
    if listenerForNotes != nil {
        CurrentSessionUser.favoriteNotesReferencePath.removeAll()
        self.homePageView.arrayOfCoursesReferencePath = CurrentSessionUser.favoriteCoursesReferencePath
    }
    
}


func fetchCourses() {
    let db = Firestore.firestore()
    
    let settings = FirestoreSettings()
    settings.isPersistenceEnabled = true
    db.settings = settings
    
    
    guard let unwrappedUserId = Auth.auth().currentUser?.uid else { return }
    print("UID from app delegate is:\(unwrappedUserId)")
    let listenForCourse = db.collection("Users").document(unwrappedUserId).collection("favoriteCourses").addSnapshotListener { snapshot, error in
        if error != nil {
            CurrentSessionUser.favoriteCoursesReferencePath.removeAll()
            self.homePageView.arrayOfCoursesReferencePath = CurrentSessionUser.favoriteCoursesReferencePath
            return
        } else {
            CurrentSessionUser.favoriteCoursesReferencePath.removeAll()
            
            for document in (snapshot?.documents)! {

                    CurrentSessionUser.favoriteCoursesReferencePath.append(document.data()["referencePath"] as! String)

            }
            
            self.homePageView.arrayOfCoursesReferencePath = CurrentSessionUser.favoriteCoursesReferencePath
            
            print(CurrentSessionUser.favoriteCoursesReferencePath)
        }
    }
    if listenForCourse != nil {
        CurrentSessionUser.favoriteCoursesReferencePath.removeAll()
        self.homePageView.arrayOfCoursesReferencePath = CurrentSessionUser.favoriteCoursesReferencePath
    }
    
}

}
