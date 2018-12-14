//
//  Comment.swift
//  Instagram
//
//  Created by OuSS on 12/14/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    //let id: String?
    let text: String
    let postId: String
    let createdAt: Date
    let user: User
    
    var dictionary: [String : Any] {
        let dic: [String : Any] = [
            kTEXT : text,
            kPOSTID : postId,
            kUSERID : user.id,
            kCREATEDAT : createdAt
        ]
        
        /*if let id = id {
            dic[kID] = id
        }*/
        
        return dic
    }
    
    
    init?(dictionary: [String : Any], _user: User) {
        guard let _text = dictionary[kTEXT] as? String,
              let _postId = dictionary[kPOSTID] as? String
        else {
            return nil
        }
        
        if let _createdAt = dictionary[kCREATEDAT] as? Timestamp {
            createdAt = _createdAt.dateValue()
        } else if let _createdAt = dictionary[kCREATEDAT] as? Date {
            createdAt = _createdAt
        } else {
            return nil
        }
        
        text = _text
        postId = _postId
        user = _user
    }
}
