//
//  CBNetworkService.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ReactiveCocoa
import Foundation

class CBNetworkService: CBNetworking {
    
    static let apiRef = "https://crumbs-app.herokuapp.com"
    static let postsEndPoint = "/posts"
    
    let crumbsURL = NSURL(string: apiRef + postsEndPoint)!
    
    let session = NSURLSession.sharedSession()
    
    
    func producerToRequestCrumbs() -> SignalProducer<AnyObject?, CBNetworkingError> {
        
        return SignalProducer { observer, disposable in
            
            self.session.dataTaskWithURL(self.crumbsURL) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                
                guard error == nil else {
                    observer.sendFailed(CBNetworkingError.ResponseError(description: error!.localizedDescription))
                    return
                }
                
                guard (response as? NSHTTPURLResponse)?.statusCode == 200 else {
                    let statusCode = (response as? NSHTTPURLResponse)?.statusCode
                    observer.sendFailed(CBNetworkingError.StatusCodeError(statusCode: "\(statusCode)"))
                    return
                }
                
                observer.sendNext(data)
                observer.sendCompleted()
                
                }.resume()
        }
    }
    
    
    
}
