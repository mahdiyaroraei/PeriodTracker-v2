//
//  MeanCycleVC.swift
//  PeriodTracker
//
//  Created by Mostafa Oraei on 4/21/1396 AP.
//  Copyright © 1396 Mahdiar . All rights reserved.
//

import UIKit

class MeanCycleVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var meanCyclePicker: UIPickerView!
    
    let meanCycle = ["16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        meanCyclePicker.delegate = self
        meanCyclePicker.dataSource = self
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return meanCycle.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return meanCycle[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        

            attributedString = NSAttributedString(string: meanCycle[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        
        return attributedString
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

}
