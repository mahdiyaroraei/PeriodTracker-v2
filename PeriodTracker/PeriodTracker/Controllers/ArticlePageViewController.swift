//
//  ArticlePageViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SwiftyJSON

class ArticlePageViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    var article: Article!

    let articleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xF6F6F6)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let loadingActivityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorView.startAnimating()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    let indicatorHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        view.layer.cornerRadius = 10
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !Config.isPermiumUser {
            self.present(LicenseViewController(), animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "IRANSansFaNum", size: 20)! , NSForegroundColorAttributeName: UIColor.uicolorFromHex(rgbValue: 0x76858e)]
        
        self.view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF6F6F6)
        setupViews()
        
        self.title = article.title
        
        articleCollectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        articleCollectionView.register(AttributeTextCollectionViewCell.self, forCellWithReuseIdentifier: "text_cell")
        articleCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "image_cell")
        articleCollectionView.register(ArticleCommentCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "comment_header")
        articleCollectionView.register(ArticleFooterTableViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "comment_footer")
        
        
        if let flowLayout = articleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width,height: 105 + (self.view.frame.width) * 0.55)
        }
        
//        self.articleCollectionView.delegate = self
//        self.articleCollectionView.dataSource = self
        
        let realm = try! Realm()
        if let user = realm.objects(User.self).last {
            Alamofire.request("\(Config.WEB_DOMAIN)article/\(article.id!)/\(user.license_id)/\(user.user_id)").responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    self.indicatorHolderView.isHidden = true
                    
                    if let article = JSON(data).array {
                        self.article.content = Utility.createContentFromJSON(article[0])
                        self.articleCollectionView.delegate = self
                        self.articleCollectionView.dataSource = self
                    } else if let subscribe = JSON(data)["subscribe"].int , subscribe == 0 {
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.pushViewController(PricingViewController(), animated: true)
                    }
                }
            })
        } else {
            Alamofire.request("\(Config.WEB_DOMAIN)article/\(article.id!)").responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    self.indicatorHolderView.isHidden = true
                    if let article = JSON(data).array {
                        self.article.content = Utility.createContentFromJSON(article[0])
                        
                        self.articleCollectionView.delegate = self
                        self.articleCollectionView.dataSource = self
                    } else if let subscribe = JSON(data)["subscribe"].int , subscribe == 0 {
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.pushViewController(PricingViewController(), animated: true)
                    }
                }
            })
        }
        
        
    }

    func setupViews() {
        
        self.indicatorHolderView.addSubview(loadingActivityIndicatorView)
        self.view.addSubview(articleCollectionView)
        self.view.addSubview(indicatorHolderView)
        
        var allConstraints = [NSLayoutConstraint]()
        let views: [String: Any] = [
            "topLayoutGuide": topLayoutGuide,
            "articleCollectionView": articleCollectionView,
            "indicatorHolderView": indicatorHolderView
        ]
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[articleCollectionView]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[articleCollectionView]|", options: [], metrics: nil, views: views)
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[indicatorHolderView(100)]", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[indicatorHolderView(100)]", options: [], metrics: nil, views: views)
        
        allConstraints.append(NSLayoutConstraint(item: self.indicatorHolderView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        allConstraints.append(NSLayoutConstraint(item: self.indicatorHolderView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        
        allConstraints.append(NSLayoutConstraint(item: self.loadingActivityIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.indicatorHolderView, attribute: .centerX, multiplier: 1, constant: 0))
        allConstraints.append(NSLayoutConstraint(item: self.loadingActivityIndicatorView, attribute: .centerY, relatedBy: .equal, toItem: self.indicatorHolderView, attribute: .centerY, multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return article.content.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCollectionViewCell
            cell.backgroundColor = .white
            cell.article = article
            return cell
        } else {
            if article.content[indexPath.item].type == ItemType.AttributeText {
                let textItem = article.content[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "text_cell", for: indexPath) as! AttributeTextCollectionViewCell
                cell.backgroundColor = .white
                cell.textItem = textItem
                return cell
            } else if article.content[indexPath.item].type == ItemType.Image {
                let imageItem = article.content[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! ImageCollectionViewCell
                cell.backgroundColor = .white
                cell.imageItem = imageItem
                return cell
            }
        }
        let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCollectionViewCell
        cell.backgroundColor = .white
        cell.article = article
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 175)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "comment_header", for: indexPath) as! ArticleCommentCollectionViewCell
            
            headerView.commentCount = self.article.comment_count
            
            headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(conversationHeaderTapped)))
            
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "comment_footer", for: indexPath) as! ArticleFooterTableViewCell
            
            headerView.article = self.article
            
            return headerView
            
        default:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "comment_footer", for: indexPath) as! ArticleFooterTableViewCell
            
            headerView.article = self.article
            
            return headerView
        }
    }
    
    func conversationHeaderTapped() {
        let vc = ConversationViewController()
        vc.articleId = self.article.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            if indexPath.item != 0 && article.content[indexPath.item].type == .Image && (article.content[indexPath.item].images![0].link != nil) {
                
                Utility.openLinkInSafari(link: article.content[indexPath.item].images![0].link!)
                
            } else if indexPath.item != 0 && article.content[indexPath.item].type == .AttributeText && !(article.content[indexPath.item].link?.isEmpty)! {
                
                Utility.openLinkInSafari(link: article.content[indexPath.item].link!)
            }
        }
    }

}
