//
//  LogInController.swift
//  Instagram
//
//  Created by OuSS on 12/6/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class LogInController: UIViewController {
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account ? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignIn() {
        let signInController = SignInController()
        navigationController?.pushViewController(signInController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(signInButton)
        signInButton.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, height: 50)
    }
    
}
