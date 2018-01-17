//
//  CommentsController.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 9/25/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Firebase


class CommentsController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var post: Post?
    let cellID = "cellID"
    var width : CGFloat = 0
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        width = view.frame.width
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellID)
        
        fetchComments()
        
    
    }
    
   

    
    
    
    var comments = [Comment]()
    
    func fetchComments() {
        
        guard let postId = post?.id else { return }
        
        let ref = Database.database().reference().child("comments").child(postId)
       
        ref.observe(.childAdded, with: { (snapshot) in
            
            let dictionary = snapshot.value as! [String: Any]
            
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUserWithUID(uid: uid, complition: { (user) in
                var comment = Comment(dictionary: dictionary)
                comment.user = user
                self.comments.append(comment)
               
                self.comments.sort(by: { (u1, u2) -> Bool in
                    
                    return u1.creationDate < u2.creationDate
                })
                
                print("XXXXXX")
                self.collectionView?.reloadData()
            })
            
            
            
            
            
            
        }) { (err) in
            print("Failed to observe comments")
        }
        
    }
    
    
    
    
    lazy var containerView : UIView = {
        
        let containerView = UIView()
        containerView.isUserInteractionEnabled = true
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let line = UIView()
        line.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        let postButton = UIButton(type: .system)
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        postButton.setTitleColor(.blue, for: .normal)
        postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        
        containerView.addSubview(postButton)
        postButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0, centerX: nil, centerY: nil)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: postButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        
        containerView.addSubview(line)
        line.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: postButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: -12, width: 0, height: 1, centerX: nil, centerY: nil)
        
        return containerView
        
    }()
    
    let commentTextField : UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Add comment..."
        return textField
    }()
    
    override var inputAccessoryView: UIView? {
        
        get {
          
            return containerView
        }
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func postButtonPressed() {
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let postID = post?.id else { return }
        let values = ["text" : commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        
        Database.database().reference().child("comments").child(postID).childByAutoId().updateChildValues(values) { (err,ref) in
    
            if let err = err {
                print("Faild to insert comment",err)
            }
            
            print("Successfuly entered comment")
            self.commentTextField.text = ""
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentsCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentsCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
