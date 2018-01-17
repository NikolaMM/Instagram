//
//  CommentsCell.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 10/2/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    var comment : Comment? {
        
        didSet {
            
            guard let text = comment?.text else { return }
            guard let username = comment?.user?.username else { return }
            guard let creationDate = comment?.creationDate else { return }
            let newDate = Date(timeIntervalSince1970: creationDate).timeAgoDisplay()
            
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSMutableAttributedString(string: " " + text , attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            attributedText.append(NSMutableAttributedString(string: "\n" + newDate, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.gray]))
            
            
            commentText.attributedText = attributedText
            
            guard let imageUrl = comment?.user?.profileImageUrl else { return }
            userImage.loadImage(urlString: imageUrl)
            
        }
        
    }
    
    let commentText: UILabel = {
       
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
        
    }()
    
    let userImage: CustomImageView = {
       
        let img = CustomImageView()
        img.backgroundColor = .black
        return img
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userImage)
        userImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 40, height: 40, centerX: nil, centerY: nil)
        userImage.layer.cornerRadius = 20
        userImage.clipsToBounds = true
        
        addSubview(commentText)
        commentText.anchor(top: topAnchor, left: userImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12, width: 0, height: 0, centerX: nil, centerY: nil)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
