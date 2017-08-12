//
//  Item.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation

class Item {
    var type: ItemType!
    
    // Attribute text item
    var text: String!
    var attributes: [TextAttribute]?
    var link: String?
    
    init(text: String!, attributes: [TextAttribute]? , link: String?) {
        self.type = .AttributeText
        self.text = text
        self.attributes = attributes
        self.link = link
    }
    
    // Image item
    var images: [Image]?
    
    init(images: [Image]!) {
        self.type = .Image
        self.images = images
    }
}
enum ItemType: String {
    case AttributeText = "attribute_text"
    case Image = "image"
}
