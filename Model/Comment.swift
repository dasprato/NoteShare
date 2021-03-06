//
//  Comment.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-31.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import Foundation

struct Comment {
    let message: String
    let timeStamp: String
    let sameOwner: Bool
    let profileStorageReference: String?
    let messageOwnerEmail: String?
}
