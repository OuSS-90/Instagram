//
//  HomePostCell.swift
//  Instagram
//
//  Created by OuSS on 12/10/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    var post: Post? {
        didSet{
            photoImageView.loadImage(urlString: post?.imageUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
