//
//  PhotoSelectorHeader.swift
//  
//
//  Created by Nikola Milenkovic on 6/14/17.
//
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    
    
    
    
    var headerImage : UIImageView = {
       
        let hi = UIImageView()
        hi.contentMode = .scaleAspectFill
        hi.clipsToBounds = true
        hi.backgroundColor = .black
        return hi
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerImage)
        headerImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
