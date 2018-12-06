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
            usernameLabel.text = user?.username
        }
    }
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Progile", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    fileprivate func setupView() {
        addSubview(profileImage)
        addSubview(editProfileButton)
        addSubview(usernameLabel)
        
        profileImage.anchor(top: topAnchor, left: leadingAnchor, paddingTop: 20, paddingLeft: 20, width: 80, height: 80)
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
        
        setupUserStatsView()
        
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leadingAnchor, right: followingLabel.trailingAnchor, paddingTop: 2, height: 34)
        
        usernameLabel.anchor(top: profileImage.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        setupBottomTabBar()
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
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImage.trailingAnchor, right: trailingAnchor, paddingTop: 20, paddingLeft: 14, paddingRight: 20, height: 50)
    }
    
    fileprivate func setupBottomTabBar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        let topDeviderView = UIView()
        topDeviderView.backgroundColor = UIColor.lightGray
        
        let bottomDeviderView = UIView()
        bottomDeviderView.backgroundColor = UIColor.lightGray
        
        addSubview(stackView)
        addSubview(topDeviderView)
        addSubview(bottomDeviderView)
        
        stackView.anchor(left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, height: 50)
        topDeviderView.anchor(top: stackView.topAnchor, left: stackView.leadingAnchor, right: stackView.trailingAnchor, height: 0.5)
        bottomDeviderView.anchor(top: stackView.bottomAnchor, left: stackView.leadingAnchor, right: stackView.trailingAnchor, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
