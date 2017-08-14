//
//  LastPeriodViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/20/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class BuyViewController: UIViewController , UITextViewDelegate {
    
    @IBOutlet weak var periodImageView: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change icon tint color and set image & circle arround icon
        periodImageView.image = UIImage(named: "smiling")?.withRenderingMode(.alwaysTemplate)
        periodImageView.tintColor = UIColor.uicolorFromHex(rgbValue: 0x157e68)
        
        periodImageView.backgroundColor = UIColor.white
        periodImageView.layer.borderWidth = 8
        periodImageView.layer.masksToBounds = false
        periodImageView.layer.borderColor = UIColor.uicolorFromHex(rgbValue: 0x157e68).cgColor
        periodImageView.layer.cornerRadius = periodImageView.frame.height / 2
        periodImageView.clipsToBounds = true
        
        initQuestion()
    }
    
    func initQuestion()  {
        // Init attribute text
        let text = "آیا برای فعالسازیی برنامه کدی در دست دارید؟"
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        // Set font for all text
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSans(FaNum)", size: 22)!, range: NSRange(location: 0, length: text.characters.count))
        
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.uicolorFromHex(rgbValue: 0x4C4C4C) , range: NSRange(location: 0, length: text.characters.count))
        
        // Center the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: text.characters.count))
        
        
        questionTextView.attributedText = attributeString
        questionTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let ce = ""
        return false
    }
    
    @IBAction func forgotCodeTapped(_ sender: Any) {
        
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
    
    @IBAction func noButtonClicked(_ sender: Any) {
        
        showModal(modalObject: Modal(title: "خرید با کارت اعتباری", desc: "برای خرید برنامه ایمیل خود را در ورودی زیر وارد کنید و دکمه خرید را بزنید، سپس به درگاه بانکی منتقل خواهید شد و بعد از پرداخت میتوانید از برنامه استفاده کنید", image: UIImage(named: "modal-buy"), firstTextFieldHint: "ایمیل شما", secondTextFieldHint: "کد", leftButtonTitle: "خرید", rightButtonTitle: "بیخیال", onLeftTapped: { (modal) in
            
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
                        Utility.openLinkInSafari(link: "\(Config.WEB_DOMAIN)pay/\(licenseId)")
                    }
                }
            })
            
        }, onRightTapped: { (modal) in
            modal.dismiss(animated: false, completion: nil)
        }, type: .oneTextField))
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
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
                    // Open app
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
                    modal.present(vc!, animated: true, completion: nil)
                }
            })
            
        }, onRightTapped: { (modal) in
            modal.dismiss(animated: false, completion: nil)
        }, type: .twoTextField))
    }
    
}
