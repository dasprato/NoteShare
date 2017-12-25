//
//  CourseView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-11-14.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class CourseView: UIView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var code: String?
    var pckCoursesBottomAnchor: NSLayoutConstraint!
    var allCourses: [String] = []
    var coursesToView: [String] = []
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCourses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = allCourses[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:Constants.themeColor])
        return myTitle
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if allCourses.count > 0 {
//            let titleData = allCourses[row]
//            txtSearch.text = titleData
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true

        pckCourses.delegate = self
        pckCourses.dataSource = self
        pckCourses.isHidden = true
        
        addSubview(pckCourses)
        addSubview(txtSearch)
        pckCoursesBottomAnchor = pckCourses.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([txtSearch.leftAnchor.constraint(equalTo: leftAnchor, constant: 5), txtSearch.rightAnchor.constraint(equalTo: rightAnchor, constant: -5), txtSearch.topAnchor.constraint(equalTo: topAnchor, constant: 44), txtSearch.heightAnchor.constraint(equalToConstant: 44)])
        NSLayoutConstraint.activate([pckCourses.leftAnchor.constraint(equalTo: leftAnchor, constant: 5), pckCourses.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),  pckCourses.topAnchor.constraint(equalTo: txtSearch.bottomAnchor), pckCourses.heightAnchor.constraint(equalToConstant: 90)])
    
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(reloadPickerView))
        toolbar.setItems([doneButton], animated: false)
        txtSearch.inputAccessoryView = toolbar
    }
    
    func reloadPickerView() {
        DispatchQueue.main.async {
        self.pckCourses.reloadAllComponents()
        }
    }
    
    @objc func fetchCourses() {
       
        code = txtSearch.text
        
        print(code)
        var codeToUse = code ?? ""
        guard let urlOnline = URL(string: "https://timetable.iit.artsci.utoronto.ca/api/20179/courses?code=" + codeToUse) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: urlOnline) { (data, response, error) in
            if let response = response {
                //print(response)
            }
            if let data = data {
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    var dict = json as? [String: Any]
                    if let dict = dict {
                        self.allCourses.removeAll()
                        for (kind, _) in dict {
                            
                            self.allCourses.append(kind)
                        }
                        self.reloadPickerView()
                    }
                    if dict?.count == 0 {
                        self.allCourses.removeAll()
                        self.reloadPickerView()
                    }
                } catch {
                    self.allCourses.removeAll()
                    self.reloadPickerView()
                }
            }
            }.resume()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var txtSearch: UITextField = {
        let ts = UITextField()
        ts.translatesAutoresizingMaskIntoConstraints = false
        ts.clipsToBounds = true
        ts.isUserInteractionEnabled = true
        ts.backgroundColor = Constants.themeColor
        ts.textColor = UIColor.white
        ts.textAlignment = .center
        ts.addTarget(self, action: #selector(search), for: .editingChanged)
        //ts.addTarget(self, action: #selector(search), for: .allEvents)
        return ts
    }()
    
    func search() {
        guard let tempString = txtSearch.text else {return}
        
        if txtSearch.text?.count == 0 {
            pckCourses.isHidden = true
            
        } else if tempString.count > 0 && tempString.count < 4{
            self.allCourses.removeAll()
            reloadPickerView()
            code = txtSearch.text
            pckCourses.isHidden = true
            
        } else {
            self.allCourses.removeAll()
            reloadPickerView()
            code = txtSearch.text
            pckCourses.isHidden = false
            fetchCourses()
        }

    }
    
    var pckCourses: UIPickerView = {
        let pc = UIPickerView()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.clipsToBounds = true
        pc.isUserInteractionEnabled = true
        return pc
    }()
    
}
