//
//  LastPeriodViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/20/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class LastPeriodViewController: UIViewController , UITextViewDelegate , CalendarDateSelector{

    @IBOutlet weak var periodImageView: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
    
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
    
    func initQuestion()  {
        // Init attribute text
        let text = "آیا روز آخرین پریودیتان را به یاد دارید؟"
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        // Set font for all text
        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSans(FaNum)", size: 17)!, range: NSRange(location: 0, length: text.characters.count))
        
        // Center the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: text.characters.count))
        
        // Range of part of text that should be attribute effect on it
        let range = NSRange(location: 8, length: 15)
        
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
            let ce = ""
        return false
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        if isUserSavedData {
            try! realm.write {
                guard let setup = realm.objects(Setup.self).first else{
                    return
                }
                setup.startDate = 0
            }
            Utility.setLocalPushForEnableNotices(withCompletionHandler: nil)
            viewDidAppear(false)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutLastPeriodViewController") as! AboutLastPeriodViewController
            vc.delegate = self
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! CalendarViewController
        
        vc.isSeector = true
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    // This function created by follow CalendarDateSelector protocol
    func selectedDate(interval: Double) {
        // Check if setup exist replace and if not add new
        
        guard let setup = realm.objects(Setup.self).first else {
            let setup = Setup()
            setup.startDate = interval
            try! realm.write {
                realm.add(setup)
            }
            return
        }
        
        try! realm.write {
            setup.startDate = interval
        }
        Utility.setLocalPushForEnableNotices(withCompletionHandler: nil)
        
        // Avoid to show start period date as selected date and show today as selected
        CalendarViewController.selectedDate = Calendar.current.startOfDay(for: Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkExistDataInDatabase()
    }
    
    func checkExistDataInDatabase() {
        
        guard let setup = realm.objects(Setup.self).first else {
            // if dont setup yet ui must clear
            isUserSavedData = false
            
            periodImageView.tintColor = UIColor.red
            periodImageView.backgroundColor = UIColor.white
            initQuestion()
            
            return
        }
        
        // maybe other data is exist and only this not
        if setup.startDate == 0 {
            // if dont setup yet ui must clear
            isUserSavedData = false
            
            periodImageView.tintColor = UIColor.red
            periodImageView.backgroundColor = UIColor.white
            initQuestion()
            
            return
        }
        
        // if setup this level ui should chnage from clear
        periodImageView.tintColor = UIColor.white
        periodImageView.backgroundColor = UIColor.red
        
        let calendar = Calendar.init(identifier: .persian)
        let dateComponents = calendar.dateComponents([.year ,.month ,.day], from: Date(timeIntervalSince1970: setup.startDate))
        questionTextView.text = "تاریخ \(dateComponents.day!) / \(dateComponents.month!) / \(dateComponents.year!) به عنوان آخرین پریودی شما ثبت شده است، از این تاریخ اطمینان دارید؟"
        
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
