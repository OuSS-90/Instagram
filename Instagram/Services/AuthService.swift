//
//  AuthService.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func register(withEmail email: String, password: String, username: String, image: UIImage, completion: @escaping (_ success: Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(false)
                return
            }
            
            guard let fuser = result?.user else {
                completion(false)
                return
            }
            
            StorageService.instance.uploadImage(image: image, completion: { (url) in
                
                guard let imageURL = url?.absoluteString else { return }
                
                let dic = [
                    kID : fuser.uid,
                    kEMAIL : fuser.email!,
                    kUSERNAME : username,
                    kPROFILE : imageURL
                ]
                
                let user = User(_dictionary: dic)
                self.saveUserToFirestore(user: user)
                
                completion(true)
            })
        }
    }
    
    func saveUserToFirestore(user: User) {
        reference(.Users).document(user.id).setData(user.dictionary) { (error) in
            print("error is \(String(describing: error?.localizedDescription))")
        }
    }
}
