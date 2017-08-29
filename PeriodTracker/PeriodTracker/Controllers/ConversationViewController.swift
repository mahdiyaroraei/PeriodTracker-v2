//
//  ConversationViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/26/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class ConversationViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextViewDelegate {
    
    let realm = try! Realm()
    
    let conversationTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.semanticContentAttribute = .forceRightToLeft
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let sendCommentViewHolder: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: 55).isActive = true
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xb3b3b3).cgColor
        view.layer.borderWidth = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.widthAnchor.constraint(equalToConstant: 75).isActive = true
        button.setTitle("ارسال", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x4374e0), for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x4374e0).withAlphaComponent(0.2), for: .highlighted)
        button.titleLabel?.font = UIFont(name: "IRANSansFaNum-Bold", size: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var commentInputed = false
    
    let commentTextField: UITextView = {
        let textView = UITextView()
        textView.autocorrectionType = .no
        textView.text = "نظر خود را بنویسید..."
        textView.textColor = UIColor.lightGray
        textView.isScrollEnabled = false
        textView.textAlignment = .right
        textView.font = UIFont(name: "IRANYekanMobile", size: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            commentInputed = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "نظر خود را بنویسید..."
            textView.textColor = UIColor.lightGray
            commentInputed = false
        }
    }
    
    var comments: [Comment] = []
    var articleId: Int!
    
    var loadNewComment: Bool! = true {
        didSet {
            self.conversationTableView.reloadData()
        }
    }
    
    var lockOffset = false
    
    var offset: Int = 0 {
        didSet {
            getCommentsFromServer()
        }
    }
    
    let limit = 10
    
    func getCommentsFromServer() {
        loadNewComment = true
        
        let parameters = [
            "offset": offset,
            "limit": limit
        ]
        
        Alamofire.request("\(Config.WEB_DOMAIN)comments/\(articleId!)", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                if let jsonArray = json.array {
                    if jsonArray.count != self.limit {
                        self.lockOffset = true
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran") //Current time zone
                    for jsonElement in jsonArray {
                        var parentId: Int?
                        if let parentIdString = jsonElement["parent_id"].string {
                            parentId = Int(parentIdString)
                        } else {
                            parentId = nil
                        }
                        self.comments.append(Comment(id: Int(jsonElement["id"].string!)!, userId: Int(jsonElement["user_id"].string!)!, articleId: Int(jsonElement["article_id"].string!)!, parentId: parentId, addedTime: dateFormatter.date(from: jsonElement["add_time"].string!)!, content: jsonElement["content"].string!, email: jsonElement["email"].string!))
                        
                        if let replyJsonArray = jsonElement["reply_comments"].array {
                            for commentJson in replyJsonArray {
                                
                                self.comments.append(Comment(id: Int(commentJson["id"].string!)!, userId: Int(commentJson["user_id"].string!)!, articleId: Int(commentJson["article_id"].string!)!, parentId: Int(commentJson["parent_id"].string!)!, addedTime: dateFormatter.date(from: commentJson["add_time"].string!)!, content: commentJson["content"].string!, email: jsonElement["email"].string!))
                            }
                        }
                    }
                }
            }
            self.loadNewComment = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF6F6F6)
        
        setupViews()
        setupActions()

        self.title = "نظرات"
        
        self.commentTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard)))
        
        self.conversationTableView.rowHeight = UITableViewAutomaticDimension
        self.conversationTableView.estimatedRowHeight = 100
        
        self.conversationTableView.delegate = self
        self.conversationTableView.dataSource = self
        
        self.conversationTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "comment_cell")
        self.conversationTableView.register(ActivityIndicatorTableViewCell.self, forCellReuseIdentifier: "loading_cell")
        self.conversationTableView.register(ReplyCommentTableViewCell.self, forCellReuseIdentifier: "reply_comment_cell")
        
        offset = 0
    }
    
    func setupActions() {
        self.sendButton.addTarget(self, action: #selector(sendCommentTapped), for: .touchUpInside)
    }
    
    func sendCommentTapped() {
        if !commentTextField.text.isEmpty && commentInputed {
            
            guard let userId = realm.objects(User.self).last?.user_id else {
                showNoSubscribeView()
                return
            }
            
            guard let email = realm.objects(User.self).last?.email else {
                showNoSubscribeView()
                return
            }
            
            let comment = Comment(id: 0, userId: userId, articleId: articleId, parentId: nil, addedTime: Date(), content: commentTextField.text, email: email)
            postComment(comment: comment)
            
            self.view.endEditing(true)
            commentTextField.text = "نظر خود را بنویسید..."
            commentTextField.textColor = UIColor.lightGray
            commentInputed = false
        } else {
            showToast(message: "نظری وارد نشده است")
        }
    }
    
    let subscribeBackgroundView = UIView()
    
    func showNoSubscribeView(){
        subscribeBackgroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.65)
        subscribeBackgroundView.frame = self.view.bounds
        subscribeBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(subscribeBackgroundView)
        
        let subscribeButtonString = "خرید اشتراک"
        let subscribeButton = UIButton()
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.setTitle(subscribeButtonString , for: .normal)
        subscribeButton.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xdb2b42), for: .normal)
        subscribeButton.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xdb2b42).withAlphaComponent(0.2), for: .highlighted)
        subscribeButton.titleLabel?.textAlignment = .center
        subscribeButton.titleLabel?.font = UIFont(name: "IRANSansFaNum-Medium", size: 36)!
        subscribeButton.layer.borderWidth = 7
        subscribeButton.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xdb2b42).cgColor
        subscribeButton.titleEdgeInsets = UIEdgeInsetsMake(10, 17, 10, 17)
        subscribeButton.layer.cornerRadius = 15
        
        subscribeBackgroundView.addSubview(subscribeButton)
        
        subscribeButton.centerXAnchor.constraint(equalTo: subscribeBackgroundView.centerXAnchor).isActive = true
        subscribeButton.centerYAnchor.constraint(equalTo: subscribeBackgroundView.centerYAnchor).isActive = true
        subscribeButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
    }
    
    func subscribeButtonTapped() {
        self.navigationController?.pushViewController(PricingViewController(), animated: true)
    }
    
    func postComment(comment: Comment) {
        
        comment.sendingComment = true
        comments.insert(comment, at: 0)
        conversationTableView.reloadData()
        conversationTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        var parameters: [String : Any]
        if comment.parentId == nil {
            parameters = [
                "user_id" : comment.userId,
                "content": comment.content
            ]
        } else {
            parameters = [
                "user_id" : comment.userId,
                "parent_id": comment.parentId!,
                "content": comment.content
            ]
        }
        
        guard let licenseId = realm.objects(User.self).last?.license_id else {
            showNoSubscribeView()
            return
        }
        
        Alamofire.request("\(Config.WEB_DOMAIN)comment/\(comment.articleId)/\(licenseId)", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                if let commentId = json["comment_id"].int {
                    comment.id = commentId
                    comment.sendingComment = false
                    self.conversationTableView.reloadData()
                } else if let success = json["subscribe"].int , success == 0 {
                    self.showNoSubscribeView()
                }
            }
        }
    }
    
    func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loadNewComment && indexPath.row == comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading_cell")
            return cell!
        }
        if  !lockOffset && !loadNewComment && indexPath.row == comments.count - 1 {
            offset += 1
        }
        
        if comments[indexPath.row].parentId == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment_cell") as! CommentTableViewCell
            cell.comment = comments[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reply_comment_cell") as! ReplyCommentTableViewCell
            cell.comment = comments[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadNewComment {
            return comments.count + 1
        } else {
            return comments.count
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(conversationTableView)
        self.sendCommentViewHolder.addSubview(self.sendButton)
        self.sendCommentViewHolder.addSubview(self.commentTextField)
        self.view.addSubview(sendCommentViewHolder)
        
        self.conversationTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.conversationTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.conversationTableView.bottomAnchor.constraint(equalTo: self.sendCommentViewHolder.topAnchor).isActive = true
        
        self.sendCommentViewHolder.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant: -(self.tabBarController?.tabBar.frame.height)!).isActive = true
        self.sendCommentViewHolder.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.sendCommentViewHolder.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.sendButton.leadingAnchor.constraint(equalTo: self.sendCommentViewHolder.leadingAnchor).isActive = true
        self.sendButton.centerYAnchor.constraint(equalTo: self.sendCommentViewHolder.centerYAnchor).isActive = true
        
        self.commentTextField.centerYAnchor.constraint(equalTo: self.sendCommentViewHolder.centerYAnchor).isActive = true
        self.commentTextField.heightAnchor.constraint(greaterThanOrEqualTo: self.sendCommentViewHolder.heightAnchor)
        self.commentTextField.leadingAnchor.constraint(equalTo: sendButton.trailingAnchor).isActive = true
        self.commentTextField.trailingAnchor.constraint(equalTo: self.sendCommentViewHolder.trailingAnchor , constant: -7).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ArticleViewController.subscribe != nil && !ArticleViewController.subscribe! {
            showNoSubscribeView()
        } else if ArticleViewController.subscribe != nil && ArticleViewController.subscribe! {
            subscribeBackgroundView.removeFromSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.conversationTableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        
        self.commentTextField.isScrollEnabled = true
        self.commentTextField.contentSize = self.commentTextField.sizeThatFits(self.commentTextField.frame.size)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -(keyboardSize.height - ((self.tabBarController?.tabBar.frame.height)!))
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
}
