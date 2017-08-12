//
//  GuideViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/12/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    var guide: Guide! {
        didSet {
            titleLabel.text = guide.fa_key
            contentTextView.text = guide.content
        }
    }
    
    let navItemView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF6F6F6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x76858F)
        label.font = UIFont(name: "IRANSansFaNum-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("بستن", for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x7BA013), for: .normal)
        button.titleLabel?.font = UIFont(name: "IRANSansFaNum-Bold", size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textAlignment = .right
        textView.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xfafafb)
        textView.font = UIFont(name: "IRANSans(FaNum)", size: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    
    func setupViews() {
        self.navItemView.addSubview(titleLabel)
        self.navItemView.addSubview(closeButton)
        self.view.addSubview(navItemView)
        
        self.view.addSubview(contentTextView)
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        var allConstraints = [NSLayoutConstraint]()
        let views: [String: Any] = [
            "topLayoutGuide": topLayoutGuide,
            "navItemView": navItemView,
            "titleLabel": titleLabel,
            "closeLabel": closeButton,
            "contentTextView": contentTextView
        ]
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[topLayoutGuide][navItemView(65)]", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[topLayoutGuide][navItemView]|", options: [], metrics: nil, views: views)
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[titleLabel]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[titleLabel]|", options: [], metrics: nil, views: views)
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[closeLabel]", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[closeLabel]|", options: [], metrics: nil, views: views)
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[navItemView][contentTextView]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentTextView]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        closeButton.addTarget(self, action: #selector(dismissViewController(sender:)), for: .touchUpInside)
    }
    
    func dismissViewController(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
