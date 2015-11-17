//
//  CBNetworkService.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import ReactiveCocoa
import Foundation

    class CBNetworkingService: CBNetworking {
    
    let crumbsURL = NSURL(string: CrumbsAPIV1.baseURL + CrumbsAPIV1.postsEndPoint)!
    
    let session = NSURLSession.sharedSession()
    
    func producerToRequestAllCrumbsData() -> SignalProducer<NSData?, CBNetworkError> {
        
        return SignalProducer { observer, disposable in
            
            self.session.dataTaskWithURL(self.crumbsURL) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                
                guard error == nil else {
                    observer.sendFailed(CBNetworkError.ResponseError(description: error!.localizedDescription))
                    return
                }
                
                guard (response as? NSHTTPURLResponse)?.statusCode == 200 else {
                    let statusCode = (response as? NSHTTPURLResponse)?.statusCode
                    observer.sendFailed(CBNetworkError.StatusCodeError(statusCode: "\(statusCode)"))
                    return
                }
                
                observer.sendNext(data)
                observer.sendCompleted()
                
                }.resume()
        }
    }
    
    
    func producerToRequestImage(url: String) -> SignalProducer<UIImage, CBNetworkError> {
        
        return SignalProducer { observer, disposable in
            
            self.session.dataTaskWithURL(NSURL(string: url)!) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                
                guard error == nil else {
                    observer.sendFailed(CBNetworkError.ResponseError(description: error!.localizedDescription))
                    return
                }
                
                observer.sendNext(UIImage(data: data!, scale: 0)!)
                observer.sendCompleted()
                
            }.resume()
        }
    }
    
    
    
}
