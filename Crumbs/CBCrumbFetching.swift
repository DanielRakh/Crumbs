//
//  CBCrumbFetching.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ReactiveCocoa

protocol CBCrumbFetching {
    
    func fetchAllCrumbs() -> SignalProducer<[CBCrumb], CBNetworkError>
    
}