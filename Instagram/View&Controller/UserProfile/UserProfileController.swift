//
//  UserProfileController.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let cellId = "cellId"
    let homePostCellId = "homePostCellId"
    var user: User?
    var posts = [Post]()
    var postListener: ListenerRegistration?
    var isGridView = true
    var lastDocument: QueryDocumentSnapshot?
    var limit = 4
    var lastPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
        user = user ?? AuthService.instance.currentUser()
            
        navigationItem.title = user?.username
        setupRightBarButtonItem()
        
        fetchFirstPosts()
        //fetchProfilePosts()
    }
    
    
    func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            AuthService.instance.signOut(completion: { (success) in
                if success {
                    let logInController = LoginController()
                    let navController = UINavigationController(rootViewController: logInController)
                    UIApplication.setRootView(navController)
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    fileprivate func fetchProfilePosts() {
        guard let userId = user?.id else { return }
        
        reference(.Posts).whereField("userId", isEqualTo: userId).order(by: kCREATEDAT).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    fileprivate func fetchFirstPosts() {
        guard let user = user else { return }
                
        reference(.Posts).document(user.id).collection("userPosts").order(by: kCREATEDAT, descending: true).limit(to: limit).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            self.posts = snapshot.documents.compactMap{Post(dictionary: $0.data(), _user: user, _id: $0.documentID)}
            self.lastDocument = snapshot.documents.last
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func fetchNextPosts() {
        guard let user = user else { return }
        guard let lastDocument = lastDocument else { return }
        
        reference(.Posts).document(user.id).collection("userPosts").order(by: kCREATEDAT, descending: true).start(afterDocument: lastDocument).limit(to: limit).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            let posts = snapshot.documents.compactMap{Post(dictionary: $0.data(), _user: user, _id: $0.documentID)}
            self.posts += posts
            self.lastPage = posts.count < self.limit
            self.lastDocument = snapshot.documents.last
            self.collectionView.reloadData()
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        let document = change.document
        guard let user = user else { return }
        guard let post = Post(dictionary: document.data(), _user: user, _id: document.documentID) else { return }
        
        switch change.type {
        case .added:
            posts.insert(post, at: 0)
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.insertItems(at: [indexPath])
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
            height += view.frame.width
            height += 50
            height += 60
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == self.posts.count - 1 && !lastPage {
            fetchNextPosts()
        }
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    deinit {
        postListener?.remove()
    }
}

extension UserProfileController: UserProfileHeaderDelegate {
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
}
