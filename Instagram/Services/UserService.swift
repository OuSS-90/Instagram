//
//  UserService.swift
//  Instagram
//
//  Created by OuSS on 12/11/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation

class UserService {
    static let instance = UserService()
    
    func fetchUser(userId: String, completion: @escaping (_ user: User) -> Void) {
        reference(.Users).document(userId).getDocument { (document, error) in
            guard let document = document, document.exists else { return }
            guard let dictionary = document.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping (_ users: [User]) -> Void) {
        var users = [User]()
        guard let loggedUserId = AuthService.instance.currentUser()?.id else { return }
        
        reference(.Users).order(by: kUSERNAME).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach({ (document) in
                if document.documentID != loggedUserId {
                    let user = User(dictionary: document.data(), _id: document.documentID)
                    users.append(user)
                }
            })
            
            completion(users)
        }
    }
    
    func follow(followerId: String, completion: @escaping (_ error: Error?) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Following).document("\(userId)/Follower/\(followerId)").setData(["exist" : true]) { (error) in
            completion(error)
        }
    }
    
    func unFollow(followerId: String, completion: @escaping (_ error: Error?) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Following).document("\(userId)/Follower/\(followerId)").delete { (error) in
             completion(error)
        }
    }
    
    func checkFollower(followerId: String, completion: @escaping (_ isFollowing: Bool) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Following).document(userId).collection("Follower").document(followerId).getDocument { (document, error) in
            guard let document = document else { return }
            completion(document.exists)
        }
    }
}
