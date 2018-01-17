//
//  PhotoSelectorCell.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/13/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    var cellImage : UIImageView = {
       
        let ci = UIImageView()
        ci.contentMode = .scaleAspectFill
        ci.clipsToBounds = true
        return ci
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellImage)
        cellImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
