//
//  ArticleCategoryCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/23/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ArticleCategoryCollectionViewCell: UICollectionViewCell {
    
    var category: Category! {
        didSet {
            if category.id == -1 {
                self.categoryImageView.image = UIImage(named: "all_filter")
            } else {
                self.categoryImageView.downloadedFrom(link: category.imageURL)
            }
        }
    }
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xf2f2f2)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xb3b3b3).cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.loadingIndicator)
        addSubview(self.categoryImageView)
        
        self.categoryImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.categoryImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.categoryImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.categoryImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func didSelect() {
        self.categoryImageView.layer.borderWidth = 2.5
        self.categoryImageView.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0x087bed).cgColor
    }
    
    func didDeSelect() {
        self.categoryImageView.layer.borderWidth = 1
        self.categoryImageView.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xb3b3b3).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
