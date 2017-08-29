//
//  CommentTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/26/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    var comment: Comment! {
        didSet {
            let attributeString = NSMutableAttributedString(string: comment.content)
            let font = UIFont(name: "IRANYekanMobile-Light", size: 15)!
            let range = NSRange(location: 0, length: comment.content.characters.count)
            attributeString.addAttribute(NSFontAttributeName, value: font, range: range)
            
            // Center the text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.0
            paragraphStyle.minimumLineHeight = 20
            paragraphStyle.maximumLineHeight = 20
            paragraphStyle.alignment = .right
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
            
            contentTextView.attributedText = attributeString
            
            timeLabel.text = Utility.timeAgoSinceFromNow(comment.addedTime)
            nameLabel.text = comment.email.components(separatedBy: "@")[0]
            
            if comment.sendingComment {
                postingView.isHidden = false
                postingIndicatorView.isHidden = false
                
                UIView.animate(withDuration: 5, animations: {
                    self.postingIndicatorView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 2.5)
                }){ (finish) in
//                    self.widthIndicatorConstraint.constant = self.frame.width
                }
            } else {
                postingView.isHidden = true
                postingIndicatorView.isHidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.postingIndicatorView.frame = CGRect(x: 0, y: 0, width: 55, height: 2.5)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANYekanMobile-Bold", size: 17)
        label.text = "کاربر"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSans(FaNum)", size: 11)
        label.text = ""
        label.textColor = UIColor.black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.semanticContentAttribute = .forceRightToLeft
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let contentTextView: UILabel = {
        let textView = UILabel()
        textView.text = .bigLoremipsum
        textView.numberOfLines = 0
        textView.textAlignment = .right
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // posting comment elements
    
    let postingView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postingIndicatorView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0x4374e0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var widthIndicatorConstraint: NSLayoutConstraint!
    
    func setupViews() {
        
        self.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xb9c7d9).withAlphaComponent(0.3)
        
        self.addSubview(avatarImageView)
        self.commentDetailStackView.addArrangedSubview(nameLabel)
        self.commentDetailStackView.addArrangedSubview(timeLabel)
        self.addSubview(commentDetailStackView)
        self.addSubview(contentTextView)
        
        self.addSubview(postingView)
        self.addSubview(postingIndicatorView)
        
        self.postingView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.postingView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.postingView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.postingView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.postingIndicatorView.frame = CGRect(x: 0, y: 0, width: 55, height: 2.5)
        
        self.avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 7).isActive = true
        self.avatarImageView.topAnchor.constraint(equalTo: self.topAnchor , constant: 7).isActive = true
        
        self.commentDetailStackView.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor , constant: 7).isActive = true
        self.commentDetailStackView.topAnchor.constraint(equalTo: self.topAnchor , constant: 14).isActive = true
        
        self.contentTextView.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor , constant: 7).isActive = true
        self.contentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -7).isActive = true
        self.contentTextView.topAnchor.constraint(equalTo: self.commentDetailStackView.bottomAnchor , constant: 14).isActive = true
        self.contentTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: -14).isActive = true
    }

}
