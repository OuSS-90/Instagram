//
//  UserProfileController.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        if let user = AuthService.instance.currentUser() {
            navigationItem.title = user.username
        }
        
    }
}
