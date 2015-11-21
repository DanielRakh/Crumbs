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
    private let networkService: CBNetworking
    

    init(crumbFetcher:CBCrumbFetching, networking: CBNetworking) {
        self.crumbsFetcher = crumbFetcher
        self.networkService = networking
    }
    
    func startFetch() {
        
        crumbsFetcher.fetchAllCrumbs()
            .startOn(QueueScheduler.mainQueueScheduler)
            .map { (crumbs:[CBCrumbResponseEntity]) -> [CBCrumbsTableViewCellModeling] in
                
                crumbs.map { crumb in
                    return CBCrumbsTableViewCellModel(crumb: crumb, networking: self.networkService)
                }
            }
            .observeOn(UIScheduler())
            .on(next: { models in
                self._cellModels.value = models
            })
            .start()
    }
    
    
    
    
}