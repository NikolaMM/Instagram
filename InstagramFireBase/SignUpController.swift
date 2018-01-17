//
//  ViewController.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 5/31/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let bottomButton : UIButton = {
        
        let bt = UIButton(type: .system)
        
        let attributedTitel = NSMutableAttributedString(string: "Already have an account?", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        bt.setAttributedTitle(attributedTitel, for: .normal)
        
        attributedTitel.append(NSAttributedString(string: "  Login", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237) ]))
        
        
               bt.addTarget(self, action: #selector(SignUpController.haveAccount), for: .touchUpInside)
        return bt
        
    }()
    
    @objc func haveAccount() {
        
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    let plusPhotoButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlusPhotoButt), for: .touchUpInside)
        return button
        
    }()
    
    
    
    func printUID(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
    //print(uid)
      
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot ) in
            let dict = snapshot.value as! [String:Any]
            print(dict["username"]!)
        })
        
    }
    
    
    
    @objc func handlePlusPhotoButt() {
    
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
    
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField : UITextField = {
      
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField : UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField : UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange(){
        
        let isValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0
            && passwordTextField.text?.count ?? 0 > 0
        
        if isValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 255)
        }
        
        
        
    }
    
    let signUpButton : UIButton = {
       
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 255)
        button.layer.cornerRadius = 5
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(SignUpController.buttonPressed), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func buttonPressed(){
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else{ return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            if let err = error {
                print("Faild to create user", err)
            }
            
            print("Sucessfuly created user", user?.uid ?? "")
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadDada = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = UUID().uuidString.lowercased()
            
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadDada, metadata: nil, completion: { (metaData, err) in
                
                if let err = err {
                    print("Faild to upload profile picture", err )
                }
                
                guard let profileImageUrl = metaData?.downloadURL()?.absoluteString else { return }
                
                print("Successfully uploaded profile picture", profileImageUrl )
                
                guard let uid = user?.uid else { return }
                
                let dictionaryValues = ["username":username,"profileImageUrl": profileImageUrl]
                let value = [uid: dictionaryValues]
                Database.database().reference().child("users").updateChildValues(value, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print("Faild to save data to DB", err)
                    } else {
                        print("Successfully saved user to DB")
                        
                        guard let main = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        
                        main.setupViewControllers()
                        
                        self.view.endEditing(true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })

            
                
                
            })
            
        
        })
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
      
        
        view.backgroundColor = .white
        setPlusPhotoButton()
        setupInputFields()
        
        view.addSubview(bottomButton)
        bottomButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50, centerX: nil, centerY: nil)
    }


    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func setPlusPhotoButton(){
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140,centerX: view.centerXAnchor,centerY: nil)
    }
    
    fileprivate func setupInputFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
    
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200,centerX: nil,centerY: nil)
        
    
    }
    
    

}



