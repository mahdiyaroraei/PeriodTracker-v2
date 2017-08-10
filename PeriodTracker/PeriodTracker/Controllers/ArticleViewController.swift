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

class ArticleViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    
    // Models
    var articles: [Article] = []
    
    var offset: Int! {
        didSet {
            getArticlesFromServer()
        }
    }
    
    var lockOffset = false
    
    var loadNewArticle: Bool! {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        offset = 7
        
        articleCollectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        articleCollectionView.register(ActivityIndicatorCollectionViewCell.self, forCellWithReuseIdentifier: "loading_cell")
        self.articleCollectionView.delegate = self
        self.articleCollectionView.dataSource = self
    }
    
    func getArticlesFromServer() {
        // Show loading here
        self.loadNewArticle = true
        
        let parameters: Parameters = [
            "limit": 10,
            "offset": offset
        ]
        
        Alamofire.request("\(Config.WEB_DOMAIN)articles", method: .get, parameters:parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data{
                let parsedResult = JSON(data: data)
                if let array = parsedResult.array {
                    for json in array {
                        self.articles.append(Utility.createArticleFromJSON(json))
                    }
                    if array.count == 0 {
                        // All article loads
                        self.lockOffset = true
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
    
    func setupViews() {
        self.view.addSubview(articleCollectionView)
        
        var allConstraints = [NSLayoutConstraint]()
        let views: [String: Any] = [
            "topLayoutGuide": topLayoutGuide,
            "articleCollectionView": articleCollectionView
        ]
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[topLayoutGuide][articleCollectionView]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[articleCollectionView]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if loadNewArticle {
            return articles.count + 1
        } else {
            return articles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if loadNewArticle && indexPath.item == articles.count {
            return CGSize(width: self.view.frame.width - 6, height: 100)
        } else {
            return CGSize(width: self.view.frame.width - 6, height: 280)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(4, 3, 54, 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ArticlePageViewController()
        let article = articles[indexPath.item]
        article.increaseView()
        vc.article = article
        present(vc, animated: true, completion: nil)
        
        Alamofire.request("\(Config.WEB_DOMAIN)view/\(article.id!)")
    }
    

}
