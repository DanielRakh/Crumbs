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
    
    let networkService = CBNetworkingService()
    

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testResponseForCrumbsIsNotNil() {
        
        let expectation = expectationWithDescription("Completion")
        
        networkService.producerToRequestAllCrumbsData().on(failed: { (error:CBNetworkError) -> () in
            
            switch error {
    
            case .ResponseError(let description):
                print("Response Error: \(description)")
                
            case .StatusCodeError(let statusCode):
                print ("Status Code Error: \(statusCode)")
                
            case .IncorrectDataReturned(let description):
                print("Incorrect Data Returned Error: \(description)")
                
            default:
                print("Hit default case in CBNetworkError")
            }
            
            }) { (response:NSData?) -> () in
                XCTAssertNotNil(response, "The response should not be nil")
                expectation.fulfill()
        }.start()
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }

}
