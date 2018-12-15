//
//  CommentCell.swift
//  Instagram
//
//  Created by OuSS on 12/14/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit
import SDWebImage

class CommentCell: UITableViewCell {
    
    var comment: Comment? {
        didSet{
            guard let comment = comment else { return }
            
            profileImageView.sd_setImage(with: URL(string: comment.user.profileImageURL))
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            textView.attributedText = attributedText
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(textView)
        
        profileImageView.anchor(top: contentView.topAnchor, left: contentView.leadingAnchor, paddingTop: 8, paddingLeft: 8, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        textView.anchor(top: contentView.topAnchor, left: profileImageView.trailingAnchor, bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        let textViewGreatOrEqual = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
        textViewGreatOrEqual.priority = .defaultHigh
        textViewGreatOrEqual.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
