//
//  Course.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import Foundation

struct Course: Decodable {
    let id: String?
    let code: String?
    let name: String?
    let description: String?
    let division: String?
    let department: String?
    let prerequisites: String?
    let exclusions: String?
    let campus: String?
    let term: String?
    let level: Int?
    let breadths: [Int]?
    let meeting_sections: [MeetingSection]?
    let isFavorite: Bool?
}

struct MeetingSection: Decodable {
    let code: String?
    let size: Int?
    let enrolment: Int?
    let instructors: [String]?
}


struct FirebaseCourse {
    let code: String?
    let department: String?
    let description: String?
    let level: Int?
    let name: String?
}
