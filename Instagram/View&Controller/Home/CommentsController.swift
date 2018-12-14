//
//  CommentsController.swift
//  Instagram
//
//  Created by OuSS on 12/14/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class CommentsController: UITableViewController {
    
    var post: Post?
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter commment"
        textField.textColor = UIColor.black
        return textField
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(UIColor.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        containerView.addSubview(commentTextField)
        
        sendButton.anchor(top: containerView.topAnchor, bottom: containerView.bottomAnchor, right: containerView.trailingAnchor, paddingRight: 12, width: 50)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leadingAnchor, bottom: containerView.bottomAnchor, right: sendButton.leadingAnchor, paddingLeft: 12)
        
        return containerView
    }()
    
    @objc func handleSend(){
        guard let user = AuthService.instance.currentUser() else { return }
        guard let postId = post?.id else { return }
        guard let text = commentTextField.text, text.count > 0 else { return }
        
        let dictionary: [String : Any] = [
            kTEXT : text,
            kPOSTID : postId,
            kCREATEDAT : Date()
        ]
        
        guard let comment = Comment(dictionary: dictionary, _user: user) else { return }
        CommentService.instance.saveCommentToFirestore(comment: comment) { (error) in
            if error != nil {
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.backgroundColor = .red
        navigationItem.title = "Comments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
