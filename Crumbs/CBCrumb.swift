//
//  CBCrumb.swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation


struct CBCrumb : CBCrumbType {
    
    let userId: Int
    let crumbId: Int
    let title: String
    let imageURL: String
    let longitude: Double
    let latitude: Double
    
    init(userId:Int, crumbId:Int, title:String, imageURL:String, longitude:Double, latitude:Double) {
        self.userId = userId
        self.crumbId = crumbId
        self.title = title
        self.imageURL = imageURL
        self.longitude = longitude
        self.latitude = latitude
    }
    
}
