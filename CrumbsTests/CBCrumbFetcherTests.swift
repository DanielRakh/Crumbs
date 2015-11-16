//
//  CBCrumbFetcherTests.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import XCTest

@testable import Crumbs

class CBCrumbFetcherTests: XCTestCase {
    
//    let mockNetwork:CBNetworking
    
    let networkService = CBNetworkingService()
    var crumbFetcher:CBCrumbFetching!

    override func setUp() {
        super.setUp()
        crumbFetcher = CBCrumbFetcher(networking: networkService)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDataManagerToReturnCrumbs() {
        
        let expectation = expectationWithDescription("Completion")
        
        crumbFetcher.fetchAllCrumbs().on(failed: { (error:CBNetworkError) -> () in
            print(error)
            }) { (crumbs:[CBCrumb]) -> () in
                print(crumbs)
                XCTAssertNotNil(crumbs, "There should be some crumbs")
                expectation.fulfill()
        }.start()
        
        waitForExpectationsWithTimeout(10, handler: nil)
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }



}