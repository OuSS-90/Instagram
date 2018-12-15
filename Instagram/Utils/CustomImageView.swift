//
//  UIImageView.swift
//  Instagram
//
//  Created by OuSS on 12/9/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

/*class UIImageView: UIImageView {
    
    private var lastURL: String?
    private var imagesCache = [String : UIImage]()

    func loadImage(urlString: String?) {
        
        lastURL = urlString
        self.image = nil
        
        guard let str = urlString else { return }
        guard let url = URL(string: str) else { return }
        
        if let image = imagesCache[str] {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { return }
            
            if url.absoluteString != self.lastURL { return }
            
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            self.imagesCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }

}*/
