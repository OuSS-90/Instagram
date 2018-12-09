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
    
    func fetchProfilePosts(completion: @escaping (_ posts: [Post]) -> Void) {
        var posts = [Post]()
        guard let userId = AuthService.init().currentUser()?.id else { return }
        reference(.Posts).whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                if let post = Post(dictionary: document.data(), _id: document.documentID) {
                    posts.append(post)
                }
            }
            completion(posts)
        }
    }
    
}
