//
//  TopicTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/25/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {
    let colorName = [Colors.niceBlue, Colors.niceYellow, Colors.niceRed, Colors.niceGreen]

    var model: Topic! {
        didSet {
            self.backgroundColor = .clear
            
            self.dateLabel.text = Utility.timeAgoSince(model.updated_at)
            self.subjectLabel.text = model.subject
            self.descLabel.text = model.content
            
            if model.category == "pregnant"{
                self.topicMenuIconImageView.tintColor = colorName[0]
            } else if model.category == "sick"{
                self.topicMenuIconImageView.tintColor = colorName[1]
            } else if model.category == "period"{
                self.topicMenuIconImageView.tintColor = colorName[2]
            } else {
                self.topicMenuIconImageView.tintColor = colorName[3]
            }
            
            self.verfiedImageView.isHidden = model.user.verified != 1
        }
    }
    
    
    let topicMenuIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_topic_menu")?.withRenderingMode(.alwaysTemplate)
        
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANYekanBold , size: 23)
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x4D4D4D)
        label.numberOfLines = 1
        label.textAlignment = .right
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let verfiedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_verified_account"))
        
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 23).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANSans , size: 12)
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x7CA012)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font(.IRANSansUltraLight)
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x4D4D4D)
        label.numberOfLines = 0
        label.textAlignment = .right
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepareForReuse()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(backView)
        self.addSubview(topicMenuIconImageView)
        self.addSubview(dateLabel)
        self.addSubview(subjectLabel)
        self.addSubview(verfiedImageView)
        self.addSubview(descLabel)

        self.backView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        self.backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        self.backView.heightAnchor.constraint(equalToConstant: 105).isActive = true
        
        self.topicMenuIconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 17).isActive = true
        self.topicMenuIconImageView.topAnchor.constraint(equalTo: self.topAnchor , constant: 17).isActive = true
        
        self.dateLabel.centerYAnchor.constraint(equalTo: self.topicMenuIconImageView.centerYAnchor).isActive = true
        self.dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -17).isActive = true
        
        self.subjectLabel.centerYAnchor.constraint(equalTo: self.topicMenuIconImageView.centerYAnchor).isActive = true
        self.subjectLabel.leadingAnchor.constraint(equalTo: self.topicMenuIconImageView.trailingAnchor , constant: 17).isActive = true
        self.subjectLabel.trailingAnchor.constraint(equalTo: self.verfiedImageView.leadingAnchor , constant: -3).isActive = true
        
        
        self.verfiedImageView.leadingAnchor.constraint(equalTo: self.subjectLabel.trailingAnchor , constant: 7).isActive = true
        self.verfiedImageView.trailingAnchor.constraint(equalTo: self.dateLabel.leadingAnchor , constant: -7).isActive = true
        self.verfiedImageView.centerYAnchor.constraint(equalTo: self.subjectLabel.centerYAnchor).isActive = true
        
        self.descLabel.leadingAnchor.constraint(equalTo: self.subjectLabel.leadingAnchor , constant: 17).isActive = true
        self.descLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -7).isActive = true
        self.descLabel.topAnchor.constraint(equalTo: self.subjectLabel.bottomAnchor , constant: 7).isActive = true
        self.descLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: -7).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dateLabel.text = nil
        self.subjectLabel.text = nil
        self.descLabel.text = nil
        self.topicMenuIconImageView.tintColor = nil
    }
}
