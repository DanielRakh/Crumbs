//
//  CBNetworking.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ReactiveCocoa

enum CBNetworkingError : ErrorType {
    
    case ResponseError(description: String)
    case StatusCodeError(statusCode: String)
}

protocol CBNetworking {
    
    func producerToRequestAllCrumbsData() -> SignalProducer<NSData?, CBNetworkingError>
    
}
