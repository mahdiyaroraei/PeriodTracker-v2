//
//  CircleOption.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/27/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class CircleOption: NSObject {
    var color: UIColor!
    var startAngle: CGFloat!
    var endAngle: CGFloat!
    
    init(color: UIColor , startAngle: CGFloat , endAngle: CGFloat) {
        self.color = color
        self.endAngle = endAngle
        self.startAngle = startAngle
    }
}
