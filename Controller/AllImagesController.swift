//
//  AllImagesController.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-24.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct Album: Decodable {
//{
//    "albumId": 1,
//    "id": 1,
//    "title": "accusamus beatae ad facilis cum similique qui sunt",
//    "url": "http://placehold.it/600/92c952",
//    "thumbnailUrl": "http://placehold.it/150/92c952"
//    }
    let albumId: Int
    let id: Int
    let title: String
    let url: String
}


class AllImagesController: UIViewController {


    let imageCollectionViewCellId = "imageCollectionViewCellId"
    var arrayOfUrl = [String]()
    fileprivate func fetchURLs() {
        let db = Firestore.firestore()
//        db.collection("images").getDocuments { (snapshot, error) in
//            if error != nil {
//                return
//            } else {
//                for document in (snapshot?.documents)! {
//                    if let data = document.data()["bytes"] as? NSData {
//                        self.arrayOfData.append(data)
//                        DispatchQueue.main.async {
//                            self.imageCollectionView.reloadData()
//                        }
//                    }
//                }
//
//            }
//        }
        
        db.collection("imageURLs").addSnapshotListener { snapshot, error in
            if error != nil {
                self.arrayOfUrl.removeAll()
                return
            } else {
                self.arrayOfUrl.removeAll()
                for document in (snapshot?.documents)! {
                    if let url = document.data()["url"] as? String {
                        self.arrayOfUrl.append(url)
                        DispatchQueue.main.async {
                            self.imageCollectionView.reloadData()
                        }
                        print(self.arrayOfUrl.count)
                    }
                }
                
            }
        }
//        ViewController.swift
        
//        let jsonUrlString = "https://jsonplaceholder.typicode.com/photos"
//        guard let url = URL(string: jsonUrlString) else { return }
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//            guard let data = data else { return }
//            do {
//                let courses = try JSONDecoder().decode([Album].self, from: data)
//
//                for eachitem in courses {
//                    self.albumsForDataSource.append(eachitem)
//                }
//                DispatchQueue.main.async {
//                    self.imageCollectionView.reloadData()
//                }
//            } catch let jsonErr {
//                print ("Error serializing json")
//            }
//            }.resume()
    }
    
    
    var closeButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.setTitleColor(Constants.themeColor, for: .normal)
        mb.setTitle("Close", for: .normal)
        mb.isUserInteractionEnabled = true
        mb.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        mb.contentHorizontalAlignment = .left
        return mb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchURLs()
        view.backgroundColor = UIColor.blue
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: imageCollectionViewCellId)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        
        view.addSubview(imageCollectionView)
        
        view.addSubview(closeButton)
        
        
        NSLayoutConstraint.activate([closeButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8), closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8), closeButton.heightAnchor.constraint(equalToConstant: 44)])
        
        NSLayoutConstraint.activate([imageCollectionView.topAnchor.constraint(equalTo: closeButton.topAnchor, constant: 44), imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), imageCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor), imageCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor)])
        
    }
    
    var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        let rcv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        rcv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        rcv.backgroundColor = UIColor.white
        rcv.translatesAutoresizingMaskIntoConstraints = false
        rcv.keyboardDismissMode = .interactive
        rcv.clipsToBounds = true
        rcv.showsVerticalScrollIndicator = false
        return rcv
    }()
    
    @objc func closeView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension AllImagesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionViewCellId, for: indexPath) as! ImageCollectionViewCell
//        cell.profileImageView.image = UIImage(data: arrayOfUrl[indexPath.row] as Data)
                cell.profileImageView.sd_setImage(with: URL(string: arrayOfUrl[indexPath.row]), placeholderImage: #imageLiteral(resourceName: "profileIcon"), options: [.continueInBackground, .progressiveDownload])
        
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
}
