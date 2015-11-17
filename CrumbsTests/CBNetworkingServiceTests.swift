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
    
    
    func testResponseForImageReturnsAnImage() {
        
        let expectation = expectationWithDescription("Completion")
        let imageURL = "https://httpbin.org/image/jpeg"
        var image:UIImage?
        
        networkService.producerToRequestImage(imageURL).on(next: {
            image = $0
            XCTAssertNotNil(image, "There should be a image returned")
            expectation.fulfill()
        }).start()
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    
    func testResponseGetsAnErrorIfIncorrectDataForImageIsReturned() {
        
        let expectation = expectationWithDescription("Completion")
        let notImageURL = "https://httpbin.org/get"
        let incorrectDataErrorDesc = "The NSData was not able to be converted to a UIImage"
        
        networkService.producerToRequestImage(notImageURL).on(failed: {
            
            switch $0 {
                
                case .IncorrectDataReturned(let desc):
                    XCTAssertEqual(desc, incorrectDataErrorDesc)
                    expectation.fulfill()
                default:
                    print("Some other error")
            }
            
        }).start()
        
        waitForExpectationsWithTimeout(10, handler: nil)
        
    }
    

    // TODO: Figure out how to handle errors with Enums
//    func testResponseGetsAnErrorIfNetworkCannotGetAResponse() {
//        
//        let expectation = expectationWithDescription("Completion")
//        let brokenNetworkURL = "https://not.existing.server.comm/image/jpeg"
//        
//    }
//    
    
    
    
    
    
    
    
    
}
