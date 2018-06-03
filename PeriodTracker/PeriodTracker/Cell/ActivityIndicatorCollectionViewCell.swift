//
//  ActivityIndicatorCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/10/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ActivityIndicatorCollectionViewCell: UICollectionViewCell {
    
    let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(indicatorView)
        
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        indicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
