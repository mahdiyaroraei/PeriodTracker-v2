//
//  MeanPeriodVC.swift
//  PeriodTracker
//
//  Created by Mostafa Oraei on 4/21/1396 AP.
//  Copyright © 1396 Mahdiar . All rights reserved.
//

import UIKit

class MeanPeriodVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var meanPeriodPicker: UIPickerView!
    
    let meanPeriod = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meanPeriodPicker.delegate = self
        meanPeriodPicker.dataSource = self

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return meanPeriod.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return meanPeriod[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        
        attributedString = NSAttributedString(string: meanPeriod[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        
        return attributedString
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

}
