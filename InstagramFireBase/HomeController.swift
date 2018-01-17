//
//  HomeController.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/18/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Firebase

var dummy : UICollectionViewController?

class HomeController : UICollectionViewController , UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    let cellID = "cellId"
    
    var refresher : UIRefreshControl!

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dummy = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView?.refreshControl = refresher
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        setupNavItems()
    
        fetchPosts()
        
        fetchFollowingUserIds()
        
    }

   
    
    fileprivate func fetchFollowingUserIds() {
        
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("following").child(currentLoggedInUser)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            
            
            
            dictionary.forEach({ (key,value) in
                
                Database.fetchUserWithUID(uid: key, complition: { (user) in
                    
                    self.fetchPostsWithUser(user: user)
                    
                })
                
            })
            
        }) { (err) in
            print("Failed to fetch following users",err)
        }
        
    }
    
    @objc func handleUpdateFeed() {
        refresh()
        let offset = CGPoint(x: 0, y: -65)
        collectionView?.setContentOffset(offset, animated: true)
    }
    
    @objc func refresh() {
        
        posts.removeAll()
        fetchPosts()
        fetchFollowingUserIds()
        
        
    }
    
    func setupNavItems() {
        
        let slika = UIImageView(image: #imageLiteral(resourceName: "logo").withRenderingMode(.alwaysTemplate))
        slika.frame.size = CGSize(width: 150, height: 60)
        slika.contentMode = .scaleAspectFit
        slika.tintColor = UIColor.black
        
        navigationItem.titleView = slika
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(presentCamera))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(presentCamera))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    
    @objc func presentCamera() {
        
        print("Camera presented")
    
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
       Database.fetchUserWithUID(uid: uid) { (user) in
        self.fetchPostsWithUser(user: user)
        }
        
    }
    
    
    fileprivate func fetchPostsWithUser(user: User){
        
        
        let userRef = Database.database().reference().child("posts").child(user.uid)
        
        
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            
            dictionaries.forEach({ (key,value) in
                
                guard let dictionary = value as? [String:Any] else { return }
                
                var post = Post(user: user , dict: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snap = snapshot.value as? [String:Any] , snap["like"] as? Int == 1 {
                        
                        post.hasLiked = true
                    
                    } else {
                        
                        post.hasLiked = false
                    }
                  
                    self.posts.append(post)
                    
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    
                    print("Reloading Data")
                    self.collectionView?.reloadData()
                    
                }, withCancel: {(err) in
                    print("Faild to fetch like info for post")
                })
                
            })
            
            
        }) { (err) in
            
            print("Faild to fetch posts", err)
        }
        
    }
    


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        
        if posts.count > 0 {
            cell.post = posts[indexPath.item]
        }
        
        cell.delegate = self
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGFloat(8+8+36) + view.frame.size.width + 50 + 60
        return CGSize(width: view.frame.size.width, height: size)
    }
    
    func didTapComments(post: Post) {
        
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(commentsController, animated: true)
        commentsController.post = post
    }
    
    
    func didTapLike(for cell: HomePostCell) {
        
        
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        
        var post = self.posts[indexPath.item]
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        
        if post.hasLiked == false {
        
            let values = [ "like": 1 ,"likeTime": Date().timeIntervalSince1970]
            
            
            let ref = Database.database().reference().child("likes").child(postId).child(uid)
            ref.updateChildValues(values) { (err, _) in
                
                if let err = err {
                    print("Faild to insert LIKE",err)
                }
                
                print("Successfuly LIKEDE post")
                post.hasLiked = true
                self.posts[indexPath.item] = post
                self.collectionView?.reloadItems(at: [indexPath])
                
            }
        } else {
            
            let values = [ "like": 0 ]
            
            let ref = Database.database().reference().child("likes").child(postId).child(uid)
            
            ref.updateChildValues(values) { (err, _) in
                
                if let err = err {
                    
                    print("Faild to UNLIKE post",err)
                }
                
                print("Successfuly UNLIKED")
                post.hasLiked = false
                self.posts[indexPath.item] = post
                self.collectionView?.reloadItems(at: [indexPath])
            }
            
        }
    }
    
}


