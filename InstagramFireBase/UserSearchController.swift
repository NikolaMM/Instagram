//
//  UserSearchController.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/19/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController : UICollectionViewController, UICollectionViewDelegateFlowLayout , UISearchBarDelegate {
    
    let cellId = "cellId"
    
    let searchBar : UISearchBar = {
        
        let sb = UISearchBar()
        
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        sb.placeholder = "Search"
        return sb
        
    }()
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText.isEmpty {
            
            fillterdUsers = users
            
        } else {
          
            fillterdUsers = users.filter { (user) -> Bool in
                user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        collectionView?.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNumberOfPosts()
        
        searchBar.delegate = self
        collectionView?.backgroundColor = .white
        collectionView?.keyboardDismissMode = .onDrag
        navigationItem.titleView = searchBar
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        
        
    }
    
    
   
    
    
    
    var fillterdUsers = [User]()
    var users = [User]()
    
    var numOfPosts = [String:Int]()
    
    fileprivate func fetchNumberOfPosts() {
    
        
            
            Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshit) in
            
            guard let dictPosts = snapshit.value as? [String:Any] else { return }
            
            dictPosts.forEach({ (key,value) in
                
                guard let val = value as? [String:Any] else { return }
                
                self.numOfPosts[key] = val.count
                
            })
            
            self.fetchUsers()
                
            }, withCancel: { (err) in
            print("Faild to fetch number of posts",err)
            })
        
           
        
    
    }
    
    fileprivate func fetchUsers() {
    
        
        
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach({ (key,value) in
                
                if key == Auth.auth().currentUser?.uid {
                    
                    return
                    
                }
            
                guard let dictionary = value as? [String:Any] else { return }
                
                
                
                let user : User?
               
               
                if self.numOfPosts.keys.contains(key) {
                
                     user = User(uid: key, dictionary: dictionary,numberOfPosts: self.numOfPosts[key]!)
                    
                } else {
                     user = User(uid: key, dictionary: dictionary)
                }
                
                
                self.users.append(user!)
                
            })

           
            self.users.sort(by: { (u1, u2) -> Bool in
                
                return u1.numberOfPosts > u2.numberOfPosts
            })
            
            
            
            self.fillterdUsers = self.users
            self.collectionView?.reloadData()
            
        }) { (err) in
            
            print("Faild to fetch users for search",err)
        }
        
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let user = fillterdUsers[indexPath.item]
        
        self.searchBar.endEditing(true)
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fillterdUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        
        cell.user = fillterdUsers[indexPath.item]
        
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 66)
    }
    

}
