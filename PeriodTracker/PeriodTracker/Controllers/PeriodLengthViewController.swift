//
//  PeriodLengthViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/21/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class PeriodLengthViewController: UIViewController , UITextViewDelegate{
    
    @IBOutlet weak var periodImageView: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
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
        
        // Init attribute text
        let text = questionTextView.text!
        
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
        let ce = ""
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
