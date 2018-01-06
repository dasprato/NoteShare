//
//  AllCoursesController.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-30.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class AllCoursesController: UIViewController {

    var allCoursesView = AllCoursesView()
    var arrayOfCourses = [Course]()
    
    var jsonUrl = "https://cobalt.qas.im/api/1.0/courses/filter?key=zQAdmFEhDSHkUrnh16gxs2BNiSL6UYB7&q=code:"
    var courseCode = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCourses()
        view.backgroundColor = UIColor.white
        view.addSubview(allCoursesView)
        NSLayoutConstraint.activate([allCoursesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), allCoursesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), allCoursesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), allCoursesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        NSLayoutConstraint.activate([searchTextField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.85)])
        let barSearchTextField = UIBarButtonItem(customView: searchTextField)
        navigationItem.setRightBarButton(barSearchTextField, animated: true)
        navigationController?.navigationItem.title = ""
        navigationItem.title = ""
        navigationController?.navigationBar.shadowImage = UIImage()
        setupObservers()
        
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(openAllNotes), name: NSNotification.Name(rawValue: "openAllNotes"), object: nil)
    }
    
    
    @objc func openAllNotes() {
        let viewControllerToPush = AllNotesController()
        viewControllerToPush.titleForNavBar = self.arrayOfCourses[(allCoursesView.currentCell?.row)!].code
        viewControllerToPush.course = self.arrayOfCourses[(allCoursesView.currentCell?.row)!]
        self.navigationController?.pushViewController(viewControllerToPush, animated: true)
    }

    
    
    fileprivate func fetchCourses() {
        guard let url = URL(string: jsonUrl + courseCode + "&limit=100") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            self.arrayOfCourses.removeAll()
            guard let data = data else { return }
            if (err != nil) {
                print("Big big error")
            }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                
                for eachitem in courses {
                    if eachitem.code.lowercased().hasPrefix(self.courseCode.lowercased()) {
                    self.arrayOfCourses.append(eachitem)
                    }
                }
                self.allCoursesView.arrayOfCourses = self.arrayOfCourses
//                print(self.allCoursesView.arrayOfCourses?.count)

            } catch let jsonErr {
                print (jsonErr.localizedDescription)
            }
            }.resume()
    }
    
    @objc func allChangingTextField() {
        if searchTextField.text?.isEmpty == false {
            courseCode = searchTextField.text!
        }
        fetchCourses()
    }
    
    lazy var searchTextField: UITextField = {
        let stf = UITextField()
        stf.translatesAutoresizingMaskIntoConstraints = false
        stf.placeholder = "Search"
        stf.borderStyle = .none
        stf.addTarget(self, action: #selector(allChangingTextField), for: .allEditingEvents)
        stf.backgroundColor = UIColor.clear
        stf.textColor = Constants.themeColor
        stf.font = UIFont.boldSystemFont(ofSize: (stf.font?.pointSize)!)
        return stf
    }()
    
    
}