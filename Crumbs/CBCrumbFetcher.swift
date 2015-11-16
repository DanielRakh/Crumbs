//
//  CBCrumbFetcher.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation
import ReactiveCocoa


let kUserIdKey = "user_id"
let kCrumbIdKey = "id"
let kTitleKey = "title"
let kImageURLKey = "image_url"
let kLongitudeKey = "longitude"
let kLatitudeKey = "latitude"

class CBCrumbFetcher: CBCrumbFetching {
    
    let networking: CBNetworking!
    
    init(networking:CBNetworking) {
        self.networking = networking
    }
    
    
    // MARK: CBCrumbFetching Implementation
    func fetchAllCrumbs() -> SignalProducer<[CBCrumb], CBNetworkError> {
        
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
    
    private func producerToTransformJSONToCrumbItems(json:[[String : AnyObject]]) -> SignalProducer<[CBCrumb], CBNetworkError> {
        
        return SignalProducer { observer, disposable in
    
            let crumbs = json.flatMap { dict in
                return CBCrumb(
                    userId: dict[kUserIdKey] as! Int,
                    crumbId: dict[kCrumbIdKey] as! Int,
                    title: dict[kTitleKey] as! String,
                    imageURL: dict[kImageURLKey] as! String,
                    longitude: Double(dict[kLongitudeKey] as! String)!,
                    latitude: Double(dict[kLatitudeKey] as! String)!)
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







