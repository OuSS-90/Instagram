//
//  CommentCell.swift
//  Instagram
//
//  Created by OuSS on 12/14/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var comment: Comment? {
        didSet{
            profileImageView.loadImage(urlString: comment?.user.profileImageURL)
            txtLabel.text = comment?.text
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let txtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(txtLabel)
        
        profileImageView.anchor(left: contentView.leadingAnchor, paddingLeft: 8, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        txtLabel.anchor(top: contentView.topAnchor, left: profileImageView.trailingAnchor, bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingLeft: 8, paddingRight: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
