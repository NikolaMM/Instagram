//
//  LoginController.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/11/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Firebase

class LoginController : UIViewController {
    
    
    let logoContainerView : UIView = {
       
        let vi = UIView()
        
        let logoImage = UIImageView(image: #imageLiteral(resourceName: "logo"))
       
        logoImage.contentMode = .scaleAspectFill
        vi.addSubview(logoImage)
        logoImage.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 80, centerX: vi.centerXAnchor, centerY: nil)
        logoImage.centerYAnchor.constraint(equalTo: vi.centerYAnchor, constant: 10).isActive = true
        vi.backgroundColor = .blue
        return vi
        
    }()
    
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
    
    
    
    let loginButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 255)
        button.layer.cornerRadius = 5
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(LoginController.handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleLogin(){
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            
            if let err = err {
                print("Cant log in", err)
                return
            }

            print("Successfully loged in with user ", user?.uid ?? "")
            
            guard let main = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            main.setupViewControllers()
            
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    @objc func handleTextInputChange(){
        
        let isValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 255)
        }
        
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    
        
        
        
        navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        view.addSubview(bottomButton)
        bottomButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50, centerX: nil, centerY: nil)
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150, centerX: nil, centerY: nil)
        
        setupInputFields()
        
        
        
    }

    
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }

    let bottomButton : UIButton = {
       
        let bt = UIButton(type: .system)
        
        
        let attributedTitel = NSMutableAttributedString(string: "Dont have an account?", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        bt.setAttributedTitle(attributedTitel, for: .normal)
        
        attributedTitel.append(NSAttributedString(string: "  Sign up", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237) ]))
        
        
        bt.addTarget(self, action: #selector(LoginController.signUP), for: .touchUpInside)
        return bt
        
    }()

    @objc func signUP() {
        
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
    
    fileprivate func setupInputFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 170,centerX: nil,centerY: nil)
        
        
    }
}
