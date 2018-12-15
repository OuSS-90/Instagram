//
//  CommentService.swift
//  Instagram
//
//  Created by OuSS on 12/14/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation

class CommentService {
    static let instance = CommentService()
    
    func saveCommentToFirestore(comment: Comment, completion: @escaping (_ error: Error?) -> Void) {
        reference(.Comments).addDocument(data: comment.dictionary) { (error) in
            completion(error)
        }
    }
}
