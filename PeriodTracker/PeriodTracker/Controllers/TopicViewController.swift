//
//  TopicViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/26/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class TopicViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextViewDelegate {
    
    
    var loadNewArticle = true
    let limit = 10
    var lockOffset = false
    var isScrollToBottom = false
    
    var offset = 0 {
        didSet {
            getDataFromServer()
        }
    }
    
    
    var sectionItems: [Date : [Message]] = [ : ]
    var sectionKeysCount = 0
    
    var topic: Topic! {
        didSet {
            if topic.disallow_send_message == 1 {
                self.messageTextView.text = "شما دسترسی ارسال پیام در این تاپیک را ندارید"
                self.messageTextView.isEditable = false
            }
            self.sendImageView.isHidden = topic.disallow_send_message == 1
        }
    }
    
    var models: [Message] = [] {
        didSet {
            
            sectionItems.removeAll()
            
            for topic in self.models {
                
                let dateComponents = Calendar.current.dateComponents([.year , .month , .day], from: topic.created_at)
                let date = Calendar.current.date(from: dateComponents)
                
                if self.sectionItems[date!] == nil {
                    self.sectionItems[date!] = []
                }
                self.sectionItems[date!]?.append(topic)
                
            }
            
            self.sectionKeysCount = self.sectionItems.keys.count - 1
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.topicTableView.reloadData()
                
                if self.sectionItems.count > 0 , !self.isScrollToBottom {
                    self.topicTableView.scrollToRow(at: IndexPath(row: self.sectionItems[Array(self.sectionItems.keys)[self.sectionItems.keys.count - 1]]!.count - 1, section: self.sectionItems.keys.count - 1), at: UITableViewScrollPosition.bottom, animated: false)
                    self.isScrollToBottom = true
                }
            }
        }
    }
    
    let topicTableViewCell: TopicTableViewCell = {
        let cell = TopicTableViewCell()
        cell.semanticContentAttribute = .forceRightToLeft
        cell.backgroundColor = .white
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }()
    
    let topicTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        tableView.semanticContentAttribute = .forceRightToLeft
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textView.backgroundColor = .clear
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.text = "پیام خود را بنویسید..."
        textView.textColor = .lightGray
        textView.font(.IRANSans)
        textView.textAlignment = .right
        textView.layer.cornerRadius = 22
        textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 50)
        textView.autocorrectionType = .no
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let sendImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_send_message"))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.isUserInteractionEnabled = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let sendingActivityIndicatorBG: UIView = {
        let view = UIView()
        
        view.isHidden = true
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = Colors.accentColor
        
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sendingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        
        activityIndicator.startAnimating()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF6F6F6)
        
        self.title = topic.subject
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        topicTableView.refreshControl = refreshControl
        
        topicTableView.dataSource = self
        topicTableView.delegate = self
        topicTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "cell")
        topicTableView.register(TopicTableViewCell.self, forCellReuseIdentifier: "tcell")

        topicTableView.setContentOffset(.zero, animated: true)
        
        setupViews()
        
        if let nikName = topic.user.nikname {
            topic.subject = nikName
        } else {
            topic.subject = topic.user.email
        }
        self.topicTableViewCell.model = topic
        
        getDataFromServer()
        
        self.messageTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - 50
            self.topicTableView.frame.size.height = tableViewY - keyboardHeight
            self.messageTextView.frame.origin.y = messageY - keyboardHeight
            self.sendImageView.frame.origin.y = sendImageY - keyboardHeight
            self.sendingActivityIndicatorBG.frame.origin.y = sendImageY - keyboardHeight
            
            if self.sectionItems.count > 0 {
                self.topicTableView.scrollToRow(at: IndexPath(row: self.sectionItems[Array(self.sectionItems.keys)[self.sectionItems.keys.count - 1]]!.count - 1, section: self.sectionItems.keys.count - 1), at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.topicTableView.frame.size.height = tableViewY
        self.messageTextView.frame.origin.y = messageY
        self.sendImageView.frame.origin.y = sendImageY
        self.sendingActivityIndicatorBG.frame.origin.y = sendImageY
        
    }
    
    var tableViewY: CGFloat = 0
    var messageY: CGFloat = 0
    var sendImageY: CGFloat = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewY = self.topicTableView.frame.size.height
        messageY = self.messageTextView.frame.origin.y
        sendImageY = self.sendImageView.frame.origin.y
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionItems.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let date = Array(self.sectionItems.keys.sorted())[section]
        
        let headerView = UIView()
        
        let label: UILabel = {
            let l = UILabel()
            l.font(.IRANYekanBold , size: 13)
            l.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            l.layer.cornerRadius = 13
            l.layer.masksToBounds = true
            l.translatesAutoresizingMaskIntoConstraints = false
            l.textAlignment = .center
            return l
        }()
        
        headerView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa_IR")
        dateFormatter.dateStyle = .medium
        
        let today = dateFormatter.string(from: date)
        print(today)
        
        label.text = today
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionItems[Array(self.sectionItems.keys)[section]]!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let tcell = tableView.dequeueReusableCell(withIdentifier: "tcell") as! TopicTableViewCell
            tcell.model = topic
            return tcell
        } else {
//            indexPath = indexPath(row: indexPath.row , section: indexPath.section)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MessageTableViewCell
            cell.model = self.sectionItems[self.sectionItems.keys.sorted()[indexPath.section]]![indexPath.row-1]
            return cell
        }

        
        
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.models.removeAll()
        offset = 0
    }
    
    let dateFormatterWithTime: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    let decoder = JSONDecoder()
    
    func getDataFromServer() {
        self.loadNewArticle = true
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
        }
        Http().request(endpoint: "messages/\(topic.id)/\(offset)") { (data, response, error) in
            if let data = data {
                do {
                    self.decoder.dateDecodingStrategy = .formatted(self.dateFormatterWithTime)
                    
                    let serverModels = try self.decoder.decode([Message].self , from: data)
                    
                    if serverModels.count > 0 {
                        // All topics loads
                        self.lockOffset = true
                    } else {
                        self.lockOffset = false
                    }
                    
                    self.models = serverModels + self.models
                } catch {
                    
                }
            }
            self.loadNewArticle = false
        }
    }
    
    func setupViews() {
        self.view.addSubview(self.topicTableViewCell)
        self.view.addSubview(self.topicTableView)
        self.view.addSubview(self.messageTextView)
        self.view.addSubview(self.sendImageView)
        
        self.view.addSubview(self.sendingActivityIndicatorBG)
        self.sendingActivityIndicatorBG.addSubview(self.sendingActivityIndicator)
        
        self.topicTableViewCell.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.topicTableViewCell.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.33).isActive = true
        self.topicTableViewCell.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topicTableViewCell.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.topicTableView.topAnchor.constraint(equalTo: self.topicTableViewCell.bottomAnchor , constant: 7).isActive = true
        self.topicTableView.bottomAnchor.constraint(equalTo: self.messageTextView.topAnchor, constant: -7).isActive = true
        self.topicTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 7).isActive = true
        self.topicTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -7).isActive = true
        
        self.messageTextView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor , constant: -7).isActive = true
        self.messageTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor , constant: 7).isActive = true
        self.messageTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -7).isActive = true
        
        self.sendImageView.centerYAnchor.constraint(equalTo: self.messageTextView.centerYAnchor).isActive = true
        self.sendImageView.rightAnchor.constraint(equalTo: self.messageTextView.rightAnchor , constant: -2).isActive = true
        
        
        self.sendingActivityIndicatorBG.centerYAnchor.constraint(equalTo: self.sendImageView.centerYAnchor).isActive = true
        self.sendingActivityIndicatorBG.centerXAnchor.constraint(equalTo: self.sendImageView.centerXAnchor).isActive = true
        
        self.sendingActivityIndicator.centerYAnchor.constraint(equalTo: self.sendingActivityIndicatorBG.centerYAnchor).isActive = true
        self.sendingActivityIndicator.centerXAnchor.constraint(equalTo: self.sendingActivityIndicatorBG.centerXAnchor).isActive = true
        
        self.sendImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendImageTapped)))
    }
    
    @objc func sendImageTapped() {
        
        guard let message = messageTextView.text , message != "" , message != "پیام خود را بنویسید..." else { return }
        
        
        let realm = try! Realm()
        if let user = realm.objects(User.self).last {
            
            
            let parameters: Dictionary<String,Any> = [
                "user_id" : user.user_id,
                "topic_id" : self.topic.id,
                "message" : message
            ]
            
            self.sendingActivityIndicatorBG.isHidden = false
            
            Http().request(endpoint: "message", method: .POST, parameters: parameters) { (data, response, error) in
                if let data = data {
                    do {
                        let response = try self.decoder.decode(Message.self, from: data)
                        DispatchQueue.main.async {
                            self.messageTextView.text = "پیام خود را بنویسید..."
                            let newPosition = self.messageTextView.beginningOfDocument
                            self.messageTextView.selectedTextRange = self.messageTextView.textRange(from: newPosition, to: newPosition)
                            self.messageTextView.textColor = UIColor.lightGray
                            self.view.endEditing(true)
                            self.isScrollToBottom = false
                            self.models.append(response)
                            self.topicTableView.reloadData()
                        }
                    } catch {
                        
                    }
                }
                self.sendingActivityIndicatorBG.isHidden = true
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "پیام خود را بنویسید..."
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
            textView.textColor = UIColor.lightGray
        }
    }
    
}
