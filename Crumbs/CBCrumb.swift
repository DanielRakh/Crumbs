//
//  CBCrumb.swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation


let kCrumbUserId = "userID"
let kCrumbId = "crumbID"
let kCrumbLatitudeKey = "latitude"
let kCrumbLongitudeKey = "longitude"
let kCrumbImageURLKey = "image"

class CBCrumb : NSObject, NSCoding {
    
    var userId: Int
    var crumbId: Int
    var imageURL: String
    var longitude: String
    var latitude: String
    
    
    init(userId:Int, crumbId:Int, imageURL:String, longitude:String, latitude:String) {
        self.userId = userId
        self.crumbId = crumbId
        self.imageURL = imageURL
        self.longitude = longitude
        self.latitude = latitude
    }
    
    
    // MARK: NSCoding
    
    required init?(coder decoder: NSCoder) {
        latitude = decoder.decodeObjectForKey(kCrumbLatitudeKey) as! String
        longitude = decoder.decodeObjectForKey(kCrumbLongitudeKey) as! String
        imageURL = decoder.decodeObjectForKey(kCrumbImageURLKey) as! String
        crumbId = decoder.decodeIntegerForKey(kCrumbId)
        userId = decoder.decodeIntegerForKey(kCrumbUserId)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(latitude, forKey: kCrumbLatitudeKey)
        coder.encodeObject(longitude, forKey: kCrumbLongitudeKey)
        coder.encodeInteger(crumbId, forKey: kCrumbId)
        coder.encodeInteger(userId, forKey: kCrumbUserId)
        coder.encodeObject(imageURL, forKey: kCrumbImageURLKey)
    }
    
    
    
}
