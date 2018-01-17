//
//  PreviewPhotoContainerView.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 9/21/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    
    let cancelButton : UIButton = {
       
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "cancel_shadow"), for: .normal)
        btn.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        return btn
    
    }()
    
    let saveButton : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "save_shadow"), for: .normal)
        btn.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
        return btn
        
    }()
    
    let previewImageView: UIImageView = {
       
        let iv = UIImageView()
        return iv
        
    }()
    
    @objc func cancelClicked() {
        self.removeFromSuperview()
    }
    
    @objc func saveClicked() {
        
        let library = PHPhotoLibrary.shared()
        
        guard let previewImage = previewImageView.image else { return }
        
        library.performChanges({ 
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (success, err) in
            if let err = err {
                print("Faild to save image to library", err)
            }
            
            print("Successfuly saved image to library")
            
            DispatchQueue.main.async {
                
                let savedLabel : UILabel = {
                    
                    let lab = UILabel()
                    lab.text = "Saved successfuly"
                    lab.textAlignment = .center
                    lab.textColor = .white
                    lab.font = UIFont.boldSystemFont(ofSize: 20)
                    lab.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    lab.layer.cornerRadius = 20
                    lab.layer.masksToBounds = true
                
                    return lab
                }()
                
                self.addSubview(savedLabel)
                savedLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 100, centerX: self.centerXAnchor, centerY: self.centerYAnchor)
                
                savedLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut , animations: {
                    
                    savedLabel.transform = .identity
                    
                }, completion: { (true) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.opacity = 0
                        
                    }, completion: { (_) in
                    
                        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                            
                            self.frame.origin.y += self.frame.size.height
                            
                        }, completion: { (_) in
                         
                            self.removeFromSuperview()
                            
                        })
                        
                    
                    })
                    
                })
                
            }
            
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        
        addSubview(previewImageView)
        addSubview(cancelButton)
        addSubview(saveButton)
        
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30, centerX: nil, centerY: nil)
        
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 50, height: 50, centerX: nil, centerY: nil)
        
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
