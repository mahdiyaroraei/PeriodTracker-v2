//
//  Modal.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/13/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
import UIKit

class Modal {
    var title: String
    var desc: String
    var image: UIImage?
    var firstTextFieldHint: String?
    var secondTextFieldHint: String?
    var leftButtonTitle: String?
    var rightButtonTitle: String?
    var onLeftTapped: ((UIViewController) -> Void)?
    var onRightTapped: ((UIViewController) -> Void)?
    var type: ModalType
    
    init(title: String , desc: String , image: UIImage? ,
            leftButtonTitle: String?, rightButtonTitle: String? ,
            onLeftTapped: ((UIViewController) -> Void)?, onRightTapped: ((UIViewController) -> Void)?) {
        self.title = title
        self.desc = desc
        self.image = image
        
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        
        self.onLeftTapped = onLeftTapped
        self.onRightTapped = onRightTapped
        
        self.type = .normal
    }
    
    init(title: String , desc: String , image: UIImage? , firstTextFieldHint: String ,secondTextFieldHint: String, leftButtonTitle: String, rightButtonTitle: String
    , onLeftTapped: @escaping ((UIViewController) -> Void), onRightTapped: @escaping ((UIViewController) -> Void), type: ModalType) {
        self.title = title
        self.desc = desc
        self.image = image
        
        self.firstTextFieldHint = firstTextFieldHint
        self.secondTextFieldHint = secondTextFieldHint
        
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        
        self.onLeftTapped = onLeftTapped
        self.onRightTapped = onRightTapped
        
        self.type = type
        self.secondTextFieldHint = secondTextFieldHint
    }
}

enum ModalType {
    case normal
    case oneTextField
    case twoTextField
}
