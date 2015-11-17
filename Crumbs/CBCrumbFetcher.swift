//
//  CBCrumbFetcher.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ObjectMapper


class CBCrumbFetcher: CBCrumbFetching {
    
    let networking: CBNetworking!
    
    init(networking:CBNetworking) {
        self.networking = networking
    }
    
    
    // MARK: CBCrumbFetching Implementation
    func fetchAllCrumbs() -> SignalProducer<[CBCrumbResponseEntity], CBNetworkError> {
        
        return networking.producerToRequestAllCrumbsData()
            .flatMap(.Latest, transform: producerToTransformDataToJSON)
            .flatMap(.Concat, transform: producerToTransformJSONToCrumbItems)
    }
    
    
    // MARK: Private Helpers
    private func producerToTransformDataToJSON(data:NSData?) -> SignalProducer<[[String : AnyObject]], CBNetworkError> {
        
        return SignalProducer {observer, disposable in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [[String : AnyObject]]
                observer.sendNext(json)
                observer.sendCompleted()
            } catch let error as NSError {
                print(error.description)
                observer.sendFailed(CBNetworkError.IncorrectDataReturned(description: error.description))
            }
        }
    }
    
    private func producerToTransformJSONToCrumbItems(json:[[String : AnyObject]]) -> SignalProducer<[CBCrumbResponseEntity], CBNetworkError> {
        
        return SignalProducer { observer, disposable in
    
            let crumbs = json.flatMap { dict in
                return Mapper<CBCrumbResponseEntity>().map(dict)
            }
            
            observer.sendNext(crumbs)
            observer.sendCompleted()
        }

    }
    
    
    
    
    
//    func producerToFetchAllCrumbs() -> SignalProducer<[CBCrumb], CBNetworkingError> {
//        
//        return networking.producerToRequestAllCrumbsData().map({ (data:NSData?) -> [[String: AnyObject]] in
//            do {
//                return try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [[String: AnyObject]]
//                
//            } catch let error as NSError {
//                print(error.description)
//            }
//        })
//    }
    
    
}







