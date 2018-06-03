//
//  PeriodLengthSelectorViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/26/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class PeriodLengthSelectorViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    var delegate: PeriodLengthDelegate!
    
    @IBOutlet weak var periodImageView: UIImageView!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var aboutTimesPicker: UIPickerView!
    @IBOutlet weak var normalWorldValueLabel: UITextView!
    
    var showWorldNormalValue = false
    
    // Okay click listener
    @IBAction func okClicked(_ sender: Any) {
        
        if showWorldNormalValue {
            delegate.period(length: 7)
        }else{
            let index = aboutTimesPicker.selectedRow(inComponent: 0)
            delegate.period(length: index + 1)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private let min = 1 , max = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max - min
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        label?.text = "\(row + 1) روز"
        label?.font = UIFont(name: "IRANSansFaNum-Bold", size: 20)
        label?.textColor = UIColor.black
        label?.textAlignment = .center
        
        return label!
    }
    
    func initViews() {
        
        // Change icon tint color and set image & circle arround icon
        periodImageView.image = UIImage(named: "smiling")?.withRenderingMode(.alwaysTemplate)
        periodImageView.tintColor = UIColor.white
        
        periodImageView.backgroundColor = UIColor.clear
        periodImageView.layer.borderWidth = 8
        periodImageView.layer.masksToBounds = false
        periodImageView.layer.borderColor = UIColor.white.cgColor
        periodImageView.layer.cornerRadius = periodImageView.frame.height / 2
        periodImageView.clipsToBounds = true
        
        // circle arround ok button
        okButton.backgroundColor = UIColor.clear
        okButton.layer.borderWidth = 4
        okButton.layer.masksToBounds = false
        okButton.layer.borderColor = UIColor.white.cgColor
        okButton.layer.cornerRadius = okButton.frame.height / 2
        okButton.clipsToBounds = true
        
        if showWorldNormalValue {
            aboutTimesPicker.isHidden = true
            normalWorldValueLabel.isHidden = false
        }else{
            aboutTimesPicker.delegate = self
            aboutTimesPicker.dataSource = self
        }
        
        let attributeText = NSMutableAttributedString(attributedString: normalWorldValueLabel.attributedText)
        attributeText.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Bold", size: 19)!, range: NSRange(location: 0, length: attributeText.length))
        normalWorldValueLabel.attributedText = attributeText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

protocol PeriodLengthDelegate {
    func period(length: Int)
}
