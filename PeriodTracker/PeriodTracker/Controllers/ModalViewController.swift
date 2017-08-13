//
//  ModalViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/13/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    
    var modalObject: Modal! {
        didSet {
            titleLabel.text = modalObject.title
            descLabel.text = modalObject.desc
            if let image = modalObject.image {
                iconImageView.image = image
            }
            
            if let leftButtonTitle = modalObject.leftButtonTitle {
                leftActionButton.setTitle(leftButtonTitle, for: .normal)
            }
            
            if let rightButtonTitle = modalObject.rightButtonTitle {
                rightActionButton.setTitle(rightButtonTitle, for: .normal)
            }
        }
    }
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF2F2F2)
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "modal-alert")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSansFaNum-Bold", size: 17)
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x36454a)
        label.textAlignment = .center
        label.text = "عنوان پیغام"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IRANSans(FaNum)", size: 11)
        label.textAlignment = .center
        label.textColor = UIColor.uicolorFromHex(rgbValue: 0x7c7c7c)
        label.numberOfLines = 4
        label.text = "توضیحات پیام شامل توضیحاتی که به کاربر داده خواهد شد تا انتخاب کند."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let firstTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "IRANSans(FaNum)", size: 12)
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xd4d4d4).cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "ایمیل شما"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let secondTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "IRANSans(FaNum)", size: 12)
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xd4d4d4).cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "کد شما"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let leftActionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "IRANSansFaNum-Bold", size: 16)!
        button.setTitle("باشه", for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x36454a), for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x6d8c96), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let rightActionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "IRANSans(FaNum)", size: 16)!
        button.setTitle("خیر", for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xFF0000), for: .normal)
        button.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xD70000), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loadingActivityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorView.startAnimating()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    let indicatorHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        view.layer.cornerRadius = 10
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.view.isOpaque = false
        
        setupViews()
        setupViewActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        popupModal()
    }
    
    func popupModal() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func setupViewActions() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissModal)))
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doNothing)))
        
        self.leftActionButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        self.rightActionButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func leftButtonTapped() {
        if let onLeftTapped = modalObject.onLeftTapped , !lockUI {
            onLeftTapped(self)
        }
    }
    
    func rightButtonTapped() {
        if let onRightTapped = modalObject.onRightTapped , !lockUI {
            onRightTapped(self)
        }
    }
    
    func dismissModal() {
        dismiss(animated: false, completion: nil)
    }
    
    func setupViews() {
        
        var modalHeight = 300
        
        self.textFieldsStackView.addArrangedSubview(firstTextField)
        self.buttonsStack.addArrangedSubview(leftActionButton)
        self.buttonsStack.addArrangedSubview(rightActionButton)
        self.indicatorHolderView.addSubview(loadingActivityIndicatorView)
        self.backgroundView.addSubview(buttonsStack)
        self.backgroundView.addSubview(iconImageView)
        self.backgroundView.addSubview(titleLabel)
        self.backgroundView.addSubview(descLabel)
        self.view.addSubview(backgroundView)
        
        if modalObject.type != .normal {
            self.backgroundView.addSubview(textFieldsStackView)
            if modalObject.type == .twoTextField {
                self.textFieldsStackView.addArrangedSubview(secondTextField)
            } else {
                modalHeight = 270
            }
        } else {
            modalHeight = 240
        }
        
        self.backgroundView.addSubview(indicatorHolderView)
        
        var allConsraint: [NSLayoutConstraint] = []
        
        let views: [String : Any] = [
            "superview": self.view,
            "backgroundView": backgroundView,
            "buttonsStack": buttonsStack,
            "iconImageView": iconImageView,
            "titleLabel": titleLabel,
            "descLabel": descLabel,
            "textFieldsStackView": textFieldsStackView,
            "indicatorHolderView": indicatorHolderView
        ]
        
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backgroundView]-10-|", options: [.alignAllCenterY], metrics: nil, views: views)
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[backgroundView(\(modalHeight))]-10-|", options: [], metrics: nil, views: views)
        
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[buttonsStack(40)]-2-|", options: [], metrics: nil, views: views)
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[buttonsStack]-20-|", options: [], metrics: nil, views: views)
        
        allConsraint.append(NSLayoutConstraint(item: self.rightActionButton, attribute: .width, relatedBy: .equal, toItem: self.leftActionButton, attribute: .width, multiplier: 1, constant: 0))
        
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[iconImageView(70)]", options: [], metrics: nil, views: views)
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "H:[iconImageView(70)]", options: [], metrics: nil, views: views)
        
        allConsraint.append(NSLayoutConstraint(item: self.iconImageView, attribute: .centerX, relatedBy: .equal, toItem: self.backgroundView, attribute: .centerX, multiplier: 1, constant: 0))
        
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[iconImageView]-4-[titleLabel]", options: [], metrics: nil, views: views)
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", options: [], metrics: nil, views: views)
        
        allConsraint.append(NSLayoutConstraint(item: self.titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.backgroundView, attribute: .centerX, multiplier: 1, constant: 0))
        
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel]-4-[descLabel]", options: [], metrics: nil, views: views)
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[descLabel]-|", options: [], metrics: nil, views: views)
        
        allConsraint.append(NSLayoutConstraint(item: self.descLabel, attribute: .centerX, relatedBy: .equal, toItem: self.backgroundView, attribute: .centerX, multiplier: 1, constant: 0))
        
        if modalObject.type != .normal {
            allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "H:[textFieldsStackView(250)]", options: [], metrics: nil, views: views)
            
            allConsraint.append(NSLayoutConstraint(item: self.textFieldsStackView, attribute: .centerX, relatedBy: .equal, toItem: self.backgroundView, attribute: .centerX, multiplier: 1, constant: 0))
        
            var textFieldStackHeight = 60
            if modalObject.type == .oneTextField {
                textFieldStackHeight = 30
            } else {
                allConsraint.append(NSLayoutConstraint(item: self.firstTextField, attribute: .height, relatedBy: .equal, toItem: self.secondTextField, attribute: .height, multiplier: 1, constant: 0))
            }
            
            allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[descLabel]-4-[textFieldsStackView(\(textFieldStackHeight))]-4-[buttonsStack]", options: [], metrics: nil, views: views)
        }
        
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "V:[indicatorHolderView(100)]", options: [], metrics: nil, views: views)
        allConsraint += NSLayoutConstraint.constraints(withVisualFormat: "H:[indicatorHolderView(100)]", options: [], metrics: nil, views: views)
        
        allConsraint.append(NSLayoutConstraint(item: self.indicatorHolderView, attribute: .centerX, relatedBy: .equal, toItem: self.backgroundView, attribute: .centerX, multiplier: 1, constant: 0))
        allConsraint.append(NSLayoutConstraint(item: self.indicatorHolderView, attribute: .centerY, relatedBy: .equal, toItem: self.backgroundView, attribute: .centerY, multiplier: 1, constant: 0))
        
        allConsraint.append(NSLayoutConstraint(item: self.loadingActivityIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.backgroundView, attribute: .centerX, multiplier: 1, constant: 0))
        allConsraint.append(NSLayoutConstraint(item: self.loadingActivityIndicatorView, attribute: .centerY, relatedBy: .equal, toItem: self.backgroundView, attribute: .centerY, multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activate(allConsraint)
    }
    
    var lockUI = false
    
    func startLoading() {
        lockUI = true
        indicatorHolderView.isHidden = false
    }
    
    func stopLoading() {
        lockUI = false
        indicatorHolderView.isHidden = true
    }
    
    func doNothing() {
        
    }

}
