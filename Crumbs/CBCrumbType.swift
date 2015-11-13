//
//  CrumbType.swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//


protocol CBCrumbType {
    
    var user_id: Int { get }
    var imageURL: String { get }
    var longitude: String { get }
    var latitude: String { get }
    var crumb_id: Int { get }
    
}