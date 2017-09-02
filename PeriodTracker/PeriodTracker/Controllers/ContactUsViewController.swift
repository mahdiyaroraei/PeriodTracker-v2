//
//  ContactUsViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/14/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    let mapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "company-location")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "support-card-bg")
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "period_tracker")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Period Tracker Inc."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let companyAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSans(FaNum)", size: 11)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x7c7c7c)
        label.text = "آدرس دفتر: مشهد، بین امامت ۳۷ و ۳۹، پلاک ۴۶۹؛ تلفن: ۰۵۱۳۶۰۸۸۶۵۶"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let socialNetworksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let instagramButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "support-instagram")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = UIColor.uicolorFromHex(rgbValue: 0xcd6e76)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let telegramButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "support-telegram")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = UIColor.uicolorFromHex(rgbValue: 0xcd6e76)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let twitterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "support-twitter")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = UIColor.uicolorFromHex(rgbValue: 0xcd6e76)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let webButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "support-web")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = UIColor.uicolorFromHex(rgbValue: 0xcd6e76)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let supportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "support-headset")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.setTitle("تماس با پشتیبانی", for: .normal)
        button.titleLabel?.font = UIFont(name: "IRANSansFaNum-Bold", size: 13)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x948f94), for: .highlighted)
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 2)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        button.semanticContentAttribute = .forceRightToLeft
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0x6e272e)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewActions()
    }
    
    func setupViewActions() {
        instagramButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        telegramButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        twitterButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        webButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        supportButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    }
    
    func buttonTapped(sender: UIButton) {
        var link: String = ""
        if sender == instagramButton {
            link = "https://instagram.com/royanapp.ir"
        } else if sender == telegramButton {
            link = "https://telegram.me/RoyanApp_ir"
        } else if sender == twitterButton {
            link = "https://twitter.com/irperiodtracker"
        } else if sender == webButton {
            link = "http://royanapp.ir"
        } else if sender == supportButton {
            link = "https://telegram.me/Royan_support"
        }
        
        Utility.openLinkInSafari(link: link)
    }
    
    func setupViews() {
        self.socialNetworksStackView.addArrangedSubview(telegramButton)
        self.socialNetworksStackView.addArrangedSubview(instagramButton)
        self.socialNetworksStackView.addArrangedSubview(twitterButton)
        self.socialNetworksStackView.addArrangedSubview(webButton)
        self.cardView.addSubview(cardBackgroundImageView)
        self.cardView.addSubview(appIconImageView)
        self.cardView.addSubview(companyNameLabel)
        self.cardView.addSubview(companyAddressLabel)
        self.cardView.addSubview(socialNetworksStackView)
        self.cardView.addSubview(supportButton)
        self.view.addSubview(mapImageView)
        self.view.addSubview(cardView)
        
        var allConstraint: [NSLayoutConstraint] = []
        let views = [
            "topLayoutGuide": topLayoutGuide,
            "mapImageView": mapImageView,
            "cardView": cardView,
            "cardBackgroundImageView": cardBackgroundImageView,
            "appIconImageView": appIconImageView,
            "companyNameLabel": companyNameLabel,
            "companyAddressLabel": companyAddressLabel,
            "socialNetworksStackView": socialNetworksStackView,
            "supportButton": supportButton
        ] as [String : Any]
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapImageView]|", options: [], metrics: nil, views: views)
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapImageView]|", options: [], metrics: nil, views: views)
        
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[topLayoutGuide]-70-[cardView(225)]", options: [], metrics: nil, views: views)
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[cardView]-20-|", options: [], metrics: nil, views: views)
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "V:|[cardBackgroundImageView]", options: [], metrics: nil, views: views)
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|[cardBackgroundImageView]|", options: [], metrics: nil, views: views)
        
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[appIconImageView(70)]", options: [], metrics: nil, views: views)
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "H:[appIconImageView(70)]", options: [], metrics: nil, views: views)
        allConstraint.append(NSLayoutConstraint(item: self.appIconImageView, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))
        allConstraint.append(NSLayoutConstraint(item: self.appIconImageView, attribute: .centerY, relatedBy: .equal, toItem: self.cardView, attribute: .top, multiplier: 1, constant: -10))
        
        allConstraint.append(NSLayoutConstraint(item: self.companyNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[companyNameLabel]", options: [], metrics: nil, views: views)
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[companyNameLabel]-4-[companyAddressLabel]", options: [], metrics: nil, views: views)
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[companyAddressLabel]-|", options: [], metrics: nil, views: views)
        
        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[socialNetworksStackView(25)]-20-|", options: [], metrics: nil, views: views)
        allConstraint.append(NSLayoutConstraint(item: self.socialNetworksStackView, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))

        
        allConstraint += NSLayoutConstraint.constraints(withVisualFormat: "H:[supportButton(140)]", options: [], metrics: nil, views: views)
        allConstraint.append(NSLayoutConstraint(item: self.supportButton, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))
        allConstraint.append(NSLayoutConstraint(item: self.supportButton, attribute: .centerY, relatedBy: .equal, toItem: self.cardView, attribute: .centerY, multiplier: 1, constant: 20))

        
        
        NSLayoutConstraint.activate(allConstraint)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardView.dropShadow()
    }

}
