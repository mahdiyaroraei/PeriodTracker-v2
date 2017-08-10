//
//  DayLogViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/30/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class DayLogViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,
SelectCellDelegate , SelectMoodDelegate{

    @IBOutlet weak var moodValuesCollectionView: UICollectionView!
    @IBOutlet weak var moodCollectionView: UICollectionView!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var moodInfoButton: UIButton!
    
    @IBOutlet weak var valueTextField: UITextField!
    let calendar = Calendar(identifier: .persian)
    
    public static var selectedName: String!
    
    // start of day and month
    let nowDate = Calendar.current.startOfDay(for: Date())
    
    // After select item viewDidLayoutSubviews called again for avoid scroll use this
    var scrolledFirst = false
    
    // Enable moods store to this object
    var moods: Results<Mood>!
    
    // Value type of selected mood get from database store here
    var valueTypes: [String] = []
    var selectedMood: Mood!

    let realm = try! Realm()
    
    var isPregnant = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getEnabledMoodFromDatabase()
        
        todayLabel.text = "\(String(describing: Calendar(identifier: .persian).dateComponents([.day], from: nowDate).day!))"

        self.weekCollectionView.dataSource = self
        self.weekCollectionView.delegate = self
        self.moodCollectionView.dataSource = self
        self.moodCollectionView.delegate = self
        self.moodValuesCollectionView.dataSource = self
        self.moodValuesCollectionView.delegate = self
        
        self.moodValuesCollectionView.isScrollEnabled = false
        
        self.weekCollectionView.showsHorizontalScrollIndicator = false
        self.moodCollectionView.showsHorizontalScrollIndicator = false
        
        // For scrolling like a page and not stay at middle of item
        self.weekCollectionView.isPagingEnabled = true
        self.moodCollectionView.isPagingEnabled = true
        
        
        // Hide keyboard on touch outside textfield
//        let tap = UIGestureRecognizer(target: self, action: #selector(dissmisKeyboard))
//        view.addGestureRecognizer(tap)
        
    }
    
    func dissmisKeyboard() {
        
    }
    
    func refreshMoodInfoButton()  {
        moodInfoButton.isHidden = false
        moodInfoButton.backgroundColor = Utility.uicolorFromHex(rgbValue: UInt32(selectedMood.color, radix: 16)!)
        moodInfoButton.layer.cornerRadius = 13
        moodInfoButton.setTitle(selectedMood.name, for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        self.weekCollectionView.reloadData()
        
        // Add top and bottom border for stackView
        let topLineLayer = CALayer()
        topLineLayer.backgroundColor = Colors.normalCellColor.cgColor
        topLineLayer.frame = CGRect(x:-50,y: 0, width:stackView.frame.size.width + 100, height:1)
        stackView.layer.addSublayer(topLineLayer)
        
        let bottomLineLayer = CALayer()
        bottomLineLayer.backgroundColor = Colors.normalCellColor.cgColor
        bottomLineLayer.frame = CGRect(x:-50, y:stackView.frame.size.height - 1, width:stackView.frame.size.width + 100, height:1)
        stackView.layer.addSublayer(bottomLineLayer)
    }
        
    // Select mode and run this closure
    func updateCollectinView(cell: MoodCollectionViewCell , moodCell: MoodsCollectionViewCell) {
        moodCollectionView.reloadItems(at: [moodCollectionView.indexPath(for: moodCell)!])
        
        let mood = realm.objects(Mood.self).filter("name == '\(cell.name!)'").first
        
        selectedMood = mood!
        // refresh info button color and name based on selected mood
        refreshMoodInfoButton()
        if mood!.value_type == "float" || mood!.value_type == "array"{
            moodValuesCollectionView.isHidden = true
            valueTextField.isHidden = false
            // set input type for textfield: (float | text)
            if mood!.value_type == "float"{
                valueTextField.keyboardType = .decimalPad
            }else if mood!.value_type == "array"{
                valueTextField.keyboardType = .default
            }
            
            guard let log = realm.objects(Log.self).filter("timestamp == \(CalendarViewController.selectedDate!.timeIntervalSince1970) AND mood.name = '\(selectedMood.name)'").first else {
                valueTextField.text = ""
                return
            }
            
            valueTextField.text = log.value
        }else { // collection values
            valueTypes = mood!.value_type.components(separatedBy: ",")
            moodValuesCollectionView.reloadData()
            moodValuesCollectionView.isHidden = false
            valueTextField.isHidden = true
            // check mood multiselection or not for set this
            self.moodValuesCollectionView.allowsMultipleSelection = mood?.multiselect == 1
        }
    }
    
    @IBAction func textValueEditingChanged(_ sender: Any) {
        
        guard let log = realm.objects(Log.self).filter("timestamp == \(Calendar.current.startOfDay(for: CalendarViewController.selectedDate!).timeIntervalSince1970) AND mood.name = '\(selectedMood.name)'").first else {
            
            // log not exist and should create one
            let log = Log()
            log.mood = selectedMood
            log.timestamp = Calendar.current.startOfDay(for: CalendarViewController.selectedDate!).timeIntervalSince1970
            log.value = valueTextField.text!
            
            try! realm.write{
                realm.add(log)
            }
            moodCollectionView.reloadData()
            return
        }
        
        // if log exist should update only
        try! realm.write {
            if (valueTextField.text?.isEmpty)! {
                realm.delete(log)
            }else{
                log.value = valueTextField.text!
            }
        }
        moodCollectionView.reloadData()
    }
    
    func getEnabledMoodFromDatabase() {
        let realm = try! Realm()
        if !isPregnant {
            moods = realm.objects(Mood.self).filter("enable == 1")
        }else{
            moods = realm.objects(Mood.self).filter("enable == 1 AND name != 'collection_method'")
        }
    }
    
    @IBOutlet weak var weekCollectionViewHeight: NSLayoutConstraint!
    // Scroll to current after layout subviews completed
    override func viewDidLayoutSubviews() {
        if !scrolledFirst {
            // Scroll to current week
            let diffrence = calendar.dateComponents([.weekOfYear], from: calendar.startOfDay(for: Date()), to: CalendarViewController.selectedDate!).weekOfYear
            
            self.weekCollectionView.scrollToItem(at: IndexPath(row: 25 + diffrence!, section: 0), at: .left, animated: false)
        }
        
        weekCollectionViewHeight.constant = (self.weekCollectionView.frame.width / 7 + 20)
        
    }
    
    @IBAction func gotoCurrentWeek(_ sender: Any) {
        self.weekCollectionView.scrollToItem(at: IndexPath(row: 25, section: 0), at: .left, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == weekCollectionView {
            
            // 51 week show and middle of items is currently week
            return 51
        }else if collectionView == moodCollectionView {
            // plus 1 for manage enabale mood
            let moodsCount = moods.count + 1
            if moodsCount % 3 == 0 {
                return moodsCount / 3
            }else{
                return moodsCount / 3 + 1
            }
        }else {
            return valueTypes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == weekCollectionView {
            
            let cell = self.weekCollectionView.dequeueReusableCell(withReuseIdentifier: "week_cell", for: indexPath) as! WeekCollectionViewCell
            
            cell.delegate = self
            cell.weekDate = calendar.date(byAdding: .weekOfYear, value: indexPath.row - 25 , to: nowDate)
            cell.refresh()
            
            return cell
        }else if collectionView == moodCollectionView{
            let cell = self.moodCollectionView.dequeueReusableCell(withReuseIdentifier: "moods_cell", for: indexPath) as! MoodsCollectionViewCell
            
            cell.delegate = self
            cell.moods.removeAll()
    
            for i in 0...2{
                // For avoid from index out of bounds
                if (indexPath.row * 3) + i >= moods.count {
                    
                    // Add manageMood as mood and should be handle when select
                    let manageMood = Mood()
                    manageMood.name = "manage_mood"
                    manageMood.color = "E9E9E9"
                    cell.moods.append(manageMood)
                    
                    break
                }
                cell.moods.append(moods[(indexPath.row * 3) + i])
            }
            
            cell.refresh()
            
            return cell
        }else {
            let cell = moodValuesCollectionView.dequeueReusableCell(withReuseIdentifier: "value_cell", for: indexPath) as! MoodValueCollectionViewCell
            
            cell.color = Utility.uicolorFromHex(rgbValue: UInt32(selectedMood.color, radix: 16)!)
            cell.value = valueTypes[indexPath.row]
            cell.refresh()
            if cell.isSelect{
                cell.isSelected = true
                moodValuesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == moodValuesCollectionView {
            let cell = moodValuesCollectionView.cellForItem(at: indexPath) as! MoodValueCollectionViewCell
            
            if isPregnant && selectedMood.name == "bleeding" && cell.value != "spotting" {
                showToast(message: "در حالت بارداری فقط امکان ذخیره لکه بینی را در دسته بندی خونریزی دارید")
                return
            } else if selectedMood.name == "bleeding" && cell.value != "spotting" {
                if Utility.forecastingDate(CalendarViewController.selectedDate! , setup: realm.objects(Setup.self).last!) != .period {
                    // Show Module and ask from user that log is not matches by forecasting do you change setup values and show user actually when she should change values TODO
                }
            }
            cell.toggle(mood: selectedMood)
            self.moodCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == moodValuesCollectionView {
            let cell = moodValuesCollectionView.cellForItem(at: indexPath) as! MoodValueCollectionViewCell
            
            cell.deselect(mood: selectedMood)
            self.moodCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == weekCollectionView {
            
            return CGSize(width: self.view.frame.width, height: self.weekCollectionView.frame.width / 7 + 20)
        }else if collectionView == moodCollectionView{
            
            return CGSize(width: self.view.frame.width, height: 130)
        } else{
            return CGSize(width: moodValuesCollectionView.frame.width / 2 - 10, height: moodValuesCollectionView.frame.width / 2 - 10)
        }
    }
    
    func updateTableView() {
        // Update all collection view for log new timestamp
        self.scrolledFirst = true
        self.weekCollectionView.reloadData()
        self.moodCollectionView.reloadData()
        self.moodValuesCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.weekCollectionView.reloadData()
        self.moodCollectionView.reloadData()
        self.moodValuesCollectionView.reloadData()
    }
    
    func cannotSelectFuture() {
        showToast(message: "نمی‌توانید روز های آینده را انتخاب کنید!")
    }
    
    func changeTitle(title: String) {
        titleLabel.text = title
    }
    
    func presentVC(id: String) {
        
    }
    
    func presentViewController(_ identifier: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        present(vc!, animated: true, completion: nil)
    }

}

extension UIViewController{
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 110, y: self.view.frame.size.height-100, width: 220, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "IRANSans(FaNum)", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1, delay: 0.8, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
