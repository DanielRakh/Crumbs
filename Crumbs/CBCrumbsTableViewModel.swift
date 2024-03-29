//
//  CBCrumbsTableViewModel.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ReactiveCocoa
import RealmSwift

class CBCrumbsTableViewModel: CBCrumbsTableViewModeling {

    var cellModels: AnyProperty<[CBCrumbsTableViewCellModeling]> {
        return AnyProperty(_cellModels)
    }
    
    
    private let _cellModels = MutableProperty<[CBCrumbsTableViewCellModeling]>([])
    private let crumbsFetcher: CBCrumbFetching
    private let networkService: CBNetworking
    
    
    var crumbs = try! Realm().objects(CBCrumbResponseEntity)
    

    init(crumbFetcher:CBCrumbFetching, networking: CBNetworking) {
        self.crumbsFetcher = crumbFetcher
        self.networkService = networking
//        super.init()
//        crumbs.addObserver(self, forKeyPath: "count", options: .New, context: nil)
    }
    
    
//    deinit {
//        crumbs.removeObserver(self, forKeyPath: "count")
//    }
//    
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
    
    
    
//    //MARK: KVO
//    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "count" {
//            print(<#T##items: Any...##Any#>)
//        }
//    }
    
    
    
}