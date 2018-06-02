//
//  ArticleCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/6/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire

class ArticleCollectionViewCell: UICollectionViewCell {
    
    var article: Article!{
        didSet {
            subjectLabel.text = article.title
            articleDescriptionLabel.text = article.desc!
            viewCountLabel.text = "\(article.view!.forrmated)"
            clapCountLabel.text = "\(article.clap!.forrmated)"
            accessImageView.image = UIImage(named: article.access!)
            
            if let readTime = article.article_read_time {
                readTimeLabel.text = "زمان مطالعه: حدود \(readTime) دقیقه"
            } else {
                readTimeLabel.text = "حدود ۶ دقیقه"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran") //Current time zone
            let date = dateFormatter.date(from: article.addedtime!) //according to date format your date string
            
            articleAddTimeLabel.text = Utility.timeAgoSince(date!)
            
            if let imageURL = article.image {
                articleImageView.downloadedFrom(link: imageURL, contentMode: .scaleAspectFill, complition: { (loaded) in
                    self.articleImageLoader.stopAnimating()
                })
            }
        }
    }
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xf2f2f2)
        imageView.contentMode = .scaleAspectFill
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
        imageView.isUserInteractionEnabled = true
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
    
    let clappingCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSansFaNum-Medium", size: 30)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.isHidden = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clapCountStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
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
    
    // access
    let accessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true // TODO Subscribe
        imageView.image = UIImage(named: "free")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        addSubview(articleImageView)
        addSubview(articleImageLoader)
        addSubview(creatorIconImageView)
        subjectStack.addArrangedSubview(subjectLabel)
        subjectStack.addArrangedSubview(articleDescriptionLabel)
        addSubview(subjectStack)
        addSubview(articleAddTimeLabel)
        addSubview(accessImageView)
        addSubview(seperatorView)
        addSubview(clappingCountLabel)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(clapping(gesture:)))
        clapCountStack.addGestureRecognizer(longGesture)
        clapCountStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clappingOnce)))
        
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
            "articleImageLoader": articleImageLoader,
            "creatorIconImageView": creatorIconImageView,
            "subjectStack": subjectStack,
            "articleAddTimeLabel": articleAddTimeLabel,
            "viewCountStack": viewCountStack,
            "clapCountStack": clapCountStack,
            "readTimeStack": readTimeStack,
            "seperatorView": seperatorView,
            "clappingCountLabel": clappingCountLabel,
            "accessImageView": accessImageView
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[articleImageView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[articleImageView]", options: [], metrics: nil, views: views))
        
        addConstraint(NSLayoutConstraint(item: self.articleImageLoader, attribute: .centerX, relatedBy: .equal, toItem: self.articleImageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.articleImageLoader, attribute: .centerY, relatedBy: .equal, toItem: self.articleImageView, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[creatorIconImageView(36)]-4-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[articleImageView]-4-[creatorIconImageView(36)]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[articleImageView]-4-[subjectStack]-[seperatorView(0.7)]-37-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-44-[subjectStack]-4-[creatorIconImageView]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[articleImageView]-[articleAddTimeLabel]", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[articleAddTimeLabel]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[articleAddTimeLabel]-2-[accessImageView(20)]", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[accessImageView(40)]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[seperatorView]|", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewCountStack(20)]-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[clapCountStack(20)]-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[viewCountStack]-[clapCountStack]", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[readTimeStack(15)]-10-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[readTimeStack]-|", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[clappingCountLabel]-40-[clapCountStack]", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[clappingCountLabel]", options: [], metrics: nil, views: views))
        
        addConstraint(NSLayoutConstraint(item: clapImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: viewImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: timeImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        
        addConstraint(NSLayoutConstraint(item: self.articleImageView, attribute: .height, relatedBy: .equal, toItem: self.articleImageView, attribute: .width, multiplier: 0.55, constant: 0))
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.accessImageView.image = nil
        self.articleImageView.image = nil
        
    }
    
    var clappingCount = 0
    var timer: Timer?
    
    func clapping(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            labelAnimationStart()
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // Update clap count
            Alamofire.request("\(Config.WEB_DOMAIN)clapping/\(article.id!)/\(clappingCount)")
            article.increaseClap(count: clappingCount)
            clappingCount = 0
            labelAnimationStop()
            timer?.invalidate()
            timer = nil
        }
    }
    
    func clappingOnce() {
        // Update clap count
        Alamofire.request("\(Config.WEB_DOMAIN)clapping/\(article.id!)/\(1)")
        article.increaseClap(count: 1)
        clapCountLabel.text = "\(article.clap!)"
        vibrateWithHaptic()
    }
    
    func handleTimer(timer: Timer) {
        clappingCount += 1
        clapCountLabel.text = "\(article.clap + clappingCount)"
        clappingCountLabel.text = "\(article.clap + clappingCount)"
        vibrateWithHaptic()
    }
    
    var labelBeforAnimFrame: CGRect?
    func labelAnimationStart() {
        clappingCountLabel.isHidden = false
    }
    
    func labelAnimationStop() {
        clappingCountLabel.isHidden = true
    }
    
    private func vibrateWithHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
