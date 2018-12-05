//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by OuSS on 12/5/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet{
            setupProfileImage()
        }
    }
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    fileprivate func setupView() {
        addSubview(profileImage)
        
        profileImage.anchor(top: topAnchor, left: leadingAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
    }
    
    fileprivate func setupProfileImage() {
        guard let profileImageURL = user?.profileImageURL else { return }
        guard let url = URL(string: profileImageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { return }
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
