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
        
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "cell")
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    func setupViews() {
        self.view.addSubview(settingTableView)
        
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[topGuide][v0]|", options: [], metrics: nil, views: ["v0": settingTableView , "topGuide": topLayoutGuide])
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: [], metrics: nil, views: ["v0": settingTableView])
        
        NSLayoutConstraint.activate(allConstraints)
        
        settingTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    let settings = [
            SettingModel("یادآور", type: .normal, key: "notice"),
            SettingModel("راه اندازی مجدد", type: .normal, key: "setup"),
            SettingModel("حالت بارداری", type: .action, key: "pregnant"),
            SettingModel("پشتیبانی", type: .normal, key: "support"),
            SettingModel("راهنما", type: .normal, key: "guide")
    ]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
        cell.setting = settings[indexPath.item]
        if settings[indexPath.item].type == .action {
            cell.selectionStyle = .none
        }
        return cell
    }

}
