//
//  AttributeTextCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class AttributeTextCollectionViewCell: UICollectionViewCell {
    
    var textItem: Item! {
        didSet {
            textView.attributedText = Utility.createAttributeTextFromTextItem(textItem: textItem!)
        }
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .right
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        let views = [
            "textView": textView
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textView]-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textView]-|", options: [], metrics: nil, views: views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
