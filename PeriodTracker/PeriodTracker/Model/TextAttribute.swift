//
//  TextAttribute.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation

class TextAttribute {
    var key: String!
    var value: String?
    var range: NSRange?
    
    init(key: String!, value: String?, range: String?) {
        self.key = key
        self.value = value
        
        if let range = range {
            let range = NSRange(location: Int(range.components(separatedBy: "...")[0])!, length: Int(range.components(separatedBy: "...")[1])!)
            self.range = range
        }else{
            self.range = nil
        }
    }
}
