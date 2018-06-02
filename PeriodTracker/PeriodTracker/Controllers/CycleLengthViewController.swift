//
//  CycleLengthViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/21/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class CycleLengthViewController: UIViewController , UITextViewDelegate , PeriodLengthDelegate{
    
    private let color = Utility.uicolorFromHex(rgbValue: 0x137E68)
    
    @IBOutlet weak var periodImageView: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var nextButton: UIButton!
    let realm = try! Realm()
    
    var isUserSavedData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change icon tint color and set image & circle arround icon
        periodImageView.image = UIImage(named: "small-calendar")?.withRenderingMode(.alwaysTemplate)
        periodImageView.tintColor = color
        
        periodImageView.backgroundColor = UIColor.white
        periodImageView.layer.borderWidth = 8
        periodImageView.layer.masksToBounds = false
        periodImageView.layer.borderColor = color.cgColor
        periodImageView.layer.cornerRadius = periodImageView.frame.height / 2
        periodImageView.clipsToBounds = true
        
        initQuestion()
        checkExistDataInDatabase()
    }
    
    func initQuestion()  {
        
        // Init attribute text
        let text = "آیا از طول آخرین دوره ای که برایتان رخ داده اطلاع دارید؟"
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        // Set font for all text
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSans(FaNum)", size: 17)!, range: NSRange(location: 0, length: text.characters.count))
        
        // Center the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: text.characters.count))
        
        // Range of part of text that should be attribute effect on it
        let range = NSRange(location: 17, length: 4)
        
        // Under line
        attributeString.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        attributeString.addAttribute(NSUnderlineColorAttributeName , value: color, range: range)
        
        // Color & Font
        attributeString.addAttribute(NSFontAttributeName , value: UIFont(name: "IRANSansFaNum-Bold", size: 17)!, range: range)
        attributeString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        // Define link
        attributeString.addAttribute(NSLinkAttributeName, value: "guid", range: range)
        
        questionTextView.linkTextAttributes = [NSForegroundColorAttributeName:color]
        questionTextView.attributedText = attributeString
        questionTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        let vc = GuideViewController()
        vc.guide = Utility.createGuideObjectFromKey(key: "cycleLengthViewController")!
        present(vc, animated: true, completion: nil)
        
        return false
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        if isUserSavedData {
            try! realm.write {
                guard let setup = realm.objects(Setup.self).first else{
                    return
                }
                setup.cycleLength = 0
            }
            Utility.setLocalPushForEnableNotices(withCompletionHandler: nil)
            // Clear fill circle and data from UI
            checkExistDataInDatabase()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "cycleLengthSelectorViewController") as! AboutCycleLengthViewController
            
            vc.showWorldNormalValue = true
            vc.delegate = self
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        if isUserSavedData {
            let pageViewController: SetupPageViewController = self.parent as! SetupPageViewController
            pageViewController.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier: "periodLengthViewController"))!], direction: .forward, animated: true, completion: nil)
            pageViewController.pageController.currentPage = 2
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "cycleLengthSelectorViewController") as! AboutCycleLengthViewController
            
            vc.delegate = self
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    // This function created by follow PeriodLengthDelegate protocol
    func period(length: Int) {
        // Check if setup exist replace and if not add new
        
        guard let setup = realm.objects(Setup.self).first else {
            let setup = Setup()
            setup.cycleLength = length
            try! realm.write {
                realm.add(setup)
            }
            return
        }
        
        try! realm.write {
            setup.cycleLength = length
        }
        Utility.setLocalPushForEnableNotices(withCompletionHandler: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        (self.parent as! SetupPageViewController).pageController.currentPage = 1
        
        checkExistDataInDatabase()
    }
    
    func checkExistDataInDatabase() {
        
        nextButton.setImage(UIImage(named: "ok"), for: .normal)
        
        guard let setup = realm.objects(Setup.self).first else {
            // if dont setup yet ui must clear
            isUserSavedData = false
            
            periodImageView.tintColor = color
            periodImageView.backgroundColor = UIColor.white
            initQuestion()
            
            return
        }
        
        // maybe other data is exist and only this not
        if setup.cycleLength == 0 {
            // if dont setup yet ui must clear
            isUserSavedData = false
            
            periodImageView.tintColor = color
            periodImageView.backgroundColor = UIColor.white
            initQuestion()
            
            return
        }
        
        nextButton.setImage(UIImage(named: "next"), for: .normal)
        
        // if setup this level ui should chnage from clear
        periodImageView.tintColor = UIColor.white
        periodImageView.backgroundColor = color
        
        questionTextView.text = "شما طول مدت \(setup.cycleLength) روز را برای طول دوره انتخاب کردید. از این مقدار اطمینان دارید؟"
        
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
