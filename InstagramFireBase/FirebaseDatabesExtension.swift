//
//  FirebaseDatabesExtension.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/19/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, complition: @escaping (User) -> ()) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDict = snapshot.value as? [String:Any] else { return }
            
            let user = User(uid: uid,dictionary: userDict)
            
            complition(user)
            
        }) { (err) in
            
            print("Faild to fetch user", err)
        }
        
    }
    
    
}
