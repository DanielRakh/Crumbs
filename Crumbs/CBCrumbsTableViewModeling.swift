//
//  CrumbsTableViewModeling.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol CBCrumbsTableViewModeling {
    
    var cellModels: AnyProperty<[CBCrumbsTableViewCellModeling]> { get }
    
    func startFetch()

}
