//
//  User.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let email: String
    let username: String
    let profileImage: String
    
    var dictionary: [String : Any] {
        return [
            kID : id,
            kEMAIL : email,
            kUSERNAME : username,
            kPROFILE : profileImage
        ]
    }
    
    init(_dictionary: [String : Any]) {
        id = _dictionary[kID] as! String
        email = _dictionary[kEMAIL] as? String ?? ""
        username = _dictionary[kUSERNAME] as? String ?? ""
        profileImage = _dictionary[kPROFILE] as? String ?? ""
    }
}
