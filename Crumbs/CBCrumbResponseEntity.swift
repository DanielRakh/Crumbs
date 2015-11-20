//
//  CBCrumb.swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ObjectMapper
import RealmSwift

class CBCrumbResponseEntity : Object, Mappable {

    dynamic var id = 0
    dynamic var username: String?
    dynamic var title: String?
    dynamic var imageURL: String?
    dynamic var longitude:Double = 0.0
    dynamic var latitude:Double = 0.0
    dynamic var createdTimestamp: String?
    dynamic var updatedTimestamp: String?
    
    
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        
        id <- map[CrumbsAPIV1.kIdKey]
        username <- map[CrumbsAPIV1.kUsernameKey]
        title <- map[CrumbsAPIV1.kTitleKey]
        imageURL <- map[CrumbsAPIV1.kImageURLKey]
        longitude <- (map[CrumbsAPIV1.kLongitudeKey], TransformOf<Double, String>(fromJSON: { Double($0!) }, toJSON: { $0.map { String($0) } }))
        latitude <- (map[CrumbsAPIV1.kLatitudeKey], TransformOf<Double, String>(fromJSON: { Double($0!) }, toJSON: { $0.map { String($0) } }))
        createdTimestamp <- map[CrumbsAPIV1.kCreatedAtKey]
        updatedTimestamp <- map[CrumbsAPIV1.kUpdatedAtKey]
        
    }
}




