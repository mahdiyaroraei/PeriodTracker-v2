//
//  PricingCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/19/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PricingCollectionViewCell: UICollectionViewCell {
    
    var pricing: Pricing! {
        didSet{
            switch pricing.type {
            case .oneMonth:
                iconImageView.image = UIImage(named: "1-month")
                pricingLabel.attributedText = createAttribiuteText(text: "۸(هزار تومان)/ماه", rangeOffset: -1)
                break
            case .threeMonth:
                iconImageView.image = UIImage(named: "3-month")
                pricingLabel.attributedText = createAttribiuteText(text: "۶(هزار تومان)/ماه", rangeOffset: -1)
                break
            case .twelveMonth:
                iconImageView.image = UIImage(named: "12-month")
                pricingLabel.attributedText = createAttribiuteText(text: "۵.۶(هزار تومان)/ماه", rangeOffset: 1)
                break
            default:
                break
            }
            
            titleLabel.text = pricing.title!
        }
    }
    
    var viewController: UIViewController?
    
    func createAttribiuteText(text: String , rangeOffset: Int) -> NSMutableAttributedString {
        // Init attribute text
        let text = text
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        // Set font for all text
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Bold", size: 35)!, range: NSRange(location: 0, length: text.characters.count))
        
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: text.characters.count))
        
        // Center the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: text.characters.count))
        
        // Range of part of text that should be attribute effect on it
        let range = NSRange(location: 2 + rangeOffset, length: 12)
        
        // Color & Font
        attributeString.addAttribute(NSFontAttributeName , value: UIFont(name: "IRANSans(FaNum)", size: 13)!, range: range)
        
        attributeString.addAttribute(NSFontAttributeName , value: UIFont(name: "IRANSansFaNum-Medium", size: 15)!, range: NSRange(location: 14 + rangeOffset, length: 4))
        
        return attributeString
    }
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "1-month")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF2F5F6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "IRANSansFaNum-Bold", size: 21)!
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x00dda9)
        label.text = "اشتراک ۱ ماهه"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pricingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        // Init attribute text
        let text = "۱۵(هزار تومان)/ماه"
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        // Set font for all text
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Bold", size: 35)!, range: NSRange(location: 0, length: text.characters.count))
        
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: text.characters.count))
        
        // Center the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: text.characters.count))
        
        // Range of part of text that should be attribute effect on it
        let range = NSRange(location: 2, length: 12)
        
        // Color & Font
        attributeString.addAttribute(NSFontAttributeName , value: UIFont(name: "IRANSans(FaNum)", size: 13)!, range: range)
        
        attributeString.addAttribute(NSFontAttributeName , value: UIFont(name: "IRANSansFaNum-Medium", size: 15)!, range: NSRange(location: 14, length: 4))
        
        label.attributedText = attributeString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x00dda9), for: .normal)
        button.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0x00dda9).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "IRANSansFaNum-Medium", size: 19)
        button.setTitle("انتخاب", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        self.cardView.addSubview(iconImageView)
        self.cardView.addSubview(seperatorView)
        self.cardView.addSubview(titleLabel)
        self.cardView.addSubview(selectButton)
        self.cardView.addSubview(pricingLabel)
        self.addSubview(cardView)
        
        let views: [String: Any] = [
            "cardView": cardView,
            "iconImageView": iconImageView,
            "seperatorView": seperatorView,
            "titleLabel": titleLabel,
            "pricingLabel": pricingLabel,
            "selectButton": selectButton
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cardView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cardView]|", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[iconImageView(85)]-17-[seperatorView(1)]-[titleLabel]-20-[pricingLabel]", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[iconImageView(72)]", options: [], metrics: nil, views: views))
        addConstraint(NSLayoutConstraint(item: self.iconImageView, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[seperatorView(80)]", options: [], metrics: nil, views: views))
        addConstraint(NSLayoutConstraint(item: self.seperatorView, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: self.pricingLabel, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[selectButton(40)]-16-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[selectButton(100)]", options: [], metrics: nil, views: views))
        addConstraint(NSLayoutConstraint(item: self.selectButton, attribute: .centerX, relatedBy: .equal, toItem: self.cardView, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupViews()
        
        selectButton.addTarget(self, action: #selector(selectPrice), for: .touchUpInside)
    }
    
    func selectPrice() {
        
        var subscribe = ""
        
        switch pricing.type {
        case .oneMonth:
            subscribe = "1-month"
            break
        case .threeMonth:
            subscribe = "3-month"
            break
        case .twelveMonth:
            subscribe = "12-month"
            break
        default:
            break
        }
        
        
        self.viewController!.showModal(modalObject: Modal(title: "خرید با کارت اعتباری", desc: "برای خرید برنامه ایمیل خود را در ورودی زیر وارد کنید و دکمه خرید را بزنید، سپس به درگاه بانکی منتقل خواهید شد و بعد از پرداخت میتوانید از برنامه استفاده کنید", image: UIImage(named: "modal-buy"), firstTextFieldHint: "ایمیل شما", secondTextFieldHint: "کد", leftButtonTitle: "خرید", rightButtonTitle: "بیخیال", onLeftTapped: { (modal) in
            
            guard let email = modal.firstTextField.text , Utility.isValidEmail(testStr: email) else {
                modal.firstTextField.layer.borderColor = UIColor.red.cgColor
                modal.showToast(message: "ایمیل به درستی وارد نشده است")
                return
            }
            
            let parameters = [
                "email": email,
                "app": "period_tracker"
            ]
            
            modal.startLoading()
            
            Alamofire.request("\(Config.WEB_DOMAIN)v2/buy", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    if let licenseId = JSON(data)["license_id"].int {
                        modal.stopLoading()
                        Utility.openLinkInSafari(link: "\(Config.WEB_DOMAIN)pay/\(licenseId)/\(subscribe)")
                        modal.dismissModal()
                    }
                }
            })
            
        }, onRightTapped: { (modal) in
            modal.dismiss(animated: false, completion: nil)
        }, type: .oneTextField))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
