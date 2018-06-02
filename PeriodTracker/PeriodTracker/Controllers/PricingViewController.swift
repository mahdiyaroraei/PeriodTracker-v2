//
//  PricingViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/19/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class PricingViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    let itemSpacing: CGFloat = (UIScreen.main.bounds.width - 250 - 10) / 2
    
    let pricingCollectionView: UICollectionView = {
        let itemSpacing: CGFloat = (UIScreen.main.bounds.width - 250 - 10) / 2
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsetsMake(0, itemSpacing, 0, itemSpacing)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pricing-bg")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.uicolorFromHex(rgbValue: 0xF6F6F6)
        
        self.pricingCollectionView.register(PricingCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        setupViews()
        
        setupLogin()
        
        AppDelegate.pricingViewController = self
        
    }
    
    func setupLogin() {
        
        let loginNavButton = UIButton()
        loginNavButton.setTitle("ورود" , for: .normal)
        loginNavButton.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0xdb2b42), for: .normal)
        loginNavButton.titleLabel?.textAlignment = .center
        loginNavButton.titleLabel?.font = UIFont(name: "IRANSansFaNum-Medium", size: 12)!
        loginNavButton.layer.borderWidth = 2
        loginNavButton.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0xdb2b42).cgColor
        loginNavButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
        loginNavButton.layer.cornerRadius = 4
        loginNavButton.frame = CGRect(x: 0, y: 0, width: 75, height: 25)
        
        loginNavButton.addTarget(self, action: #selector(openLoginModal), for: .touchUpInside)
        
        
        let forgotNavButton = UIButton()
        forgotNavButton.setTitle("فراموشی کد" , for: .normal)
        forgotNavButton.setTitleColor(UIColor.uicolorFromHex(rgbValue: 0x007aff), for: .normal)
        forgotNavButton.titleLabel?.textAlignment = .center
        forgotNavButton.titleLabel?.font = UIFont(name: "IRANSansFaNum-Medium", size: 12)!
        forgotNavButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
        forgotNavButton.frame = CGRect(x: 0, y: 0, width: 75, height: 25)
        
        forgotNavButton.addTarget(self, action: #selector(openForgotModal), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: loginNavButton),UIBarButtonItem(customView: forgotNavButton)]
    }
    
    func openForgotModal() {
        showModal(modalObject: Modal(title: "فراموشی کد", desc: "در صورتی که کدی که در اختیارتان قرار گرفته فراموش کرده اید ایمیل خود را در ورودی زیر وارد کنید تا کد را به ایمیل شما ارسال کنیم.", image: UIImage(named: "modal-forgot"), firstTextFieldHint: "ایمیل شما", secondTextFieldHint: "کد", leftButtonTitle: "ارسال", rightButtonTitle: "بیخیال", onLeftTapped: { (modal) in
            
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
            
            Alamofire.request("\(Config.WEB_DOMAIN)resendcode", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    modal.stopLoading()
                    if let success = JSON(data)["success"].int , success == 1 {
                        modal.showToast(message: "ایمیل ارسال شد")
                    } else {
                        modal.showToast(message: "ایمیل وارد شده صحیح نیست")
                    }
                }
            })
            
        }, onRightTapped: { (modal) in
            modal.dismiss(animated: false, completion: nil)
        }, type: .oneTextField))
    }
    
    func openLoginModal(){
        showModal(modalObject: Modal(title: "ورود با کد", desc: "کدی که در اختیارتان قرار گرفته را به همراه ایمیل خود در ورودی های زیر وارد کنید (کد های رایگان یکبار مصرف بوده و در صورت استفاده توسط کاربر دیگر منقضی خواهد شد.)", image: UIImage(named: "modal-code"), firstTextFieldHint: "ایمیل شما", secondTextFieldHint: "کد", leftButtonTitle: "ورود", rightButtonTitle: "بیخیال", onLeftTapped: { (modal) in
            
            guard let email = modal.firstTextField.text , Utility.isValidEmail(testStr: email) else {
                modal.firstTextField.layer.borderColor = UIColor.red.cgColor
                modal.showToast(message: "ایمیل به درستی وارد نشده است")
                return
            }
            
            guard let code = modal.secondTextField.text , code.characters.count == 8 else {
                modal.secondTextField.layer.borderColor = UIColor.red.cgColor
                modal.showToast(message: "کد به درستی وارد نشده است")
                return
            }
            
            let parameters = [
                "email": email,
                "code": code,
                "app": "period_tracker"
            ]
            
            modal.startLoading()
            
            
            Alamofire.request("\(Config.WEB_DOMAIN)v2/activation", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                modal.stopLoading()
                if let data = response.data {
                    guard let licenseId = JSON(data)["license_id"].int else {
                        modal.showToast(message: "اطلاعات صحیح نیست")
                        return
                    }
                    
                    guard let userId = JSON(data)["user_id"].int else {
                        modal.showToast(message: "اطلاعات صحیح نیست")
                        return
                    }
                    
                    guard let email = JSON(data)["email"].string else {
                        modal.showToast(message: "اطلاعات صحیح نیست")
                        return
                    }
                    
                    let realm = try! Realm()
                    if let user = realm.objects(User.self).last {
                        try! realm.write {
                            user.email = email
                            user.user_id = userId
                            user.license_id = licenseId
                        }
                    } else {
                        
                        try! realm.write {
                            let user = User()
                            user.email = email
                            user.user_id = userId
                            user.license_id = licenseId
                            
                            realm.add(user)
                        }
                        
                    }
                    
//                    ArticleViewController.subscribe = true
                    
                    modal.showModal(modalObject: Modal(title: "با موفقیت وارد شدید", desc: "اشتراک شما با ایمیل \(email) با موفقیت فعال شد.", image: UIImage(named: "modal-code"), leftButtonTitle: "باشه", rightButtonTitle: "", onLeftTapped: { (modal) in
                        modal.dismissModal()
                    }, onRightTapped: { (modal) in
                        
                    }))
                }
            })
            
        }, onRightTapped: { (modal) in
            modal.dismiss(animated: false, completion: nil)
        }, type: .twoTextField))
    }
    
    var currentPage = 0
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(250 + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.pricingCollectionView.contentSize.width  )
        var newPage: Float = Float(currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? currentPage + 1 : currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
    
    let pricing = [
        Pricing(title: "اشتراک ۱ ماهه", price: 8, type: .oneMonth),
        Pricing(title: "اشتراک ۳ ماهه", price: 18, type: .threeMonth),
        Pricing(title: "اشتراک ۱۲ ماهه", price: 68, type: .twelveMonth)
    ]
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pricing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.pricingCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PricingCollectionViewCell
        cell.pricing = pricing[indexPath.item]
        cell.viewController = self
        return cell
    }
    
    func setupViews() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(pricingCollectionView)
        
        self.pricingCollectionView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        self.pricingCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.pricingCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.pricingCollectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        
        self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.backgroundImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backgroundImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.pricingCollectionView.delegate = self
        self.pricingCollectionView.dataSource = self
    }

}
