//
//  CBCrumbsTableViewModel.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation


class CBCrumbsTableViewModel: CBCrumbsTableViewModeling {
    
    private let crumbsSearch: CBCrumbFetching
    
    init(crumbsFetcher: CBCrumbFetching) {
        self.crumbsSearch = crumbsFetcher
    }
}