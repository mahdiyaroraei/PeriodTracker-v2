//
//  TopicsViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class TopicsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var loadNewArticle = true
    let limit = 200
    var lockOffset = false
    var sectionItems: [Date : [Topic]] = [ : ]
    let colorName = [Colors.niceBlue, Colors.niceYellow, Colors.niceRed, Colors.niceGreen]
    var trashModel: [Topic] = []
    let category: [String] = ["pregnant", "sick", "period", "more"]
    var filterCategory: [String] = [""]
    
    var models: [Topic] = [] {
        didSet {
            
            sectionItems.removeAll()
            
            for topic in self.models {
                
                let dateComponents = Calendar.current.dateComponents([.year , .month , .day], from: topic.updated_at)
                let date = Calendar.current.date(from: dateComponents)
                
                if self.sectionItems[date!] == nil {
                    self.sectionItems[date!] = []
                }
                self.sectionItems[date!]?.append(topic)
                
            }
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.topicTableView.reloadData()
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xecf0f1)
        cv.delegate = self
        cv.dataSource = self
        cv.allowsMultipleSelection = true
        cv.allowsSelection = true
        cv.register(CategoryCVCell.self, forCellWithReuseIdentifier: "categorycell")
        return cv
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.isHidden = true
        return blurEffectView
    }()
    
    let nikNameImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_nikname"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nikNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "اسم مستعار"
        textField.textAlignment = .center
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: textField.frame.height))
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.widthAnchor.constraint(equalToConstant: 210).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.font(.IRANSans)
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .white
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "برای اینکه بتوانید از قسمت تالار استفاده نمائید، باید یک اسم مستعار برای خود انتخاب کنید."
        label.textColor = .white
        label.textAlignment = .right
        label.widthAnchor.constraint(equalToConstant: 230).isActive = true
        label.numberOfLines = 0
        label.font(.IRANSans, size: 12)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("تایید", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.accentColor
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.titleLabel?.font(.IRANYekanBold)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let topicTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 110
        tableView.semanticContentAttribute = .forceRightToLeft
        tableView.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xecf0f1)
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    let refreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup Category CV
        setupCV()
        
        self.view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xecf0f1)
        self.title = "تالار"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_create_topic"), style: .plain, target: self, action: #selector(onCreateTopicTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.uicolorFromHex(rgbValue: 0x92b03c)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_profile"), style: .plain, target: self, action: #selector(onSearchTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.uicolorFromHex(rgbValue: 0x92b03c)
        
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        topicTableView.refreshControl = refreshControl
        
        topicTableView.dataSource = self
        topicTableView.delegate = self
        topicTableView.register(TopicTableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupViews()
        
//        getDataFromServer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
//        self.trashModel.removeAll()
//        self.models.removeAll()
        self.filterCategory.removeAll()
        offset = 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionItems.keys.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let date = Array(self.sectionItems.keys)[section]
//
//        let headerView = UIView()
//
//        let label: UILabel = {
//            let l = UILabel()
//            l.font(.IRANYekanBold , size: 13)
//            l.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//            l.layer.cornerRadius = 20
//            l.translatesAutoresizingMaskIntoConstraints = false
//            l.textAlignment = .center
//            return l
//        }()
//
//        headerView.addSubview(label)
//        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
//        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
//        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "fa_IR")
//        dateFormatter.dateStyle = .medium
//        let today = dateFormatter.string(from: date)
//
//        label.text = today
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionItems[Array(self.sectionItems.keys)[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TopicTableViewCell
//        cell.model = self.sectionItems[Array(self.sectionItems.keys)[indexPath.section]]![indexPath.row]
        cell.model = self.sectionItems[self.sectionItems.keys.sorted(by: >)[indexPath.section]]![0]
        // TODO: verify my id
        
//        if indexPath.section == sectionItems.keys.count - 1 && indexPath.row == sectionItems[Array(self.sectionItems.keys)[indexPath.section]]!.count - 1 && !lockOffset && !loadNewArticle {
//            offset = offset + 1
//        }
        
        return cell
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.sectionItems.removeAll()
        self.models.removeAll()
        self.trashModel.removeAll()
        collectionView.reloadData()
        filterCategory.removeAll()
        offset = 0
    }
    
    var offset = 0 {
        didSet {
            getDataFromServer()
        }
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
        refreshControl.beginRefreshing()
        Http().request(endpoint: "topics/\(offset)") { (data, response, error) in
            if let data = data {
                do {
                    self.decoder.dateDecodingStrategy = .formatted(self.dateFormatterWithTime)
                    
                    let serverModels = try self.decoder.decode([Topic].self , from: data)
                    
                    if serverModels.count < self.limit {
                        // All topics loads
                        self.lockOffset = true
                    } else {
                        self.lockOffset = false
                    }
                    DispatchQueue.main.async {
                        self.trashModel.removeAll()
                        self.models.removeAll()
                        self.models += serverModels
                        self.trashModel += serverModels
                    }

                } catch let err {
                    print(err)
                }
            }
            self.loadNewArticle = false
        }
    }
    
    func setupViews() {
        self.view.addSubview(self.topicTableView)
        self.navigationController?.view.addSubview(blurEffectView)
        
        self.blurEffectView.contentView.addSubview(self.nikNameTextField)
        self.blurEffectView.contentView.addSubview(self.nikNameImageView)
        self.blurEffectView.contentView.addSubview(self.noticeLabel)
        self.blurEffectView.contentView.addSubview(self.submitButton)
        
//        self.blurEffectView.isHidden = UserDefaults.standard.bool(forKey: "userinfo")
        self.blurEffectView.isHidden = true
        
        self.nikNameTextField.centerYAnchor.constraint(equalTo: self.blurEffectView.centerYAnchor , constant: -75).isActive = true
        self.nikNameTextField.centerXAnchor.constraint(equalTo: self.blurEffectView.centerXAnchor).isActive = true
        
        self.nikNameImageView.centerXAnchor.constraint(equalTo: self.blurEffectView.centerXAnchor).isActive = true
        self.nikNameImageView.bottomAnchor.constraint(equalTo: self.nikNameTextField.topAnchor , constant: -17).isActive = true
        
        self.noticeLabel.centerXAnchor.constraint(equalTo: self.blurEffectView.centerXAnchor).isActive = true
        self.noticeLabel.topAnchor.constraint(equalTo: self.nikNameTextField.bottomAnchor , constant: 17).isActive = true
        
        self.submitButton.centerXAnchor.constraint(equalTo: self.blurEffectView.centerXAnchor).isActive = true
        self.submitButton.topAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor , constant: 17).isActive = true
        
        self.topicTableView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 4).isActive = true
        self.topicTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.topicTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topicTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        blurEffectView.frame = view.bounds
        
        blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBlurBackgroundTapped)))
        submitButton.addTarget(self, action: #selector(onSubmitTapped), for: .touchUpInside)
    }
    
    var isSendingReqest = false
    
    @objc func onSubmitTapped() {
        
        if isSendingReqest {
            return
        }
        
        guard let playerId = UserDefaults.standard.string(forKey: "player_id") else { return }
        
        guard let nikName = nikNameTextField.text , nikName != "" else { return }
        
        let realm = try! Realm()
        
        if let user = realm.objects(User.self).last {
            
            let parameters: Dictionary<String , Any> = [
                "user_id" : user.user_id,
                "player_id" : playerId,
                "nikname" : nikName
            ]
            
            isSendingReqest = true
            
            Http().request(endpoint: "userinfo", method: .POST, parameters: parameters) { (data, response, error) in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(Success.self, from: data)
                        if response.success == 1 {
                            UserDefaults.standard.set(true, forKey: "userinfo")
                            DispatchQueue.main.async {
                                self.navigationController?.view.endEditing(true)
                                self.blurEffectView.isHidden = true
                            }
                        } else {
                            self.isSendingReqest = false
                        }
                    } catch {
                        self.isSendingReqest = false
                    }
                } else {
                    self.isSendingReqest = false
                }
            }
        }
    }
    
    @objc func onBlurBackgroundTapped() {
        if UserDefaults.standard.bool(forKey: "userinfo") && !self.nikNameTextField.isEditing {
            self.blurEffectView.isHidden = true
        } else {
            self.navigationController?.view.endEditing(true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        let topicViewController = TopicViewController()
        topicViewController.topic = self.sectionItems[self.sectionItems.keys.sorted(by: >)[indexPath.section]]![0]
        
        self.navigationController?.pushViewController(topicViewController, animated: true)
    }
    
    @objc func onCreateTopicTapped() {
        self.present(UINavigationController(rootViewController: AddTopicViewController()), animated: true, completion: nil)
    }
    
    @objc func onSearchTapped() {
        self.blurEffectView.isHidden = false
    }

}
