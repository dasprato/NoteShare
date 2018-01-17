//
//  DatabaseGetAdapter.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import Foundation

class DatabaseGetAdapter {
    

    static func fetchCourses(with courseCode: String) -> [Course] {
        var arrayOfCourses = [Course]()
        guard let url = URL(string: "https://cobalt.qas.im/api/1.0/courses/filter?key=zQAdmFEhDSHkUrnh16gxs2BNiSL6UYB7&q=code:" + courseCode + "&limit=100") else { return arrayOfCourses }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            arrayOfCourses.removeAll()
            guard let data = data else { return  }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                
                for eachitem in courses {
                    if (eachitem.code?.lowercased().hasPrefix(courseCode.lowercased()))! {
                        arrayOfCourses.append(eachitem)
                    }
                }
                print("number in model: ")
                print(arrayOfCourses.count)
                
                
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
        
        print("final number in model: ")
        print(arrayOfCourses.count)
        
        return arrayOfCourses

    }
    
    
}
