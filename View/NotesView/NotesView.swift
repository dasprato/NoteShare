//
//  NotesView.swift
//  NoteShare
//
//  Created by Prato Das on 2017-12-31.
//  Copyright © 2017 Prato Das. All rights reserved.



//

import UIKit
import Firebase
class NotesView: UIView, UITextViewDelegate {

    let  commentsCollectionViewCellId = "commentsCollectionViewCellId"
    var arrayOfComments: [Comment]? {
        didSet {
            DispatchQueue.main.async {
                self.commentsCollectionView.reloadData()
                self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    var note: Note!
    var newCommentBottomAnchor: NSLayoutConstraint!
    var commentsCollectionViewBottomAnchor: NSLayoutConstraint!
    
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        print("Keyboard Shown")
        
        
            newCommentBottomAnchor.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
                        self.layoutIfNeeded()
                        self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: false)
        })
        

    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        print("Keyboard Hidden")
        
                newCommentBottomAnchor.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
                        self.layoutIfNeeded()
                                    self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: false)
        })
    }

    fileprivate func setupLabels() {
        addSubview(downloadSize)
        addSubview(uploadedBy)
        addSubview(noteDescription)
        
        NSLayoutConstraint.activate([downloadSize.topAnchor.constraint(equalTo: topAnchor, constant: 8), downloadSize.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)])
        NSLayoutConstraint.activate([uploadedBy.topAnchor.constraint(equalTo: downloadSize.topAnchor), uploadedBy.leftAnchor.constraint(equalTo: downloadSize.rightAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([noteDescription.topAnchor.constraint(equalTo: downloadSize.bottomAnchor, constant: 8), noteDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)])
        
        
    }
    
    fileprivate func setupButtons() {
        addSubview(downloadNote)
        addSubview(viewNote)
        
        NSLayoutConstraint.activate([downloadNote.leftAnchor.constraint(equalTo: downloadSize.leftAnchor), downloadNote.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4), downloadNote.topAnchor.constraint(equalTo: noteDescription.bottomAnchor, constant: 8), downloadNote.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([viewNote.leftAnchor.constraint(equalTo: downloadNote.rightAnchor, constant: 8), viewNote.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4), viewNote.topAnchor.constraint(equalTo: noteDescription.bottomAnchor, constant: 8), viewNote.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        setupLabels()
        setupButtons()
        
        addSubview(newComment)
        addSubview(sendButton)
        newCommentBottomAnchor = newComment.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([newComment.leftAnchor.constraint(equalTo: downloadSize.leftAnchor), newComment.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8), newCommentBottomAnchor])
        NSLayoutConstraint.activate([sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), sendButton.bottomAnchor.constraint(equalTo: newComment.bottomAnchor), sendButton.widthAnchor.constraint(equalToConstant: 32), sendButton.heightAnchor.constraint(equalToConstant: 32)])
        
        addSubview(commentsCollectionView)
        commentsCollectionView.dataSource = self
        commentsCollectionView.delegate = self
        commentsCollectionView.register(NewCommentsCollectionViewCell.self, forCellWithReuseIdentifier: commentsCollectionViewCellId)
        
        
        commentsCollectionViewBottomAnchor = commentsCollectionView.bottomAnchor.constraint(equalTo: newComment.topAnchor)
        NSLayoutConstraint.activate([commentsCollectionView.leftAnchor.constraint(equalTo: downloadSize.leftAnchor), commentsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), commentsCollectionViewBottomAnchor, commentsCollectionView.topAnchor.constraint(equalTo: downloadNote.bottomAnchor)])
        
        newComment.delegate = self
        NotificationCenter.default.addObserver(self, selector:#selector(NotesView.handleKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(NotesView.handleKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var downloadSize: FlexibleTextView = {
        let ds = FlexibleTextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.textAlignment = .left
        ds.textColor = UIColor.lightGray
        ds.layer.cornerRadius = 10.0
        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        ds.isUserInteractionEnabled = false
        return ds
    }()
    
    var uploadedBy: FlexibleTextView = {
        let ds = FlexibleTextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.text = "Uploaded by: "
        ds.textAlignment = .left
        ds.textColor = UIColor.gray
        ds.layer.cornerRadius = 10.0
        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        ds.isUserInteractionEnabled = false
        return ds
    }()
    
    var noteDescription: FlexibleTextView = {
        let ds = FlexibleTextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
                ds.textAlignment = .left
//        ds.font = UIFont.boldSystemFont(ofSize: (ds.font?.pointSize)!)
        ds.textColor = UIColor.gray
        ds.layer.cornerRadius = 10.0
        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        ds.isUserInteractionEnabled = false
        return ds
    }()
    
    var newComment: FlexibleTextView = {
        let ds = FlexibleTextView()
        ds.translatesAutoresizingMaskIntoConstraints = false
        ds.text = ""
        ds.textAlignment = .left
        ds.textColor = UIColor.gray
        ds.layer.cornerRadius = 10.0
        ds.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        ds.font = UIFont.systemFont(ofSize: 14)
        return ds
    }()
    
    func sendToFirebase() {
        let dict: [String: Any] = ["message": newComment.text, "messageOwner": "Mr Prato", "timeStamp":  String(describing: Date().timeIntervalSince1970)]
        let comment = Comment(message: newComment.text, messageOwner: "Mr Prato", timeStamp: String(describing: Date().timeIntervalSince1970))
        let db = Firestore.firestore()
        db.collection("Courses").document(note.forCourse).collection("Notes").document(note.noteName).collection("Comments").document("\(String(describing: Date().timeIntervalSince1970))").setData(dict)
        newComment.text = ""
        
//        IndexPath(row: (arrayOfComments?.count)! - 1, section: 0)

    }
    lazy var downloadNote: UIButton = {
        let dn = UIButton()
        dn.clipsToBounds = true
        dn.translatesAutoresizingMaskIntoConstraints = false
        dn.setTitle("Download Note", for: .normal)
        dn.backgroundColor = Constants.themeColor
        dn.addTarget(self, action: #selector(onDownloadNoteTapped), for: .touchUpInside)
        dn.layer.cornerRadius = 10.0
        return dn
    }()
    
    lazy var sendButton: UIButton = {
        let dn = UIButton()
        dn.clipsToBounds = true
        dn.translatesAutoresizingMaskIntoConstraints = false
        let titleImage = UIImage(named: "sendIcon")?.withRenderingMode(.alwaysTemplate)
        dn.setImage(titleImage, for: .normal)
        dn.tintColor = Constants.themeColor
        dn.addTarget(self, action: #selector(sendToFirebase), for: .touchUpInside)
        dn.layer.cornerRadius = 10.0
        return dn
    }()
    
    lazy var viewNote: UIButton = {
        let vn = UIButton()
        vn.clipsToBounds = true
        vn.translatesAutoresizingMaskIntoConstraints = false
        vn.setTitle("View Note", for: .normal)
        vn.backgroundColor = Constants.themeColor
        vn.layer.cornerRadius = 10.0
        vn.addTarget(self, action: #selector(onViewNoteTapped), for: .touchUpInside)
        return vn
    }()
    
    @objc func onViewNoteTapped() {
        print("trying to view note")
    }
    
    @objc func onDownloadNoteTapped() {
        print("trying to donwloadNote")
    }
    
    
    var commentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.clipsToBounds = true
        ma.backgroundColor = UIColor.white
        ma.layer.masksToBounds = true
        ma.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        ma.showsVerticalScrollIndicator = false
        ma.keyboardDismissMode = .onDrag
        ma.bounces = true
        return ma
    }()
    

}


extension NotesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfComments == nil {
            return 0
        } else {
            return arrayOfComments!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentsCollectionViewCellId, for: indexPath) as! NewCommentsCollectionViewCell
        cell.comment = arrayOfComments?[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
    
}
