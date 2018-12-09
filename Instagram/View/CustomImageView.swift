//
//  CustomImageView.swift
//  Instagram
//
//  Created by OuSS on 12/9/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    private var lastURL: String?

    func loadImage(urlString: String?) {
        
        lastURL = urlString
        
        guard let str = urlString else { return }
        guard let url = URL(string: str) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { return }
            
            if url.absoluteString != self.lastURL { return }
            
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }

}
