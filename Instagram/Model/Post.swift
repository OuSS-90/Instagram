//
//  Post.swift
//  Instagram
//
//  Created by OuSS on 12/9/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation

struct Post {
    let id: String
    let imageUrl: String
    let caption: String
    let imageWidth: String
    let imageHeight: String
    let userId: String
    
    var dictionary: [String : Any] {
        return [
            kID : id,
            kIMAGEURL : imageUrl,
            kCAPTION : caption,
            kIMAGEWIDTH : imageWidth,
            kIMAGEHEIGHT : imageHeight,
            kUSERID : userId
        ]
    }
    
    init(dictionary: [String : Any]) {
        id = dictionary[kID] as! String
        imageUrl = dictionary[kIMAGEURL] as? String ?? ""
        caption = dictionary[kCAPTION] as? String ?? ""
        imageWidth = dictionary[kIMAGEWIDTH] as? String ?? ""
        imageHeight = dictionary[kIMAGEHEIGHT] as? String ?? ""
        userId = dictionary[kUSERID] as? String ?? ""
    }
}
