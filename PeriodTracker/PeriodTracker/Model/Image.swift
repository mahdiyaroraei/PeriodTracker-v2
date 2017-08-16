//
//  Image.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/9/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
class Image {
    var imageURL: String!
    var link: String?
    var aspectRatio: Float? // height / width
    
    init(imageURL: String!, link: String?, aspectRatio: Float?) {
        self.imageURL = imageURL
        self.link = link
        self.aspectRatio = aspectRatio
    }
}
