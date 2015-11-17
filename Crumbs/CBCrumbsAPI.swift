//
//  CBCrumbsAPI.swift
//  Crumbs
//
//  Created by Daniel on 11/17/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation


struct CrumbsAPIV1 {
    
    static let baseURL = "https://crumbs-app.herokuapp.com/api/v1"
    static let postsEndPoint = "/posts"
    
    
    //MARK: JSON Keys
    static let kIdKey = "id"
    static let kUserIdKey = "user_id"
    static let kUsernameKey = "username"
    static let kTitleKey = "title"
    static let kImageURLKey = "image_url"
    static let kLongitudeKey = "longitude"
    static let kLatitudeKey = "latitude"
    static let kUpdatedAtKey = "updated_at"
    static let kCreatedAtKey = "created_at"


}