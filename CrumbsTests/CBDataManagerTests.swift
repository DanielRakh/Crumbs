//
//  CBDataManagerTests.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import XCTest

@testable import Crumbs

class CBDataManagerTests: XCTestCase {
    
//    let mockNetwork:CBNetworking
    
    let networkService = CBNetworkingService()
    var dataManager:CBDataManager!

    override func setUp() {
        super.setUp()
        dataManager = CBDataManager(networking: networkService)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDataManagerToReturnCrumbs() {
        
        let expectation = expectationWithDescription("Completion")
        
        dataManager.producerToFetchAllCrumbs().on(failed: { (error:CBNetworkingError) -> () in
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
