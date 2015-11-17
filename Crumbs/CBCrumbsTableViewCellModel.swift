//
//  CBCrumbCellModel.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation


class CBCrumbsTableViewCellModel:CBCrumbsTableViewCellModeling {
    
    var usernameText: String
    var titleText: String
    //    let crumbImage: UIImage
    var timestampText: String
    
    init(crumb: CBCrumb) {
        usernameText = "\(crumb.userId)"
        titleText = crumb.title
        timestampText = crumb.createdOn
    }
    
}