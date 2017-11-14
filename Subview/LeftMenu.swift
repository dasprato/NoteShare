//
//  LeftMenuController.swift
//  WEVER
//
//  Created by Prato Das on 2017-11-07.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import Foundation
import UIKit

class LeftMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    public weak var delegate: LeftMenuDelegate?

    
    let cellId = "cellId"
    let menuItems = ["Notes", "Courses", "Settings"]
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = Constants.themeColor
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var nameLabel: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.textColor = UIColor.white
        nl.font = UIFont.boldSystemFont(ofSize: nl.font.pointSize)
        return nl
    }()
    
    var emailLabel: UILabel = {
        let el = UILabel()
        el.translatesAutoresizingMaskIntoConstraints = false
        el.textColor = UIColor.white
        return el
    }()
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.orange
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var profileDetails: UIView = {
        let pd = UIView()
        pd.translatesAutoresizingMaskIntoConstraints = false
        pd.backgroundColor = Constants.themeColor
        pd.clipsToBounds = true
        return pd
    }()
    
    var nameAndEmailView: UIView = {
        let nae = UIView()
        nae.translatesAutoresizingMaskIntoConstraints = false
        nae.backgroundColor = Constants.themeColor
        nae.clipsToBounds = true
        return nae
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 10
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 100
        // profileDetails
        addSubview(profileDetails)
        profileDetails.addSubview(nameAndEmailView)
        profileDetails.addSubview(profileImageView)
        nameAndEmailView.addSubview(nameLabel)
        nameLabel.text = "Prato Das"
        nameAndEmailView.addSubview(emailLabel)
        emailLabel.text = "pratodas@ymail.com"
        addSubview(tableView)
        

       
        NSLayoutConstraint.activate([profileDetails.topAnchor.constraint(equalTo: topAnchor), profileDetails.widthAnchor.constraint(equalTo: widthAnchor), profileDetails.leftAnchor.constraint(equalTo: leftAnchor), profileDetails.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)])
        
        // profileImageView
        NSLayoutConstraint.activate([profileImageView.leftAnchor.constraint(equalTo: profileDetails.leftAnchor, constant: 15), profileImageView.centerYAnchor.constraint(equalTo: profileDetails.centerYAnchor), profileImageView.widthAnchor.constraint(equalToConstant: 64), profileImageView.heightAnchor.constraint(equalToConstant: 64)])
        profileImageView.layer.cornerRadius = 32
        
        // nameAndEmailView
        NSLayoutConstraint.activate([nameAndEmailView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor), nameAndEmailView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 6), nameAndEmailView.heightAnchor.constraint(equalToConstant: 32), nameAndEmailView.rightAnchor.constraint(equalTo: profileDetails.rightAnchor, constant: -6)])
        
        // nameLabel
        NSLayoutConstraint.activate([nameLabel.leftAnchor.constraint(equalTo: nameAndEmailView.leftAnchor), nameLabel.topAnchor.constraint(equalTo: nameAndEmailView.topAnchor), nameLabel.heightAnchor.constraint(equalToConstant: 16), nameLabel.widthAnchor.constraint(equalTo: nameAndEmailView.widthAnchor)])
        nameLabel.adjustsFontSizeToFitWidth = true
        // emailLabel
                NSLayoutConstraint.activate([emailLabel.leftAnchor.constraint(equalTo: nameAndEmailView.leftAnchor), emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor), emailLabel.heightAnchor.constraint(equalToConstant: 16), emailLabel.widthAnchor.constraint(equalTo: nameAndEmailView.widthAnchor)])
        emailLabel.adjustsFontSizeToFitWidth = true

        

        
        // table view
        NSLayoutConstraint.activate([tableView.widthAnchor.constraint(equalTo: widthAnchor), tableView.topAnchor.constraint(equalTo: profileDetails.bottomAnchor), tableView.bottomAnchor.constraint(equalTo: bottomAnchor), tableView.leftAnchor.constraint(equalTo: leftAnchor)])
        
        tableView.register(MenuScrollCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuScrollCell
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell.textLabel?.font.pointSize)!)
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.frame.height / 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isHidden = true
        switch self.menuItems[indexPath.row] {
        case "Courses":
            let viewController = CoursesController()
            self.delegate?.leftMenuDidSelectViewController(viewController)
//        case "Payments":
//            let viewController = PaymentsController()
//            self.delegate?.leftMenuDidSelectViewController(viewController)
//        case "Profile":
//            let viewController = ProfileController()
//            self.delegate?.leftMenuDidSelectViewController(viewController)
//        case "Trip History":
//            let viewController = TripHistoryController()
//            self.delegate?.leftMenuDidSelectViewController(viewController)
//        case "Referral":
//            let viewController = ReferralController()
//            self.delegate?.leftMenuDidSelectViewController(viewController)
//        case "Help":
//            let viewController = HelpController()
//            self.delegate?.leftMenuDidSelectViewController(viewController)
//        case "Settings":
//            let viewController = SettingsController()
//            self.delegate?.leftMenuDidSelectViewController(viewController)
//        case "About":
//            let viewController = AboutController()
//            self.delegate?.leftMenuDidSelectViewController(viewController)
        default:
            break
        }
        
        // tableView.deselectRow(at: indexPath, animated: false)

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.black
    }
    
    func openViewController() {
        print("")
    }
}


protocol LeftMenuDelegate: class {
    func leftMenuDidSelectViewController(_ viewController: UIViewController)
}



