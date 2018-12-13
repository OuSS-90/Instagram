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
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAllPosts), name: SharePhotoController.refreshPosts, object: nil)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = UIColor.white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationBar()
        fetchAllPosts()
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera() {
        let cameraController = CameraController()
        present(cameraController, animated: true)
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    @objc fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingPosts()
    }
    
    fileprivate func fetchPosts() {
        guard let user = AuthService.instance.currentUser() else { return }
        PostService.instance.fetchPostsWithUser(user: user) { (posts) in
            self.reloadCollection(posts: posts)
        }
    }
    
    fileprivate func fetchFollowingPosts() {
        PostService.instance.fetchFollowingPosts { (posts) in
            self.reloadCollection(posts: posts)
        }
    }
    
    fileprivate func reloadCollection(posts: [Post]) {
        self.posts += posts
        self.posts.sort{ $0.createdAt > $1.createdAt }
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
    
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
    
        return cell
    }
}
