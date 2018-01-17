//
//  User.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/18/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import Foundation

struct User {
    
    let username : String
    let profileImageUrl : String
    let uid : String
    let numberOfPosts : Int
    
    init(uid: String,dictionary: [String:Any],numberOfPosts: Int = 0) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = uid
        self.numberOfPosts = numberOfPosts
    }
    
    
    
    
    
}
