//
//  CBNetworking.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ReactiveCocoa

enum CBNetworkError : ErrorType {
    
    /// Uknown generic error.
    case Unknown(description: String)

    /// A wrapper for NSError's from data requests on NSURLSession
    case ResponseError(description: String)
    
    /// Status code != 200
    case StatusCodeError(statusCode: String)
    
    /// Not connected to the internet.
    case NotConnectedToInternet
    
    /// Cannot reach the server.
    case NotReachedServer
    
    /// Connection is lost.
    case ConnectionLost
    
    /// Incorrect data returned from the server.
    case IncorrectDataReturned(description: String)

}

protocol CBNetworking {
    
    func producerToRequestAllCrumbsData() -> SignalProducer<NSData?, CBNetworkError>
    
    func producerToRequestImage(url: String) -> SignalProducer<UIImage, CBNetworkError>
    
}
