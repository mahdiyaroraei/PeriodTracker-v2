//
//  SettingViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/4/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class SettingViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    let settingTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        self.title = "تنظیمات"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "IRANSansFaNum", size: 20)! , NSForegroundColorAttributeName: UIColor.uicolorFromHex(rgbValue: 0x76858e)]
        
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "cell")
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    func setupViews() {
        self.view.addSubview(settingTableView)
        
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: nil, views: ["v0": settingTableView , "topGuide": topLayoutGuide])
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: [], metrics: nil, views: ["v0": settingTableView])
        
        NSLayoutConstraint.activate(allConstraints)
        
        settingTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
//    
//    var settings = [
//        SettingModel("یادآور", type: .normal, key: "notice"),
//        SettingModel("راه اندازی مجدد", type: .normal, key: "setup"),
//        SettingModel("حالت بارداری", type: .action, key: "pregnant"),
//        SettingModel("پشتیبانی", type: .normal, key: "support"),
//        SettingModel("راهنما", type: .normal, key: "guide")
//    ]
//    
    
    var settings = [
            SettingModel("یادآور", type: .normal, key: "notice"),
            SettingModel("راه اندازی مجدد", type: .normal, key: "setup"),
            SettingModel("حالت بارداری", type: .action, key: "pregnant"),
            SettingModel("پشتیبانی", type: .normal, key: "support")
    ]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
        cell.setting = settings[indexPath.item]
        if settings[indexPath.item].type == .action {
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if settings[indexPath.item].key == "setup" {
            
            self.dismiss(animated: false, completion: nil)
            UserDefaults.standard.set(false, forKey: "setup-complete")
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.window?.rootViewController?.present((self.storyboard?.instantiateViewController(withIdentifier: "setupPageViewController"))!, animated: true, completion: nil)
            }
        } else if settings[indexPath.item].key == "notice" {
            let vc = SettingViewController()
            vc.settings = [
                SettingModel("یادآوری شروع دوره بعد", type: .action, key: "notice-period"),
                SettingModel("یادآوری شروع دوره تخمک گذاری", type: .action, key: "notice-fertile")
            ]

            navigationController?.pushViewController(vc, animated: true)
        } else if settings[indexPath.item].key == "support" {
            self.navigationController?.pushViewController(ContactUsViewController(), animated: true)
        }
    }

}
