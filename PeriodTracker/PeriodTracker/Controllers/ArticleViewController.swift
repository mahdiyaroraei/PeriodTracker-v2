//
//  ArticleViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/6/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class ArticleViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    
    // Models
    var articles: [Article] = []
    
    var offset: Int! {
        didSet {
            getArticlesFromServer()
        }
    }
    
    var lockOffset = false
    
    var loadNewArticle: Bool! = true {
        didSet {
            self.articleCollectionView.reloadData()
        }
    }
    
    let articleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xDCDCDC)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xDCDCDC)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        self.title = "مقالات"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "IRANSansFaNum", size: 20)! , NSForegroundColorAttributeName: UIColor.uicolorFromHex(rgbValue: 0x76858e)]
        
        articleCollectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        articleCollectionView.register(ActivityIndicatorCollectionViewCell.self, forCellWithReuseIdentifier: "loading_cell")
        categoryCollectionView.register(ArticleCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "category_cell")
        
        self.articleCollectionView.delegate = self
        self.articleCollectionView.dataSource = self
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        offset = 0
        getArticleCategories()
    }
    
    static var subscribe: Bool?
    var deadLineButton: UIButton? = nil
    
    func checkSubscribe() {
        let realm = try! Realm()
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.startAnimating()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
        
        if let user = realm.objects(User.self).last {
            Alamofire.request("\(Config.WEB_DOMAIN)subscribe/\(user.license_id)/\(user.user_id)").responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    guard let subscribe = JSON(data)["subscribe"].int else {
                        return
                    }
                    
                    ArticleViewController.subscribe = subscribe == 1
                    
                    var subscribeButtonString = "اشتراک ندارید"
                    if let subscribeDate = JSON(data)["subscribe_expire_on"].string {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let date = dateFormatter.date(from: subscribeDate) {
                            subscribeButtonString = Utility.persianDate(from: date)
                        }
                    }
                    if let deadLineButton = self.deadLineButton {
                        deadLineButton.setTitle(subscribeButtonString , for: .normal)
                    } else {
                        self.deadLineButton = UIButton()
                        self.deadLineButton?.setTitle(subscribeButtonString , for: .normal)
                        self.deadLineButton?.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xdb2b42), for: .normal)
                        self.deadLineButton?.titleLabel?.textAlignment = .center
                        self.deadLineButton?.titleLabel?.font = UIFont(name: "IRANSansFaNum-Medium", size: 12)!
                        self.deadLineButton?.layer.borderWidth = 2
                        self.deadLineButton?.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xdb2b42).cgColor
                        self.deadLineButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
                        self.deadLineButton?.layer.cornerRadius = 4
                        self.deadLineButton?.frame = CGRect(x: 0, y: 0, width: 75, height: 25)
                    }
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.deadLineButton!)
                    
                } else {
                    var subscribeButtonString = "اشتراک ندارید"
                    self.deadLineButton = UIButton()
                    self.deadLineButton?.setTitle(subscribeButtonString , for: .normal)
                    self.deadLineButton?.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xdb2b42), for: .normal)
                    self.deadLineButton?.titleLabel?.textAlignment = .center
                    self.deadLineButton?.titleLabel?.font = UIFont(name: "IRANSansFaNum-Medium", size: 12)!
                    self.deadLineButton?.layer.borderWidth = 2
                    self.deadLineButton?.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xdb2b42).cgColor
                    self.deadLineButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
                    self.deadLineButton?.layer.cornerRadius = 4
                    self.deadLineButton?.frame = CGRect(x: 0, y: 0, width: 75, height: 25)
                    
                    ArticleViewController.subscribe = false
                    
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.deadLineButton!)
                }
            })
        } else {
            
            var subscribeButtonString = "اشتراک ندارید"
            self.deadLineButton = UIButton()
            self.deadLineButton?.setTitle(subscribeButtonString , for: .normal)
            self.deadLineButton?.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xdb2b42), for: .normal)
            self.deadLineButton?.titleLabel?.textAlignment = .center
            self.deadLineButton?.titleLabel?.font = UIFont(name: "IRANSansFaNum-Medium", size: 12)!
            self.deadLineButton?.layer.borderWidth = 2
            self.deadLineButton?.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xdb2b42).cgColor
            self.deadLineButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
            self.deadLineButton?.layer.cornerRadius = 4
            self.deadLineButton?.frame = CGRect(x: 0, y: 0, width: 75, height: 25)
            
            ArticleViewController.subscribe = false
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.deadLineButton!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkSubscribe()
    }
    
    // Scrolls to top nicely
    func scrollToTop() {
        self.articleCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        
        if self.categoryCollectionViewHeightConstraint.constant == 0 {
            UIView.animate(withDuration: 0.35, animations: {
                self.categoryCollectionViewHeightConstraint.constant = 120
                self.categoryCollectionView.layoutIfNeeded()
            })
        }
    }
    
    var categoryId: Int? {
        didSet {
            articles.removeAll()
            if let articleRequest = self.articleRequest {
                articleRequest.cancel()
            }
            offset = 0
        }
    }
    
    var articleRequest: DataRequest?
    
    func getArticlesFromServer() {
        // Show loading here
        self.loadNewArticle = true
        
        let limit = 10
        
        let parameters: Parameters = [
            "limit": limit,
            "offset": offset
        ]
        
        var link = "\(Config.WEB_DOMAIN)articles"
        if let categoryId = categoryId , categoryId > 0 {
            link = "\(Config.WEB_DOMAIN)articles/\(categoryId)"
        }
        
        self.articleRequest = Alamofire.request(link, method: .get, parameters:parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data{
                let parsedResult = JSON(data: data)
                if let array = parsedResult.array {
                    for json in array {
                        self.articles.append(Utility.createArticleFromJSON(json))
                    }
                    if array.count < limit {
                        // All article loads
                        self.lockOffset = true
                    } else {
                        self.lockOffset = false
                    }
                } else {
                    // All article loads
                    self.lockOffset = true
                }
                
            }
            // Hide loading
            self.loadNewArticle = false
        }
    }
    
    var categories: [Category] = [Category()]
    
    func getArticleCategories() {
        Alamofire.request("\(Config.WEB_DOMAIN)categories").responseJSON { (response) in
            if let data = response.data {
                if let categoriesArray = JSON(data).array {
                    for category in categoriesArray {
                        self.categories.append(Category(id: Int(category["id"].string!)!, imageURL: category["image_url"].string!, name: category["name"].string!))
                    }
                    self.categoryCollectionView.delegate = self
                    self.categoryCollectionView.dataSource = self
                }
            }
        }
    }
    
    var categoryCollectionViewHeightConstraint: NSLayoutConstraint!
    
    func setupViews() {
        self.view.addSubview(categoryCollectionView)
        self.view.addSubview(articleCollectionView)
        
        var allConstraints = [NSLayoutConstraint]()
        let views: [String: Any] = [
            "topLayoutGuide": topLayoutGuide,
            "articleCollectionView": articleCollectionView,
            "categoryCollectionView": categoryCollectionView
        ]
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[topLayoutGuide][categoryCollectionView][articleCollectionView]-\((self.tabBarController?.tabBar.frame.height)!)-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[articleCollectionView]|", options: [], metrics: nil, views: views)
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[categoryCollectionView]|", options: [], metrics: nil, views: views)
        
        categoryCollectionViewHeightConstraint = self.categoryCollectionView.heightAnchor.constraint(equalToConstant: 120)
        categoryCollectionViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate(allConstraints)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == articleCollectionView {
            if loadNewArticle {
                return articles.count + 1
            } else {
                return articles.count
            }
        } else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == articleCollectionView {
            if loadNewArticle && indexPath.item >= articles.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loading_cell", for: indexPath) as! ActivityIndicatorCollectionViewCell
                return cell
            } else {
                let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCollectionViewCell
                cell.backgroundColor = .white
                cell.article = articles[indexPath.item]
                
                if indexPath.item == articles.count - 1 && !loadNewArticle && !lockOffset {
                    offset = offset + 1
                }
                
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category_cell", for: indexPath) as! ArticleCategoryCollectionViewCell
            cell.category = categories[indexPath.item]
            if indexPath.item == selectedCategory {
                cell.didSelect()
            } else {
                cell.didDeSelect()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == articleCollectionView {
            if loadNewArticle && indexPath.item == articles.count {
                return CGSize(width: self.view.frame.width - 6, height: 100)
            } else {
                return CGSize(width: self.view.frame.width - 6, height: 125 + (self.view.frame.width - 6) * 0.55)
            }
        } else {
            return CGSize(width: 175, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.articleCollectionView {
            
            return UIEdgeInsetsMake(4, 3, 4, 3)
        } else {
            
            return UIEdgeInsetsMake(10, 3, 10, 3)
        }
    }
    
    var selectedCategory = 0
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == articleCollectionView {
            
            let vc = ArticlePageViewController()
            let article = articles[indexPath.item]
            
            if article.access == "subscribe" && !ArticleViewController.subscribe! { // TODO if let for subscribe
                navigationController?.pushViewController(PricingViewController(), animated: true)
            } else {
                article.increaseView()
                vc.article = article
                navigationController?.pushViewController(vc, animated: true)
                
                Alamofire.request("\(Config.WEB_DOMAIN)view/\(article.id!)")
            }
        } else if collectionView == categoryCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! ArticleCategoryCollectionViewCell
            cell.didSelect()
            selectedCategory = indexPath.item
            collectionView.reloadData()
            
            categoryId = categories[indexPath.item].id
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            if collectionView.cellForItem(at: indexPath) == nil {
                return
            }
            let cell = collectionView.cellForItem(at: indexPath) as! ArticleCategoryCollectionViewCell
            cell.didDeSelect()
        }
    }
    
    var currentPositionCollectionView: CGFloat = 0 , previousPositionCollectionView: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -40 {
            
            UIView.animate(withDuration: 0.35, animations: {
                self.categoryCollectionViewHeightConstraint.constant = 120
                self.categoryCollectionView.layoutIfNeeded()
            })
        } else if scrollView.contentOffset.y > 150{
            if self.categoryCollectionViewHeightConstraint.constant > 0 {
                
                UIView.animate(withDuration: 0.35, animations: {
                    self.categoryCollectionViewHeightConstraint.constant = 0
                    self.categoryCollectionView.layoutIfNeeded()
                })
            }
        }
        
    }
    
}
