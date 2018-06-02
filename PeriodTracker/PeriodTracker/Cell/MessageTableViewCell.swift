//
//  MessageTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/26/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var model: Message! {
        didSet {
            self.messageTextView.text = model.message
            self.nameLabel.text = model.user.nikname
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            self.timeLabel.text = dateFormatter.string(from: model.created_at)
            
            self.verfiedImageView.isHidden = model.user.verified != 1
            
            let fixedWidth = self.messageTextView.frame.size.width
            self.messageTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = self.messageTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = self.messageTextView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            self.messageTextView.frame = newFrame;
        }
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANYekan , size: 10)
        label.textColor = .lightGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANYekanBold , size: 12)
        label.textColor = .darkGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let verfiedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_verified_account"))
        
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 13).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let messageDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font(.IRANSans)
        textView.backgroundColor = Colors.accentColor
        textView.isScrollEnabled = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 15
        textView.textAlignment = .right
        textView.textColor = .white
        textView.isEditable = false
        textView.dataDetectorTypes = .link
//        textView.contentInset = UIEdgeInsetsMake(10, 14, 10, 14)
//        textView.numberOfLines = 0
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(self.messageDetailStackView)
        self.addSubview(messageTextView)
        
        self.messageDetailStackView.addArrangedSubview(self.timeLabel)
        self.messageDetailStackView.addArrangedSubview(self.nameLabel)
        self.messageDetailStackView.addArrangedSubview(self.verfiedImageView)
        
        self.verfiedImageView.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor).isActive = true
        
        self.messageDetailStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.messageDetailStackView.topAnchor.constraint(equalTo: self.topAnchor , constant: 11).isActive = true
        
        self.messageTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.messageTextView.topAnchor.constraint(equalTo: self.messageDetailStackView.bottomAnchor , constant: 1).isActive = true
        self.messageTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.messageTextView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
