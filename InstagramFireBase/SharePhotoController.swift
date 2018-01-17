//
//  SharePhotoController.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/16/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage : UIImage? {
    
        didSet {
            imageView.image = selectedImage
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareHandler))
        setupImageAndTextViews()
    }
    
    @objc func shareHandler() {
        
        guard let image = self.selectedImage else { return }
        
        guard let uploadDada = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = UUID().uuidString.lowercased()
        
        Storage.storage().reference().child("posts").child(filename).putData(uploadDada, metadata: nil) { (metadata, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Faild to upload post image", err)
                return
            }
            
            guard let imageURL = metadata?.downloadURL()?.absoluteString else { return }
            
            print("Successfully uploaded image",imageURL)
            
            self.saveToDatabeseWithImageUrl(imageURL: imageURL)
            
            
        }
        
    }
    
    fileprivate func saveToDatabeseWithImageUrl(imageURL: String) {
        
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let profileRef = Database.database().reference().child("posts").child(uid)
        let ref = profileRef.childByAutoId()
        
        let values = ["imageURL":imageURL,"caption": caption, "imageHeight": postImage.size.height, "imageWidth":postImage.size.width, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Faild to save post to DB",err)
                return
            }
            
            print("Successfully saved post to DB",ref)
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
         
            
            

        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    let imageView : UIImageView = {
       
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
        
    }()
    
    let textView : UITextView = {
       
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        
        return tv
        
    }()
    
    func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100, centerX: nil, centerY: nil)
        
        
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 80, height: 80, centerX: nil, centerY: nil)
    
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0 , width: 0, height: 0, centerX: nil, centerY: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
