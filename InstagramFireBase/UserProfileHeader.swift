//
//  UserProfileHeader.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/9/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader : UICollectionViewCell {
    
    
    var delegate : UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            
            guard let url = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: url)
            
            guard let username = user?.username  else { return }
            usernameLabel.text = username
            
            setupEditFollowButton()
            
        }
    }
    
    fileprivate func setupEditFollowButton() {
    
        guard let curentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if curentLoggedInUserId == userId{
           
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
            
        } else {
            
            let ref = Database.database().reference().child("following").child(curentLoggedInUserId).child(userId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
                    
                    self.setupUnfolloeStyle()
                    
                    
                } else {
                
                    
                    self.setupFolloeStyle()
                
                
                }
                
            }, withCancel: { (err) in
                print("Failed to check if following user",userId,err)
            })
        }
    }
    
    
    @objc func handleFollowEditButton() {
        
        
            
        guard let curentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }

        let value = [userId: 1]
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow"  {
            
            // Unollow someont
            
            let ref = Database.database().reference().child("following").child(curentLoggedInUserId).child(userId)
            ref.removeValue(completionBlock: { (err, ref) in
               
                if let err = err {
                    
                    print("Failed to unfollow user",err)
                }
                
                print("Successfully unfollowed user", self.user?.username ?? "")
                
                self.setupFolloeStyle()
                
            })
            
            
        } else if editProfileFollowButton.titleLabel?.text == "Follow" {
        
            // Follow someont 
            
            let ref = Database.database().reference().child("following").child(curentLoggedInUserId)
            
            ref.updateChildValues(value, withCompletionBlock: { (err, ref) in
                
            if let err = err {
                    
                print("Failed to upload following user",err)
                return
            
            }
                
            print("Successfully followed user:", self.user?.username ?? "")
                
                self.setupUnfolloeStyle()
                
            })
            
        } else {
            
            print("Edit Buttoon")
            
        }
            
    }
    
    func setupFolloeStyle() {
        
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .blue
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        
    }
    
    func setupUnfolloeStyle() {
        
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
        
    }
    
    let profileImageView : CustomImageView = {
    
        let iv = CustomImageView()
        iv.backgroundColor = .black
        
        return iv
    
    }()
    
    lazy var gridButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(handleGridButton), for: .touchUpInside)
        return button

    }()
    
    @objc func handleGridButton() {
        print("GRID")
        gridButton.tintColor = .blue
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    lazy var listButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleListButton), for: .touchUpInside)

        return button
        
    }()
    
    @objc func handleListButton(){
        print("LIST")
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        listButton.tintColor = .blue
        delegate?.didChangeToListView()
    }
    
    let bookmarkButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
        
    }()
    
    
    let usernameLabel : UILabel = {
        
        let lab = UILabel()
        lab.text = "username"
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        return lab
        
    }()
    
    lazy var editProfileFollowButton : UIButton = {
       
        let button = UIButton(type: .system)
        
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        button.layer.borderWidth = 1
        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleFollowEditButton), for: .touchUpInside)
        return button
        
    }()
    
    
    
    let postsLabel : UILabel = {
    
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    
    }()
    
    let followersLabel : UILabel = {
        
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "123\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
    }()
    
    let followingLabel : UILabel = {
        
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "165\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80, centerX: nil, centerY: nil)
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        addSubview(usernameLabel)
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 14, paddingBottom: 0, paddingRight: 12, width: 0, height: 0, centerX: nil, centerY: nil)
        
        setupStatusView()
        
        addSubview(editProfileFollowButton)
        
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor , left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 30, centerX: nil, centerY: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupStatusView() {
        
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50, centerX: nil, centerY: nil)
        
        
        
        
        
    }
    
    

    
    fileprivate func setupBottomToolbar() {
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50, centerX: nil, centerY: nil)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5, centerX: nil, centerY: nil)
        
        bottomDividerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5, centerX: nil, centerY: nil)
        
        
    }
    
}
