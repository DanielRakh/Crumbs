//
//  CBCrumb.swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ObjectMapper

struct CBCrumbResponseEntity : Mappable {

    var id: Int?
    var username: String?
    var title: String?
    var imageURL: String?
    var longitude: Double?
    var latitude: Double?
    var createdTimestamp: String?
    var updatedTimestamp: String?
    
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        
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




