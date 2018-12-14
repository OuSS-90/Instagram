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

    /*func fetchCommentsWithUser(user: User, completion: @escaping (_ comments: [Comment]) -> Void) {
        reference(.Posts).whereField("userId", isEqualTo: user.id).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            let posts = snapshot.documents.compactMap{ Post(dictionary: $0.data(), _user: user, _id: $0.documentID) }
            completion(posts)
        }
    }*/
    
}
