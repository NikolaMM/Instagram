//
//  UserProfilePhotoCell.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/18/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    
    var post : Post? {
        
        didSet {
            
            guard let imageURL = post?.imageUrl else { return }
            imageView.loadImage(urlString: imageURL)
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
    }
    
    let imageView : CustomImageView = {
       
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
        
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
