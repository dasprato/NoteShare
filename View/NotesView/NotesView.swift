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

    let commentsCollectionViewCellId = "commentsCollectionViewCellId"
    let sameUserCommentCollectionViewCellId = "sameUserCommentCollectionViewCellId"
    var firstTime = true
    var arrayOfComments: [Comment]? {
        didSet {
            DispatchQueue.main.async {
                self.commentsCollectionView.reloadData()
                if (self.arrayOfComments?.count)! > 0 {
                if self.firstTime {
                self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: false)
                self.commentsCollectionView.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 20, options: .curveEaseOut, animations: {
                    self.commentsCollectionView.alpha = 1
                }, completion: { (_) in
                    return
                })
                    self.firstTime = false

                } else {
                    if (self.arrayOfComments?.count)! > 0 {
                    self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: true)
                    }
                }
            }
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
        
        
            newCommentBottomAnchor.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
                        self.layoutIfNeeded()


        })
        
        NotificationCenter.default.post(name: NSNotification.Name.init("keyboardOnChatWindowIsShown"), object: nil)
        
        guard let _ = self.arrayOfComments else { return }
        if (self.arrayOfComments?.count)! > 0 {
            self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: false)
        }
        

    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
                newCommentBottomAnchor.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
                        self.layoutIfNeeded()

        })

        NotificationCenter.default.post(name: NSNotification.Name.init("keyboardOnChatWindowWentAway"), object: nil)
        guard let _ = self.arrayOfComments else { return }
        if (self.arrayOfComments?.count)! > 0 && self.commentsCollectionView.isDragging == false {
            self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: false)
        }
    }

    fileprivate func setupLabels() {
        addSubview(downloadSize)
        addSubview(uploadedBy)
        addSubview(noteDescription)

        

        
        NSLayoutConstraint.activate([downloadSize.topAnchor.constraint(equalTo: topAnchor), downloadSize.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)])
        NSLayoutConstraint.activate([uploadedBy.topAnchor.constraint(equalTo: downloadSize.topAnchor), uploadedBy.leftAnchor.constraint(equalTo: downloadSize.rightAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([noteDescription.topAnchor.constraint(equalTo: downloadSize.topAnchor), noteDescription.leftAnchor.constraint(equalTo: uploadedBy.rightAnchor, constant: 8), noteDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
        
        
    }
    
    fileprivate func setupButtons() {

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(commentsCollectionView)
        addSubview(shadowView)
        setupLabels()
        setupButtons()
        addSubview(commentBackground)
        addSubview(newComment)
        addSubview(sendButton)

        newCommentBottomAnchor = newComment.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([newComment.leftAnchor.constraint(equalTo: downloadSize.leftAnchor), newComment.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8), newCommentBottomAnchor])
        
        NSLayoutConstraint.activate([commentBackground.leftAnchor.constraint(equalTo: leftAnchor), commentBackground.rightAnchor.constraint(equalTo: rightAnchor), commentBackground.topAnchor.constraint(equalTo: newComment.topAnchor), commentBackground.bottomAnchor.constraint(equalTo: newComment.bottomAnchor)])
        NSLayoutConstraint.activate([sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), sendButton.bottomAnchor.constraint(equalTo: newComment.bottomAnchor), sendButton.widthAnchor.constraint(equalToConstant: 32), sendButton.heightAnchor.constraint(equalToConstant: 32)])
        
        
        commentsCollectionView.dataSource = self
        commentsCollectionView.delegate = self
        commentsCollectionView.register(NewCommentsCollectionViewCell.self, forCellWithReuseIdentifier: commentsCollectionViewCellId)
        commentsCollectionView.register(SameUserCommentCollectionViewCell.self, forCellWithReuseIdentifier: sameUserCommentCollectionViewCellId)
        
        
        commentsCollectionViewBottomAnchor = commentsCollectionView.bottomAnchor.constraint(equalTo: newComment.topAnchor)
        NSLayoutConstraint.activate([commentsCollectionView.leftAnchor.constraint(equalTo: downloadSize.leftAnchor), commentsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8), commentsCollectionViewBottomAnchor, commentsCollectionView.topAnchor.constraint(equalTo: shadowView.bottomAnchor)])
        
        newComment.delegate = self
        NotificationCenter.default.addObserver(self, selector:#selector(NotesView.handleKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(NotesView.handleKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
// NotificationCenter.default.addObserver(self, selector: #selector(UITextInputDelegate.textDidChange(_:)), name: Notification.Name.UITextViewTextDidChange, object: self)
        
        NSLayoutConstraint.activate([shadowView.topAnchor.constraint(equalTo: downloadSize.topAnchor), shadowView.leftAnchor.constraint(equalTo: leftAnchor), shadowView.rightAnchor.constraint(equalTo: rightAnchor), shadowView.bottomAnchor.constraint(equalTo: downloadSize.bottomAnchor, constant: 8)])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shadowView.frame.width, height: shadowView.frame.height), cornerRadius: shadowView.layer.cornerRadius).cgPath
    }
    
    var shadowView: UIView = {
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor.white
        return sv
    }()
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

    
    func textViewDidChange(_ textView: UITextView) {
//        if (self.arrayOfComments?.count)! > 0 {
//            self.commentsCollectionView.scrollToItem(at: IndexPath(row: (self.arrayOfComments?.count)! - 1, section: 0), at: .bottom, animated: false)
//        }
//        layoutIfNeeded()
    }
    var commentBackground: UIView = {
        let cb = UIView()
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.backgroundColor = Constants.themeColor.withAlphaComponent(0.1)
        cb.layer.cornerRadius = 10.0
        return cb
    }()
    
    @objc func sendToFirebase() {
        
        let dict: [String: Any] = ["message": newComment.text, "timeStamp":  String(describing: Date().timeIntervalSince1970), "profileStorageReference": "Users/" + (Auth.auth().currentUser?.uid)! + "/", "messageOwnerEmail": CurrentSessionUser.user?.emailAddress]
        let db = Firestore.firestore()
        db.collection("Courses").document(note.forCourse).collection("Notes").document(note.timeStamp).collection("Comments").document(dict["timeStamp"] as! String).setData(dict)
        newComment.text = ""
        layoutIfNeeded()
        
//        IndexPath(row: (arrayOfComments?.count)! - 1, section: 0)

    }
    
    lazy var sendButton: UIButton = {
        let dn = UIButton(type: .system)
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
    

    @objc func onViewNoteTapped() {
        NotificationCenter.default.post(name: NSNotification.Name.init("onViewNoteTapped"), object: nil)
        
    }
    

    
    
    var commentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.clipsToBounds = true
        ma.backgroundColor = UIColor.white
        ma.layer.masksToBounds = true
        ma.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        ma.showsVerticalScrollIndicator = false
        ma.keyboardDismissMode = .onDrag
        ma.bounces = true
        ma.alwaysBounceVertical = true
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
        if arrayOfComments![indexPath.row].sameOwner == true {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sameUserCommentCollectionViewCellId, for: indexPath) as! SameUserCommentCollectionViewCell
        cell.comment = arrayOfComments?[indexPath.row]
        return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentsCollectionViewCellId, for: indexPath) as! NewCommentsCollectionViewCell
        cell.comment = arrayOfComments?[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let approximateWidth = collectionView.frame.width - 8 - 40 - 8
        let size = CGSize(width: approximateWidth, height: 1000000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        let estimatedFrame = NSString(string: (arrayOfComments?[indexPath.row].message)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        if arrayOfComments![indexPath.row].sameOwner == false {
        return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 22 + 16)
        } else {
            return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 15)
        }
    }
    
    
}
