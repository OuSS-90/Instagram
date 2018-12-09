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
    
    func currentUser() -> User? {
        if Auth.auth().currentUser != nil {
            if let dic = UserDefaults.standard.object(forKey: kCURRENTUSER) as? [String : Any] {
                return User(dictionary: dic)
            }
        }
        return nil
    }
    
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
            
            StorageService.instance.uploadImage(image: image, path: kPROFILE, completion: { (url) in
                
                guard let imageURL = url else { return }
                
                let dic = [
                    kID : fuser.uid,
                    kEMAIL : fuser.email!,
                    kUSERNAME : username,
                    kPROFILEIMAGEURL : imageURL
                ]
                
                let user = User(dictionary: dic)
                self.saveUserToFirestore(user: user)
                self.saveUserLocally(dictionary: dic)
                
                completion(true)
            })
        }
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            
            if error != nil {
                completion(false)
                return
            }
            
            guard let fuser = result?.user else {
                completion(false)
                return
            }
            
            //get user from firebase and save locally
            self.fetchUser(userId: fuser.uid, completion: {
                completion(true)
            })
        })
    }
    
    func signOut(completion: @escaping (_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            
            completion(true)
        } catch _ {
            completion(false)
        }
        
    }
    
    func saveUserToFirestore(user: User) {
        reference(.Users).document(user.id).setData(user.dictionary) { (error) in
            print("error is \(String(describing: error?.localizedDescription))")
        }
    }
    
    func saveUserLocally(dictionary: [String : Any]?) {
        UserDefaults.standard.set(dictionary, forKey: kCURRENTUSER)
        UserDefaults.standard.synchronize()
    }
    
    func fetchUser(userId: String, completion: @escaping () -> Void) {
        reference(.Users).document(userId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            if snapshot.exists {
                self.saveUserLocally(dictionary: snapshot.data())
                completion()
            }
        }
    }
}
