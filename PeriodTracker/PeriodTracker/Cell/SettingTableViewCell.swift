//
//  SettingTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/5/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    var setting: SettingModel!{
        didSet{
            setupViews()
            settingNameLabel.text = setting.name
            iconImageView.image = UIImage(named: "setting_\(setting.key!)")
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let settingNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont(name: "IRANSansFaNum-Bold", size: 13)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "left-arrow")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let actionSwitch: UISwitch = {
        let actionSwitch = UISwitch()
        actionSwitch.translatesAutoresizingMaskIntoConstraints = false
        return actionSwitch
    }()
    
    func setupViews() {
        let isAction = setting.type == SettingType.action
        
        addSubview(iconImageView)
        addSubview(settingNameLabel)
        addSubview(seperatorView)
        
        if isAction {
            addSubview(actionSwitch)
        }else{
            addSubview(arrowImageView)
            addConstraint(NSLayoutConstraint(item: arrowImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15))
        }
        
        // Define contraints
        let views = ["settingNameLabel": settingNameLabel ,
                     "actionView": isAction ? actionSwitch : arrowImageView,
                     "seperatorView": seperatorView,
                     "iconImageView": iconImageView]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[settingNameLabel]-12-[iconImageView(30)]-12-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[actionView]", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[seperatorView]-54-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[seperatorView(0.5)]|", options: [], metrics: nil, views: views))
        
        addConstraint(NSLayoutConstraint(item: settingNameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: isAction ? actionSwitch : arrowImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
