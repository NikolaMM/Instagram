//
//  HomePostCell.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/18/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComments(post: Post)
    func didTapLike(for cell: HomePostCell)
}


class HomePostCell: UICollectionViewCell {
    
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {

            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal) , for: .normal)
            
            guard let url = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: url)
            
            guard let username = post?.user.username else { return }
            usernamLabel.text = username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            guard let caption = post?.caption else { return }
            
            guard let crDate = post?.creationDate else { return }
            
            captionLabel.attributedText = setupAttributedCaprion(caption: caption, username: username,creationDate: crDate.timeAgoDisplay() )
        }
    }
    
    
    fileprivate func setupAttributedCaprion(caption : String, username : String, creationDate: String) -> NSAttributedString {
        
        
        let attributerdText = NSMutableAttributedString(string: username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        
        attributerdText.append(NSAttributedString(string: "  " + caption, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        attributerdText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        
        attributerdText.append(NSAttributedString(string: creationDate , attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.gray]))
        
        return attributerdText
        
    }
    
    let userProfileImageView : CustomImageView = {
    
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.clipsToBounds = true
        pi.backgroundColor = .black
        pi.layer.cornerRadius = 18
        return pi
    
    
    }()
    
    
    let photoImageView : CustomImageView = {
       
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.clipsToBounds = true
        pi.backgroundColor = .black
        return pi
        
        
    }()
    
    let usernamLabel : UILabel = {
        
        let ul = UILabel()
        ul.text = "Username"
        ul.font = UIFont.boldSystemFont(ofSize: 14)
        return ul
        
    }()
    
    let optionsButton : UIButton = {
       
        let bt = UIButton(type: .system)
        bt.setTitle("•••", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        return bt
        
        
    }()
    
    let captionLabel : UILabel = {
       
        let cl = UILabel()
        cl.numberOfLines = 0
        return cl
        
    }()
    
    
    lazy var likeButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    @objc func likeButtonPressed(){
        
        delegate?.didTapLike(for: self)
        
    }
    
    lazy var commentButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(commentButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    @objc func commentButtonPressed() {
        guard let post = post else { return }
        delegate?.didTapComments(post: post)
        print("Comment")
    }
    
    let sendMessageButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
        
    }()
    
    let ribbonButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        
        let containerView = UIView()
        
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 44, width: 0, height: 52, centerX: nil, centerY: nil)
        
        containerView.addSubview(userProfileImageView)
        userProfileImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor  , right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 36, height: 36, centerX: nil, centerY: nil )
        
        addSubview(photoImageView)
        photoImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        addSubview(optionsButton)
        optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0, centerX: nil, centerY: nil)
        
        
        containerView.addSubview(usernamLabel)
        usernamLabel.anchor(top: containerView.topAnchor, left: userProfileImageView.rightAnchor, bottom: containerView.bottomAnchor , right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        
        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0, centerX: nil, centerY: nil)
        
        
        
        
        
    }
    
    
    @objc func handleTap(){
        
        print("tap")
        guard let dum = dummy else { return }
        guard let userID = post?.user.uid else { return }
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = userID
        dum.navigationController?.pushViewController(userProfileController, animated: true)
        
    }
    
    fileprivate func setupActionButtons() {
        
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
        
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 50, centerX: nil, centerY: nil)
        addSubview(ribbonButton)
        ribbonButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 40, height: 50, centerX: nil, centerY: nil)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
