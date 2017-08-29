//
//  Pricing.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/19/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
class Pricing {
    var title: String!
    var price: Int!
    var type: SubscribeType
    
    init(title: String!, price: Int!, type: SubscribeType) {
        self.title = title
        self.price = price
        self.type = type
    }
}
enum SubscribeType {
    case oneMonth
    case threeMonth
    case twelveMonth
}
