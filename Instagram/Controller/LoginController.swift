//
//  LogInController.swift
//  Instagram
//
//  Created by OuSS on 12/6/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.anchor(width: 200, height: 50)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        AuthService.instance.login(withEmail: email, password: password) { (success) in
            if success {
                UIApplication.setRootView(MainTabBarController())
            }
        }
    }
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedString = NSMutableAttributedString(string: "Don't have an account? " , attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "Sign Up", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
    
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignIn() {
        let signInController = SignUpController()
        navigationController?.pushViewController(signInController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(logoContainerView)
        view.addSubview(dontHaveAccountButton)
        logoContainerView.anchor(top: view.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor,  height: 150)
        dontHaveAccountButton.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, height: 50)
        
        setupTextFields()
    }
    
    fileprivate func setupTextFields() {
        let vStackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 10
        
        view.addSubview(vStackView)
        
        vStackView.anchor(top: logoContainerView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 40, paddingLeft: 30, paddingRight: 30, height: 147)
    }
    
}
