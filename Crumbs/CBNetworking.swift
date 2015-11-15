//
//  CBNetworking.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ReactiveCocoa

enum CBNetworkingError : ErrorType {
    case NetworkError(description: String)
}

protocol CBNetworking {
    
    func producerToRequestCrumbs() -> SignalProducer<[AnyObject], CBNetworkingError>
    
}
