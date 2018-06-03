//
//  ImageCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageItem: Item! {
        didSet {
            
            var height: CGFloat = 180
            if let aspectRatio = imageItem.images?[0].aspectRatio {
                height = (UIScreen.main.bounds.width - 2 * 4) * CGFloat(aspectRatio)
            }
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
            
            imageView.downloadedFrom(link: imageItem.images![0].imageURL!, contentMode: .scaleAspectFill, complition: { (loaded) in
                self.articleImageLoader.stopAnimating()
            })
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xf2f2f2)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let articleImageLoader: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * 4).isActive = true
        
        
        addSubview(imageView)
        addSubview(articleImageLoader)
        
        let views: [String: Any] = [
            "imageView": imageView,
            "articleImageLoader": articleImageLoader
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[imageView]-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[imageView]-|", options: [], metrics: nil, views: views))
        
        
        addConstraint(NSLayoutConstraint(item: self.articleImageLoader, attribute: .centerX, relatedBy: .equal, toItem: self.imageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.articleImageLoader, attribute: .centerY, relatedBy: .equal, toItem: self.imageView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
