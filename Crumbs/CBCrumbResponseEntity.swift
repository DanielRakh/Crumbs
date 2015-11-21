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
        longitude <- map[CrumbsAPIV1.kLongitudeKey]
        latitude <- map[CrumbsAPIV1.kLatitudeKey]
        createdTimestamp <- map[CrumbsAPIV1.kCreatedAtKey]
        updatedTimestamp <- map[CrumbsAPIV1.kUpdatedAtKey]
        
    }
}




