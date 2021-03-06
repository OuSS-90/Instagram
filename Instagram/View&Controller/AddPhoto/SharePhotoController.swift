//
//  SharePhotoController.swift
//  Instagram
//
//  Created by OuSS on 12/8/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    static let refreshPosts = Notification.Name("refreshPosts")
    
    var selectedImage: UIImage? {
        didSet{
            imageView.image = selectedImage
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextView()
    }
    
    fileprivate func setupImageAndTextView() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, height: 100)
        
        containerView.addSubview(imageView)
        containerView.addSubview(textView)
        
        imageView.anchor(top: containerView.topAnchor, left: containerView.leadingAnchor, bottom: containerView.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, width: 84)
        
        textView.anchor(top: containerView.topAnchor, left: imageView.trailingAnchor, bottom: containerView.bottomAnchor, right: containerView.trailingAnchor, paddingLeft: 4)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handleShare() {
        guard let caption = textView.text, !caption.isEmpty else { return }
        guard let image = selectedImage else { return }
        guard let user = AuthService.instance.currentUser() else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        StorageService.instance.uploadImage(image: image, path: kPOSTS) { (url) in
             guard let imageURL = url else { return }
            
            let dictionary : [String : Any] = [
                kIMAGEURL : imageURL,
                kCAPTION : caption,
                kIMAGEWIDTH : image.size.width,
                kIMAGEHEIGHT : image.size.height,
                kCREATEDAT : Date()
                ]
            
            guard let post = Post(dictionary: dictionary, _user: user) else { return }
            
            PostService.instance.savePostToFirestore(post: post, completion: { (error) in
                if error != nil {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                
                self.dismiss(animated: true)
                
                NotificationCenter.default.post(name: SharePhotoController.refreshPosts, object: nil)
            })
        }
    }
    
}
