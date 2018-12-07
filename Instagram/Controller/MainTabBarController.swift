//
//  MainTabBarController.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let homeNavController = templateNavController(unselectedImg: #imageLiteral(resourceName: "home_unselected"), selectedImg: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let searchNavController = templateNavController(unselectedImg: #imageLiteral(resourceName: "search_unselected"), selectedImg: #imageLiteral(resourceName: "search_selected"))
        
        let plusNavController = templateNavController(unselectedImg: #imageLiteral(resourceName: "plus_unselected"), selectedImg: #imageLiteral(resourceName: "plus_unselected"))
        
        let likeNavController = templateNavController(unselectedImg: #imageLiteral(resourceName: "like_unselected"), selectedImg: #imageLiteral(resourceName: "like_selected"))
        
        let layout = UICollectionViewFlowLayout()
        let userProfile = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = templateNavController(unselectedImg: #imageLiteral(resourceName: "profile_unselected"), selectedImg: #imageLiteral(resourceName: "profile_selected"), rootViewController: userProfile)
        
        tabBar.tintColor = UIColor.black
        
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, userProfileNavController]
        
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImg: UIImage, selectedImg: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.image = unselectedImg
        navController.tabBarItem.selectedImage = selectedImg
        return navController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoController)
            present(navController, animated: true)
            return false
        }
        
        return true
    }
}
