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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        print("Keyboard Shown")
        
        
            newCommentBottomAnchor.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
                        self.layoutIfNeeded()


        })
        
        NotificationCenter.default.post(name: NSNotification.Name.init("keyboardOnChatWindowIsShown"), object: nil)
        if self.arrayOfComments != nil {
            self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: false)
        }
        

    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        print("Keyboard Hidden")
        
                newCommentBottomAnchor.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
                        self.layoutIfNeeded()

        })

        NotificationCenter.default.post(name: NSNotification.Name.init("keyboardOnChatWindowWentAway"), object: nil)
        if self.arrayOfComments != nil {
            self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: false)
        }
    }

    fileprivate func setupLabels() {
        addSubview(downloadSize)
        addSubview(uploadedBy)
        addSubview(noteDescription)
        addSubview(viewNote)
        
        
        NSLayoutConstraint.activate([viewNote.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), viewNote.topAnchor.constraint(equalTo: downloadSize.topAnchor), viewNote.heightAnchor.constraint(equalToConstant: 30)])
        
        NSLayoutConstraint.activate([downloadSize.topAnchor.constraint(equalTo: topAnchor, constant: 8), downloadSize.leftAnchor.constraint(equalTo: leftAnchor, constant: 8), downloadSize.heightAnchor.constraint(equalTo: viewNote.heightAnchor)])
        NSLayoutConstraint.activate([uploadedBy.topAnchor.constraint(equalTo: downloadSize.topAnchor), uploadedBy.leftAnchor.constraint(equalTo: downloadSize.rightAnchor, constant: 8), uploadedBy.heightAnchor.constraint(equalTo: viewNote.heightAnchor)])
        
        NSLayoutConstraint.activate([noteDescription.topAnchor.constraint(equalTo: downloadSize.topAnchor), noteDescription.leftAnchor.constraint(equalTo: uploadedBy.rightAnchor, constant: 8), noteDescription.rightAnchor.constraint(equalTo: viewNote.leftAnchor, constant: -8), noteDescription.heightAnchor.constraint(equalTo: viewNote.heightAnchor)])
        
        
    }
    
    fileprivate func setupButtons() {

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        setupLabels()
        setupButtons()
        addSubview(commentBackground)
        addSubview(newComment)
        addSubview(sendButton)
        newCommentBottomAnchor = newComment.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([newComment.leftAnchor.constraint(equalTo: downloadSize.leftAnchor), newComment.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8), newCommentBottomAnchor])
        
        NSLayoutConstraint.activate([commentBackground.leftAnchor.constraint(equalTo: leftAnchor), commentBackground.rightAnchor.constraint(equalTo: rightAnchor), commentBackground.topAnchor.constraint(equalTo: newComment.topAnchor), commentBackground.bottomAnchor.constraint(equalTo: newComment.bottomAnchor)])
        NSLayoutConstraint.activate([sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), sendButton.bottomAnchor.constraint(equalTo: newComment.bottomAnchor), sendButton.widthAnchor.constraint(equalToConstant: 32), sendButton.heightAnchor.constraint(equalToConstant: 32)])
        
        addSubview(commentsCollectionView)
        commentsCollectionView.dataSource = self
        commentsCollectionView.delegate = self
        commentsCollectionView.register(NewCommentsCollectionViewCell.self, forCellWithReuseIdentifier: commentsCollectionViewCellId)
        
        
        commentsCollectionViewBottomAnchor = commentsCollectionView.bottomAnchor.constraint(equalTo: newComment.topAnchor)
        NSLayoutConstraint.activate([commentsCollectionView.leftAnchor.constraint(equalTo: downloadSize.leftAnchor), commentsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), commentsCollectionViewBottomAnchor, commentsCollectionView.topAnchor.constraint(equalTo: noteDescription.bottomAnchor)])
        
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
        ds.text = "Prato Das"
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
        ds.backgroundColor = UIColor.clear
        ds.font = UIFont.systemFont(ofSize: 16)
        return ds
    }()
    
    var commentBackground: UIView = {
        let cb = UIView()
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        cb.layer.cornerRadius = 10.0
        return cb
    }()
    
    @objc func sendToFirebase() {
        let dict: [String: Any] = ["message": newComment.text, "messageOwner": "Mr Prato", "timeStamp":  String(describing: Date().timeIntervalSince1970)]
        let comment = Comment(message: newComment.text, messageOwner: "Mr Prato", timeStamp: String(describing: Date().timeIntervalSince1970))
        let db = Firestore.firestore()
        db.collection("Courses").document(note.forCourse).collection("Notes").document(note.noteName).collection("Comments").document("\(String(describing: Date().timeIntervalSince1970))").setData(dict)
        newComment.text = ""
        
//        IndexPath(row: (arrayOfComments?.count)! - 1, section: 0)

    }
    
    lazy var sendButton: UIButton = {
        let dn = UIButton()
        dn.clipsToBounds = true
        dn.translatesAutoresizingMaskIntoConstraints = false
        let titleImage = UIImage(named: "sendIcon")?.withRenderingMode(.alwaysTemplate)
        dn.setImage(titleImage, for: .normal)
        dn.tintColor = Constants.themeColor
        dn.addTarget(self, action: #selector(sendToFirebase), for: .touchUpInside)
        dn.layer.cornerRadius = 10.0
        dn.backgroundColor = UIColor.clear
        return dn
    }()
    
    lazy var viewNote: UIButton = {
        let vn = UIButton()
        vn.clipsToBounds = true
        vn.translatesAutoresizingMaskIntoConstraints = false
        vn.setTitle("->", for: .normal)
        vn.backgroundColor = Constants.themeColor
        vn.layer.cornerRadius = 10.0
        vn.addTarget(self, action: #selector(onViewNoteTapped), for: .touchUpInside)
        return vn
    }()
    
    @objc func onViewNoteTapped() {
        print("trying to view note")
        NotificationCenter.default.post(name: NSNotification.Name.init("onViewNoteTapped"), object: nil)
        
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
