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
            profileImage.loadImage(urlString: user?.profileImageURL)
            usernameLabel.text = user?.username
            setupEditFollowButton()
        }
    }
    
    let profileImage: CustomImageView = {
        let imageView = CustomImageView()
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
    
    let editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
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
        addSubview(editProfileFollowButton)
        addSubview(usernameLabel)
        
        profileImage.anchor(top: topAnchor, left: leadingAnchor, paddingTop: 20, paddingLeft: 20, width: 80, height: 80)
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
        
        setupUserStatsView()
        
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leadingAnchor, right: followingLabel.trailingAnchor, paddingTop: 2, height: 34)
        
        usernameLabel.anchor(top: profileImage.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        setupBottomTabBar()
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
    
    fileprivate func setupEditFollowButton() {
        guard let loggedUserId = AuthService.instance.currentUser()?.id else { return }
        guard let userId = user?.id else { return }
        
        if loggedUserId == userId {
            
        } else {
            UserService.instance.checkFollower(followerId: userId) { (isFollowing) in
                isFollowing ? self.setupUnfollowStyle() : self.setupFollowStyle()
                self.editProfileFollowButton.addTarget(self, action: #selector(self.handleFollow), for: .touchUpInside)
            }
        }
    }
    
    @objc func handleFollow() {
        guard let userId = user?.id else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            UserService.instance.unFollow(followerId: userId) { (error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    return
                }
                self.setupFollowStyle()
            }
        } else {
            UserService.instance.follow(followerId: userId) { (error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    return
                }
                self.setupUnfollowStyle()
            }
        }
    }
    
    fileprivate func setupFollowStyle() {
        editProfileFollowButton.setTitle("Follow", for: .normal)
        editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
        editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func setupUnfollowStyle() {
        editProfileFollowButton.setTitle("Unfollow", for: .normal)
        editProfileFollowButton.backgroundColor = UIColor.white
        editProfileFollowButton.setTitleColor(UIColor.black, for: .normal)
        editProfileFollowButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
