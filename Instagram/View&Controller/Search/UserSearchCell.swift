//
//  UserSearchCell.swift
//  Instagram
//
//  Created by OuSS on 12/11/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class UserSearchCell: UITableViewCell {
    
    var user: User? {
        didSet{
            profileImageView.loadImage(urlString: user?.profileImageURL)
            userNameLabel.text = user?.username
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(userNameLabel)
        
        profileImageView.anchor(left: contentView.leadingAnchor, paddingLeft: 8, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        userNameLabel.anchor(top: contentView.topAnchor, left: profileImageView.trailingAnchor, bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingLeft: 8, paddingRight: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
