//
//  PeriodLengthViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/21/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class PeriodLengthViewController: UIViewController , UITextViewDelegate , PeriodLengthDelegate {
    
    @IBOutlet weak var periodImageView: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var nextButton: UIButton!
    let realm = try! Realm()
    
    var isUserSavedData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Change icon tint color and set image & circle arround icon
        periodImageView.image = UIImage(named: "smiling")?.withRenderingMode(.alwaysTemplate)
        periodImageView.tintColor = UIColor.red
        
        periodImageView.backgroundColor = UIColor.white
        periodImageView.layer.borderWidth = 8
        periodImageView.layer.masksToBounds = false
        periodImageView.layer.borderColor = UIColor.red.cgColor
        periodImageView.layer.cornerRadius = periodImageView.frame.height / 2
        periodImageView.clipsToBounds = true
        
        initQuestion()
        checkExistDataInDatabase()
    }
    
    func initQuestion() {
        
        // Init attribute text
        let text = "آیا از طول مدت آخرین پریودیتان اطلاع دارید؟"
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        // Set font for all text
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSans(FaNum)", size: 17)!, range: NSRange(location: 0, length: text.characters.count))
        
        // Center the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: text.characters.count))
        
        // Range of part of text that should be attribute effect on it
        let range = NSRange(location: 21, length: 9)
        
        // Under line
        attributeString.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        attributeString.addAttribute(NSUnderlineColorAttributeName , value: UIColor.red, range: range)
        
        // Color & Font
        attributeString.addAttribute(NSFontAttributeName , value: UIFont(name: "IRANSansFaNum-Bold", size: 17)!, range: range)
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
        
        // Define link
        attributeString.addAttribute(NSLinkAttributeName, value: "guid", range: range)
        
        questionTextView.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.red]
        questionTextView.attributedText = attributeString
        questionTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        let vc = GuideViewController()
        vc.guide = Utility.createGuideObjectFromKey(key: "periodLengthViewController")!
        present(vc, animated: true, completion: nil)
        
        return false
    }
    
    
    @IBAction func noButtonClicked(_ sender: Any) {
        // If user click no in saved data mode clear data from database and refresh UI
        if isUserSavedData {
            try! realm.write {
                guard let setup = realm.objects(Setup.self).first else{
                    return
                }
                setup.periodLength = 0
            }
            Utility.setLocalPushForEnableNotices(withCompletionHandler: nil)
            // Clear fill circle and data from UI
            checkExistDataInDatabase()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "periodLengthSelectorViewController") as! PeriodLengthSelectorViewController
            
            vc.showWorldNormalValue = true
            vc.delegate = self
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        if isUserSavedData {
            
            if !UserDefaults.standard.bool(forKey: "setup-complete") {
                showModal(modalObject: Modal(title: "اتمام راه اندازی؟", desc: "اطمینان حاصل کنید تمام مقادیر خواسته شده برنامه را داده اید تا برنامه به درستی کار کند.", image: nil, leftButtonTitle: "اتمام راه اندازی", rightButtonTitle: "بررسی دوباره", onLeftTapped: { (modal) in
                        UserDefaults.standard.set(true, forKey: "setup-complete")
                        modal.present((self.storyboard?.instantiateViewController(withIdentifier: "tabBarController"))!, animated: true, completion: nil)
                }, onRightTapped: { (modal) in
                    modal.dismissModal()
                }))
            } else {
                dismiss(animated: true, completion: nil)
            }
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "periodLengthSelectorViewController") as! PeriodLengthSelectorViewController
            
            vc.delegate = self
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    // This function created by follow PeriodLengthDelegate protocol
    func period(length: Int) {
        // Check if setup exist replace and if not add new
        
        guard let setup = realm.objects(Setup.self).first else {
            let setup = Setup()
            setup.periodLength = length
            try! realm.write {
                realm.add(setup)
            }
            return
        }
        
        try! realm.write {
            setup.periodLength = length
        }
        Utility.setLocalPushForEnableNotices(withCompletionHandler: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        (self.parent as! SetupPageViewController).pageController.currentPage = 2
        
        checkExistDataInDatabase()
    }
    
    func checkExistDataInDatabase() {
        
        nextButton.setImage(UIImage(named: "ok"), for: .normal)
        
        guard let setup = realm.objects(Setup.self).first else {
            // if dont setup yet ui must clear
            isUserSavedData = false
            
            periodImageView.tintColor = UIColor.red
            periodImageView.backgroundColor = UIColor.white
            initQuestion()
            
            return
        }
        
        // maybe other data is exist and only this not
        if setup.periodLength == 0 {
            // if dont setup yet ui must clear
            isUserSavedData = false
            
            periodImageView.tintColor = UIColor.red
            periodImageView.backgroundColor = UIColor.white
            initQuestion()
            
            return
        }
        
        nextButton.setImage(UIImage(named: "finish"), for: .normal)
        
        // if setup this level ui should chnage from clear
        periodImageView.tintColor = UIColor.white
        periodImageView.backgroundColor = UIColor.red
        
        questionTextView.text = "طول دوره پریودی شما \(setup.periodLength) روز ثبت شده است."
        
        isUserSavedData = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
