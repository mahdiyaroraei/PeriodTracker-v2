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
        getArticlesFromServer()
        
        articleCollectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func getArticlesFromServer() {
        let parameters: Parameters = [
            "limit": 10,
            "offset": 0
        ]
        
        Alamofire.request("\(Config.WEB_DOMAIN)articles", method: .get, parameters:parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data{
                let parsedResult = JSON(data: data)
                for json in parsedResult.array! {
                    
                    var items: [Item] = []
                    let parsedItem = JSON(json["content"].string!.data(using: .utf8)!)
                    for itemJson in parsedItem.array! {
                        if itemJson["type"].string! == ItemType.AttributeText.rawValue {
                            var attributes: [TextAttribute] = []
                            for jsonAttribute in itemJson["attributes"].array! {
                                attributes.append(TextAttribute(key: jsonAttribute["key"].string!, value: jsonAttribute["value"].string, range: jsonAttribute["range"].string))
                            }
                            let textItem = Item(text: itemJson["text"].string!, attributes: attributes)
                            items.append(textItem)
                        } else if itemJson["type"].string! == ItemType.Image.rawValue {
                            var images: [String] = []
                            for jsonAttribute in itemJson["images"].array! {
                                images.append(jsonAttribute.string!)
                            }
                            let imageItem = Item(images: images)
                            items.append(imageItem)
                        }
                    }
                    
                    let article = Article(id: json["id"].int, title: json["title"].string, addedtime: json["addedtime"].string, view: json["view"].int, clap: json["clap"].int, desc: json["desc"].string, image: json["image"].string, content: items, creator_name: json["creator_name"].string, article_read_time: json["article_read_time"].string)
                    
                    self.articles.append(article)
                }
                
                self.articleCollectionView.delegate = self
                self.articleCollectionView.dataSource = self
            }
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
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCollectionViewCell
        cell.backgroundColor = .white
        cell.article = articles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 6, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(4, 3, 4, 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ArticlePageViewController()
        vc.article = articles[indexPath.item]
        present(vc, animated: true, completion: nil)
    }

}
