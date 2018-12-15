//
//  FCollectionRef.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation
import Firebase

enum FCollectionRef: String {
    case Users
    case Posts
    case Following
    case Comments
    case Likes
}

func reference(_ collectionRef: FCollectionRef) -> CollectionReference {
    return Firestore.firestore().collection(collectionRef.rawValue)
}
