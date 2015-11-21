//
//  CBCrumbCellModel.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation
import ReactiveCocoa


class CBCrumbsTableViewCellModel:NSObject, CBCrumbsTableViewCellModeling {
    
    var usernameText: String?
    var titleText: String?
    var timestampText: String?
    
    private let networkService: CBNetworking
    private var imageURL: String?
    private var crumbImage: UIImage?
    
    
    init(crumb: CBCrumbResponseEntity, networking: CBNetworking) {
        usernameText = crumb.username
        titleText = crumb.title
        timestampText = crumb.createdTimestamp
        imageURL = crumb.imageURL
        networkService = networking
        super.init()
    }
    
    func getCrumbImage() -> SignalProducer<UIImage?, NoError> {
        
        if let crumbImage = self.crumbImage {
            return SignalProducer(value: crumbImage).observeOn(UIScheduler())
        }
        else {
            let imageProducer = networkService.producerToRequestImage(self.imageURL!).startOn(QueueScheduler.mainQueueScheduler)
                .takeUntil(self.racutil_willDeallocProducer)
                .on(next: { self.crumbImage = $0 })
                .map { $0 as UIImage? }
                .flatMapError { _ in SignalProducer<UIImage?, NoError>(value: nil) }
            
            return SignalProducer(value: nil)
                .concat(imageProducer)
                .observeOn(UIScheduler())
        }
    }
    
}