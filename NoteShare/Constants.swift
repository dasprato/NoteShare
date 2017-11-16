//
//  Constants.swift
//  NoteShare
//
//  Created by Prato Das on 2017-11-14.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import Foundation
import UIKit


struct Constants {
    static let themeColor = UIColor(red: 0, green: 45/255, blue: 103/255, alpha: 1)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
