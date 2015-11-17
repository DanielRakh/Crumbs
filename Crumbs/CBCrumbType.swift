//
//  CrumbType.swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//


//TODO: CURRENTLY UNLINKED FROM TARGET

protocol CBCrumbResponseType {
    
    var id: UInt64 { get }
    var username: String { get }
    var title: String { get }
    var imageURL: String { get }
    var longitude: Double { get }
    var latitude: Double { get }
    var createdTimestamp: String { get }
    var updatedTimestamp: String { get }
}