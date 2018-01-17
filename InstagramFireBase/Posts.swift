//
//  Posts.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/17/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import Foundation


struct Post {
    
    var id: String?
    
    let user : User
    let imageUrl : String
    let caption : String
    let creationDate : Date
    
    var hasLiked: Bool = false
    
    
    init(user: User,dict: [String:Any]) {
        self.imageUrl = dict["imageURL"] as? String ?? ""
        self.user = user
        self.caption = dict["caption"] as? String ?? ""

       
        let secoundsFrom1970 = dict["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secoundsFrom1970)
        
    }
    
    
    
}
