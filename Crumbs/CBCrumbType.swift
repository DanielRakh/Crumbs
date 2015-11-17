//
//  CrumbType.swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//


protocol CBCrumbType {
    
    var userId: Int { get }
    var crumbId: Int { get }
    var title: String { get }
    var imageURL: String { get }
    var longitude: Double { get }
    var latitude: Double { get }
    var createdOn: String { get }
}