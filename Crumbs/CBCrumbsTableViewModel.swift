//
//  CBCrumbsTableViewModel.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ReactiveCocoa

class CBCrumbsTableViewModel: CBCrumbsTableViewModeling {

    var cellModels: AnyProperty<[CBCrumbsTableViewCellModeling]> {
        return AnyProperty(_cellModels)
    }
    
    private let _cellModels = MutableProperty<[CBCrumbsTableViewCellModeling]>([])
    private let crumbsFetcher: CBCrumbFetching

    init(crumbFetcher:CBCrumbFetching) {
        self.crumbsFetcher = crumbFetcher
    }
    
    func startFetch() {
        
        crumbsFetcher.fetchAllCrumbs().map { (crumbs:[CBCrumb]) -> [CBCrumbsTableViewCellModeling] in
            crumbs.map { crumb in
                return CBCrumbsTableViewCellModel(crumb: crumb)
            }
        }.observeOn(UIScheduler())
            .on(next: { models in
                self._cellModels.value = models
            })
            .start()
        
    }

}