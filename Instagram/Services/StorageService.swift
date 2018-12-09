//
//  StorageService.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    
    static let instance = StorageService()
    private let reference = Storage.storage().reference()
    
    func uploadImage(image: UIImage, path: String, completion: @escaping (_ url: String?) -> ()) {
        
        guard let data = image.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let storageRef = reference.child(path).child(imageName)
        
        storageRef.putData(data, metadata: metadata) { (meta, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            })
        }
       
    }
    
    func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        /*let reference = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        reference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }*/
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
