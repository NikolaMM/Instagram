//
//  UserSearchCell.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/19/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    
    var user : User? {
        
        didSet{
            
            
            guard  let url = user?.profileImageUrl  else { return }
            profileImage.loadImage(urlString: url)
            
            guard let username = user?.username else { return }
            guard let numOfPosts = user?.numberOfPosts else { return }
            usernameLabel.text = username + "\n" + String(describing: numOfPosts) + " posts"
            
        }
        
    }
    
    
    
    let profileImage : CustomImageView = {
       
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.clipsToBounds = true
        pi.backgroundColor = .lightGray
        return pi
        
    }()
    
    let usernameLabel : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
        
    }()
    
    let bar : UIView = {
       
        let bar = UIView()
        bar.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return bar
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(bar)
        
        profileImage.anchor(top: nil , left: leftAnchor, bottom: nil  , right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, centerX: nil, centerY: centerYAnchor)
        profileImage.layer.cornerRadius = 50 / 2
        
        usernameLabel.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 50, centerX: nil, centerY: centerYAnchor)
        
        bar.anchor(top: nil, left: profileImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5, centerX: nil, centerY: nil)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
