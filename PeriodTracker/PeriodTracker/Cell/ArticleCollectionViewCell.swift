//
//  ArticleCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/6/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    var article: Article!{
        didSet {
            subjectLabel.text = article.title
            articleDescriptionLabel.text = article.desc!
            viewCountLabel.text = "\(article.view!.forrmated)"
            clapCountLabel.text = "\(article.clap!.forrmated)"
            
            if let readTime = article.article_read_time {
                readTimeLabel.text = "زمان مطالعه: حدود \(readTime) دقیقه"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3:30") //Current time zone
            let date = dateFormatter.date(from: article.addedtime!) //according to date format your date string
            
            articleAddTimeLabel.text = Utility.timeAgoSince(date!)
            
            if let imageURL = article.image {
                articleImageView.downloadedFrom(link: imageURL)
            }
        }
    }
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "test_article"))
//        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let creatorIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "period_tracker"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSansFaNum-Bold", size: 13)
        label.textColor = .darkGray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
//        label.backgroundColor = .yellow
        label.textAlignment = .right
        label.text = "عنوان تست"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let articleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSans(FaNum)", size: 10)
        label.textColor = .lightGray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.textAlignment = .right
        label.text = String.loremipsum
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subjectStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = UIStackViewAlignment.trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let articleAddTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSans(FaNum)", size: 9)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "همین الان"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xC0C0C0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Views count views
    let viewImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "eye-2"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSansFaNum-Medium", size: 11)
        label.textColor = .darkGray
        label.text = "7.1 هزار"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewCountStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = UIStackViewAlignment.center
        stackView.alignment = UIStackViewAlignment.trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Claps count views
    
    let clapImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clapping"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let clapCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSansFaNum-Medium", size: 11)
        label.textColor = .darkGray
        label.text = "756"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clapCountStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = UIStackViewAlignment.center
        stackView.alignment = UIStackViewAlignment.trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Read time views
    
    let timeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let readTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSans(FaNum)", size: 11)
        label.textColor = .darkGray
        label.text = "زمان مطالعه: حدود ۶ دقیقه"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let readTimeStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = UIStackViewAlignment.center
        stackView.alignment = UIStackViewAlignment.trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(articleImageView)
        addSubview(creatorIconImageView)
        subjectStack.addArrangedSubview(subjectLabel)
        subjectStack.addArrangedSubview(articleDescriptionLabel)
        addSubview(subjectStack)
        addSubview(articleAddTimeLabel)
        addSubview(seperatorView)
        
        // view stack
        viewCountStack.addArrangedSubview(viewCountLabel)
        viewCountStack.addArrangedSubview(viewImageView)
        addSubview(viewCountStack)

        // clap stack
        clapCountStack.addArrangedSubview(clapCountLabel)
        clapCountStack.addArrangedSubview(clapImageView)
        addSubview(clapCountStack)
        
        // read time stack
        readTimeStack.addArrangedSubview(readTimeLabel)
        readTimeStack.addArrangedSubview(timeImageView)
        addSubview(readTimeStack)
        
        let views: [String: Any] = [
            "articleImageView": articleImageView,
            "creatorIconImageView": creatorIconImageView,
            "subjectStack": subjectStack,
            "articleAddTimeLabel": articleAddTimeLabel,
            "viewCountStack": viewCountStack,
            "clapCountStack": clapCountStack,
            "readTimeStack": readTimeStack,
            "seperatorView": seperatorView
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[articleImageView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[articleImageView(175)]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[creatorIconImageView(36)]-4-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[articleImageView]-4-[creatorIconImageView(36)]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[articleImageView]-4-[subjectStack]-[seperatorView(0.7)]-32-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-44-[subjectStack]-4-[creatorIconImageView]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[articleImageView]-[articleAddTimeLabel]", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[articleAddTimeLabel]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[seperatorView]|", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewCountStack(15)]-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[clapCountStack(15)]-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[viewCountStack]-[clapCountStack]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[readTimeStack(15)]-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[readTimeStack]-|", options: [], metrics: nil, views: views))
        
        addConstraint(NSLayoutConstraint(item: clapImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: viewImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: timeImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
