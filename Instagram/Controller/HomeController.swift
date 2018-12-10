//
//  HomeController.swift
//  Instagram
//
//  Created by OuSS on 12/10/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationBar()
        
        PostService.instance.fetchPosts { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    func setupNavigationBar() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
    
        cell.post = posts[indexPath.item]
    
        return cell
    }

    

}
