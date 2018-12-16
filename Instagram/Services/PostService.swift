//
//  PostService.swift
//  Instagram
//
//  Created by OuSS on 12/9/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation

class PostService {
    static let instance = PostService()
    
    func savePostToFirestore(post: Post, completion: @escaping (_ error: Error?) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Posts).document(userId).collection("userPosts").document().setData(post.dictionary) { (error) in
            completion(error)
        }
    }
    
    func fetchPostsWithUser(user: User, completion: @escaping (_ post: Post) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Posts).document(userId).collection("userPosts").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach({ (document) in
                guard var post = Post(dictionary: document.data(), _user: user, _id: document.documentID) else { return }
                guard let postId = post.id else { return }
                self.checkLike(postId: postId, completion: { (isLiked) in
                    post.isLiked = isLiked
                    completion(post)
                })
            })
        }
    }
    
    func fetchFollowingPosts(completion: @escaping (_ post: Post) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        
        reference(.Following).document(userId).collection("Follower").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach({ (document) in
                UserService.instance.fetchUser(userId: document.documentID, completion: { (user) in
                    self.fetchPostsWithUser(user: user, completion: { (post) in
                        completion(post)
                    })
                })
            })
        }
    }
    
    func like(postId: String, hasLike: Bool, completion: @escaping (_ error: Error?) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Likes).document("\(postId)/Users/\(userId)").setData(["exist" : hasLike]) { (error) in
            completion(error)
        }
    }
    
    func checkLike(postId: String, completion: @escaping (_ isLiked: Bool) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Likes).document("\(postId)/Users/\(userId)").getDocument { (document, error) in
            if error != nil {
                return
            }
            
            let data = document?.data()
            guard let exist = data?["exist"] as? Bool else {
                completion(false)
                return
            }
            
            completion(exist)
        }
    }
}
