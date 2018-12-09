//
//  Post.swift
//  Instagram
//
//  Created by OuSS on 12/9/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    let id: String?
    let imageUrl: String
    let caption: String
    let imageWidth: String
    let imageHeight: String
    let createdAt: Date
    let userId: String
    
    var dictionary: [String : Any] {
        var dic: [String: Any] = [
            kIMAGEURL : imageUrl,
            kCAPTION : caption,
            kIMAGEWIDTH : imageWidth,
            kIMAGEHEIGHT : imageHeight,
            kCREATEDAT : createdAt,
            kUSERID : userId
        ]
        
        if let id = id {
            dic[kID] = id
        }
        
        return dic
    }
    
    init?(dictionary: [String : Any]) {
        guard let _imageUrl = dictionary[kIMAGEURL] as? String,
            let _caption = dictionary[kCAPTION] as? String,
            let _userId = dictionary[kUSERID] as? String,
            let _createdAt = dictionary[kCREATEDAT] as? Timestamp
            else {
                return nil
        }
        
        id = nil
        imageUrl = _imageUrl
        caption = _caption
        imageWidth = dictionary[kIMAGEWIDTH] as? String ?? ""
        imageHeight = dictionary[kIMAGEHEIGHT] as? String ?? ""
        userId = _userId
        createdAt = _createdAt.dateValue()
    }
}
