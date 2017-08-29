//
//  ReplyCommentTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/27/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ReplyCommentTableViewCell: UITableViewCell {
    
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
            nameLabel.text = "متخصص رویان"
        }
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
        imageView.image = UIImage(named: "period_tracker")
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANYekanMobile-Bold", size: 17)
        label.text = "مریم نظری ."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSans(FaNum)", size: 11)
        label.text = "۵ دقیقه قبل"
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
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xffe0e1).withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        
        self.addSubview(bgView)
        self.addSubview(avatarImageView)
        self.commentDetailStackView.addArrangedSubview(nameLabel)
        self.commentDetailStackView.addArrangedSubview(timeLabel)
        self.addSubview(commentDetailStackView)
        self.addSubview(contentTextView)
        
        self.bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 64).isActive = true
        self.bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 71).isActive = true
        self.avatarImageView.topAnchor.constraint(equalTo: self.topAnchor , constant: 7).isActive = true
        
        self.commentDetailStackView.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor , constant: 7).isActive = true
        self.commentDetailStackView.topAnchor.constraint(equalTo: self.topAnchor , constant: 14).isActive = true
        
        self.contentTextView.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor , constant: 7).isActive = true
        self.contentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -7).isActive = true
        self.contentTextView.topAnchor.constraint(equalTo: self.commentDetailStackView.bottomAnchor , constant: 14).isActive = true
        self.contentTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: -14).isActive = true
    }
}
