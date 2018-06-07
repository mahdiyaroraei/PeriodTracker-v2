//
//  CategoryCVCell.swift
//  PeriodTracker
//
//  Created by Mostafa Oraei on 3/16/1397 AP.
//  Copyright © 1397 Mahdiar . All rights reserved.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {
    
    let colorName = [Colors.niceBlue, Colors.niceYellow, Colors.niceRed, Colors.niceGreen]
    let imageName = ["nicepregnant", "nicesick", "niceperiod", "nicedots"]
    let titleImage = ["بارداری", "بیماری ها", "قاعدگی", "متفرقه"]

    var indexPath: Int? {
        didSet{
            iconImage.image = UIImage(named: imageName[indexPath!])?.withRenderingMode(.alwaysTemplate)
            label.text = titleImage[indexPath!]
            iconImage.tintColor = .white
            label.textColor = .white
        }
    }
    var selectedItem: Int? {
        didSet{
            if let i = selectedItem {
                self.backgroundColor = colorName[i]
            }
            
        }
    }
    var deselectedItem: Int? {
        didSet{
            self.backgroundColor = Colors.darkToosi
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareForReuse()
        self.layer.cornerRadius = 8
        self.backgroundColor = Colors.darkToosi
        setupView()
    }
    
    func setupView() {
        addSubview(iconImage)
        addSubview(label)
        
        iconImage.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        iconImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        iconImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true

        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "clock")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = Colors.darkToosi
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "بارداری"
        label.textColor = Colors.darkToosi
        label.font = UIFont(name: "IRANSansFaNum-Light", size: 8)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.backgroundColor = Colors.darkToosi
    }
    
}
