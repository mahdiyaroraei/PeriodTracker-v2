//
//  Category.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/23/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
class Category {
    var id: Int
    var imageURL: String
    var name: String
    
    init(id: Int, imageURL: String, name: String) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
    }
    
    init() { // For all categories
        self.id = -1
        self.imageURL = ""
        self.name = ""
    }
}
