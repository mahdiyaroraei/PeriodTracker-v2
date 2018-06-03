//
//  ArticleCommentCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ArticleCommentCollectionViewCell: UICollectionReusableView {
    var commentCount: Int! {
        didSet {
            
            let text = "\(commentCount!) نظر و سوال"
            let attributeString = NSMutableAttributedString(string: text)
            
            attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANYekanMobile", size: 15)!, range: NSRange(location: 0, length: text.characters.count))
            
            attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Bold", size: 17)!, range: NSRange(location: 0, length: 2))
            
            self.conversationLabel.attributedText = attributeString
            
        }
    }
    
    var borderView: UIView {
        get {
            let view = UIView()
            view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xb3b3b3).withAlphaComponent(0.9)
            view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }
    
    var profileImageView: UIImageView {
        get {
            let imageView = UIImageView(image: UIImage(named: "user"))
            imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
    
    let userProfilesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackView.spacing = -15
        stackView.semanticContentAttribute = .forceRightToLeft
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let viewConversationButton: UIButton = {
        let button = UIButton()
        button.setTitle("مشاهده", for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xdb2b42), for: .normal)
        button.setTitleColor(.blue, for: .selected)
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = UIFont(name: "IRAN Kharazmi", size: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let conversationLabel: UILabel = {
        let label = UILabel()
        let text = "۱۳+ نظر و سوال"
        let attributeString = NSMutableAttributedString(string: text)
        
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANYekanMobile", size: 15)!, range: NSRange(location: 0, length: text.characters.count))
        
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANYekanMobile-Bold", size: 17)!, range: NSRange(location: 0, length: 3))
        
        label.attributedText = attributeString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        self.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xf1f8ff)
        
        for _ in 0..<4 {
            userProfilesStackView.addArrangedSubview(profileImageView)
        }
        
        let topBorderView = borderView
        let bottomBorderView = borderView
        
        addSubview(topBorderView)
        addSubview(userProfilesStackView)
        addSubview(conversationLabel)
        addSubview(viewConversationButton)
        addSubview(bottomBorderView)
        
        userProfilesStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -10).isActive = true
        userProfilesStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        topBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topBorderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bottomBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        conversationLabel.trailingAnchor.constraint(equalTo: userProfilesStackView.leadingAnchor , constant: -7).isActive = true
        conversationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        viewConversationButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        viewConversationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
