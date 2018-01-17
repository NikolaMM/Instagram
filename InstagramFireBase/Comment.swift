//
//  Comment.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 10/2/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import Foundation

struct Comment {
    
    var user : User?
    
    let uid: String
    let creationDate: Double
    let text: String
    
    
    init( dictionary: [String: Any]){
        self.uid = dictionary["uid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.creationDate = dictionary["creationDate"] as? Double ?? 0
        //self.creationDate = Date(timeIntervalSince1970: secoundsFrom1970).timeAgoDisplay()
        
        
    }
    
}
