//
//  CBCrumbCellModeling.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol CBCrumbsTableViewCellModeling {
    
    var usernameText: String? { get }
    var titleText: String? { get }
    var timestampText: String? { get }    
    
    func getCrumbImage() -> SignalProducer<UIImage?, NoError>

    
}