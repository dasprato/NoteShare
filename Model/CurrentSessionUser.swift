//
//  CurrentSessionUser.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-13.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import Foundation

final public class CurrentSessionUser {
    private init() {}
    static var user: FirebaseUser?
    static var gmailEmail: String?
    static var profileImageUrl: String = ""
    static var name: String = ""
}
