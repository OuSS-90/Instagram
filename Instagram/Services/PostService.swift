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
        reference(.Posts).document().setData(post.dictionary) { (error) in
            completion(error)
        }
    }
    
    func fetchPosts(completion: @escaping (_ posts: [Post]) -> Void) {
        var posts = [Post]()
        reference(.Posts).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach({ (document) in
                guard let user = AuthService.instance.currentUser() else { return }
                if let post = Post(dictionary: document.data(), _user: user, _id: document.documentID) {
                    posts.append(post)
                }
            })
            
            completion(posts)
        }
    }
}
