//
//  UserProfileController.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/9/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Firebase

var numberOfPosts: Int?

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    
    var userId : String?
    
    let cellID = "cellID"
    let listCellID = "listCellID"
    
    var isOnGrid = true
    
    func didChangeToListView() {
        
        print("DELEGAT LIST")
        isOnGrid = false
        collectionView?.reloadData()
        
    }
    
    func didChangeToGridView() {
        
        print("DELEGAT GRID")
        isOnGrid = true
        collectionView?.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        UINavigationBar.appearance().tintColor = UIColor.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logOut))
        
        
        
        
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: listCellID)
        
        fetchUser()
    }
    
    var posts = [Post]()
    
    fileprivate func paginatePost() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            let allObjects = snapshot.children.allObjects as? [DataSnapshot]
            allObjects?.forEach({ (snapshot) in
                
                print(snapshot.key)
                
            })
            
            
        }) { (err) in
            print("Faild to paginate posts", err)
        }
        
    }
    
    fileprivate func fetchOrderdPosts() {
       
        guard let uid = user?.uid else { return }
        
        let userRef = Database.database().reference().child("posts").child(uid)
        
        userRef.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String:Any] else { return }

            
            guard let user = self.user else { return }
           
            let post = Post(user: user, dict: dict)
            
            
                self.posts = [post] + self.posts
                self.collectionView?.reloadData()
                
            
            
            
        }) { (err) in
            
            print("Faild to fetch posts", err)
        }
        
        
    }
    
    
    @objc fileprivate func logOut() {
        
        print(collectionView?.visibleCells.count ?? "XXX") 
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertActionStyle.default, handler: logOutHandler))
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
       
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    func logOutHandler(action: UIAlertAction) {
       
        do {
        
            try Auth.auth().signOut()
            
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            
            self.present(navController, animated: true, completion: nil)
        
        } catch let signOutErr {
            print("Faild to sign out", signOutErr)
        }
        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isOnGrid == true {
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfilePhotoCell
           cell.post = posts[indexPath.item]
           return cell
        
        } else {
           
            let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellID, for: indexPath) as! HomePostCell
            listCell.post = posts[indexPath.item]
            return listCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isOnGrid == true {
           let size = ( view.frame.width - 2 ) / 3
           return CGSize(width: size, height: size)
        } else {
           let size = CGFloat(8+8+36) + view.frame.size.width + 50 + 60
           return CGSize(width: view.frame.size.width, height: size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
     
        header.user = self.user
        header.delegate = self
        
        return header

    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        return CGSize(width: view.frame.width, height: 200)
        
    }
    
    
    var user : User? 
    
    fileprivate func fetchUser() {
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView?.reloadData()
            
            self.fetchOrderdPosts()
            self.paginatePost()
        }
        
    }

    
    
}



