//
//  ChatLabel.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/27/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

@IBDesignable class ChatLabel: UITextView {

    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 14.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 14.0
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(UIEdgeInsetsInsetRect(rect, insets))
    }
    
//    override func drawText(in rect: CGRect) {
//        super.drawText(in: )
//    }
//
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        
        return adjSize
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        
        return contentSize
    }
    
}
