//
//  VerticalCenterTextLayer.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/29/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class VerticalCenterTextLayer: CATextLayer {
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
    }
    
    override func draw(in ctx: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10
        
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
