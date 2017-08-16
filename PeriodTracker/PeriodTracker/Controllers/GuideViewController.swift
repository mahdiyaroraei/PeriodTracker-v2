//
//  GuideViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/12/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class GuideViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    var guide: Guide! {
        didSet {
            titleLabel.text = guide.fa_key
            
            articleCollectionView.delegate = self
            articleCollectionView.dataSource = self
        }
    }
    
    let navItemView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF6F6F6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x76858F)
        label.font = UIFont(name: "IRANSansFaNum-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("بستن", for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x7BA013), for: .normal)
        button.titleLabel?.font = UIFont(name: "IRANSansFaNum-Bold", size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        self.view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF6F6F6)
        setupViews()
        
        articleCollectionView.register(AttributeTextCollectionViewCell.self, forCellWithReuseIdentifier: "text_cell")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guide.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let textItem = guide.content[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "text_cell", for: indexPath) as! AttributeTextCollectionViewCell
        cell.backgroundColor = .white
        cell.textItem = textItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var abortedFontCount = 0
        var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let text = guide.content[indexPath.item].text!
        if let attributes = guide.content[indexPath.item].attributes {
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
        
    }
    
    func setupViews() {
        self.navItemView.addSubview(titleLabel)
        self.navItemView.addSubview(closeButton)
        self.view.addSubview(navItemView)
        
        self.view.addSubview(articleCollectionView)
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        var allConstraints = [NSLayoutConstraint]()
        let views: [String: Any] = [
            "topLayoutGuide": topLayoutGuide,
            "navItemView": navItemView,
            "titleLabel": titleLabel,
            "closeLabel": closeButton,
            "articleCollectionView": articleCollectionView
        ]
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[topLayoutGuide][navItemView(45)]", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[navItemView]|", options: [], metrics: nil, views: views)
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[titleLabel]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-7-[titleLabel]|", options: [], metrics: nil, views: views)
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[closeLabel]", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-7-[closeLabel]|", options: [], metrics: nil, views: views)
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[navItemView][articleCollectionView]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[articleCollectionView]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        closeButton.addTarget(self, action: #selector(dismissViewController(sender:)), for: .touchUpInside)
    }
    
    func dismissViewController(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
