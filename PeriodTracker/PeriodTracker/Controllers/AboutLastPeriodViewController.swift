//
//  AboutLastPeriodViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class AboutLastPeriodViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    var delegate: CalendarDateSelector!

    @IBOutlet weak var periodImageView: UIImageView!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var aboutTimesPicker: UIPickerView!
    
    @IBAction func okClicked(_ sender: Any) {
        
        let index = aboutTimesPicker.selectedRow(inComponent: 0)
        let calendar = Calendar(identifier: .persian)
        let interval  = calendar.date(byAdding: .weekOfYear, value: -index, to: calendar.startOfDay(for: Date()))?.timeIntervalSince1970
        
        delegate.selectedDate(interval: interval!)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private let min = 1 , max = 10
    
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
        
        label?.text = "~\(row + 1) هفته پیش"
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
        
        aboutTimesPicker.delegate = self
        aboutTimesPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
