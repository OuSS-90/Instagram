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
    let profileImageURL: String
    
    var dictionary: [String : Any] {
        return [
            kID : id,
            kEMAIL : email,
            kUSERNAME : username,
            kPROFILEIMAGEURL : profileImageURL
        ]
    }
    
    init(dictionary: [String : Any], _id: String) {
        id = _id
        email = dictionary[kEMAIL] as? String ?? ""
        username = dictionary[kUSERNAME] as? String ?? ""
        profileImageURL = dictionary[kPROFILEIMAGEURL] as? String ?? ""
    }
    
    init(dictionary: [String : Any]) {
        id = dictionary[kID] as! String
        email = dictionary[kEMAIL] as? String ?? ""
        username = dictionary[kUSERNAME] as? String ?? ""
        profileImageURL = dictionary[kPROFILEIMAGEURL] as? String ?? ""
    }
}
