//
//  MainTabBarController.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewLayout()
        let userProfile = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfile)
        
        navController.tabBarItem.image = UIImage(named: "profile_unselected")
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = UIColor.black
        
        viewControllers = [navController]
        
    }
}
