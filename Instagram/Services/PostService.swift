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
    
}
