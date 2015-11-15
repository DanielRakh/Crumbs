//
//  CBNetworkingServiceTests.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import XCTest

@testable import Crumbs

class CBNetworkingServiceTests: XCTestCase {
    
    let networkService = CBNetworkService()
    

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    

    func testResponseForCrumbsIsNotNil() {
        
        let expectation = expectationWithDescription("Completion")
        
        networkService.producerToRequestCrumbs().on(failed: { (error:CBNetworkingError) -> () in
            
            switch error {
                
            case .ResponseError(let description):
                print("Response Error: \(description)")
            case .StatusCodeError(let statusCode):
                print ("Status Code Error: \(statusCode)")
                
            }
            
            }) { (response:AnyObject?) -> () in
                XCTAssertNotNil(response, "The response should not be nil")
                expectation.fulfill()
        }.start()
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }

}
