//
//  ArticlePageViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ArticlePageViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    var article: Article!

    let articleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xF6F6F6)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "IRANSansFaNum", size: 20)! , NSForegroundColorAttributeName: UIColor.uicolorFromHex(rgbValue: 0x76858e)]
        
        self.view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF6F6F6)
        setupViews()
        
        self.title = article.title
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        articleCollectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        articleCollectionView.register(AttributeTextCollectionViewCell.self, forCellWithReuseIdentifier: "text_cell")
        articleCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "image_cell")
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
    }

    func setupViews() {
        self.view.addSubview(articleCollectionView)
        
        var allConstraints = [NSLayoutConstraint]()
        let views: [String: Any] = [
            "topLayoutGuide": topLayoutGuide,
            "articleCollectionView": articleCollectionView
        ]
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[articleCollectionView]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[articleCollectionView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(allConstraints)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return article.content.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCollectionViewCell
            cell.backgroundColor = .white
            cell.article = article
            return cell
        } else if article.content[indexPath.item - 1].type == ItemType.AttributeText {
            let textItem = article.content[indexPath.item - 1]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "text_cell", for: indexPath) as! AttributeTextCollectionViewCell
            cell.backgroundColor = .white
            cell.textItem = textItem
            return cell
        } else if article.content[indexPath.item - 1].type == ItemType.Image {
            let imageItem = article.content[indexPath.item - 1]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! ImageCollectionViewCell
            cell.backgroundColor = .white
            cell.imageItem = imageItem
            return cell
        }else {
            
        }
        let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCollectionViewCell
        cell.backgroundColor = .white
        cell.article = article
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: self.view.frame.width , height: 300)
        }  else if article.content[indexPath.item - 1].type == ItemType.AttributeText {
            var abortedFontCount = 0
            var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            let text = article.content[indexPath.item - 1].text!
            if let attributes = article.content[indexPath.item - 1].attributes {
                for attribute in attributes {
                    let range = attribute.range == nil ? NSRange(location: 0, length: text.characters.count) : attribute.range!
                    if Double(range.length / text.characters.count) < 0.5 {
                        abortedFontCount += 1
                        continue
                    }
                    if attribute.key == "font" {
                        font = UIFont(name: attribute.value!, size: 15)!
                    }
                }
            }
            
            let boundingRect = NSString(string: text).boundingRect(with: CGSize(width: collectionView.bounds.width, height: 1000),
                                                                           options: .usesLineFragmentOrigin,
                                                                           attributes: [NSFontAttributeName: font],
                                                                           context: nil)
            
            return CGSize(width: self.view.frame.width, height: boundingRect.height + CGFloat(abortedFontCount * 15))
        } else if article.content[indexPath.item - 1].type == ItemType.Image {
            return CGSize(width: self.view.frame.width, height: 180)
        }
        return CGSize(width: self.view.frame.width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 && article.content[indexPath.item - 1].type == .Image && !(article.content[indexPath.item - 1].images![0].link?.isEmpty)! {
            
            Utility.openLinkInSafari(link: article.content[indexPath.item - 1].images![0].link!)

        } else if indexPath.item != 0 && article.content[indexPath.item - 1].type == .AttributeText && !(article.content[indexPath.item - 1].link?.isEmpty)! {
            
            Utility.openLinkInSafari(link: article.content[indexPath.item - 1].link!)
        }
    }

}
