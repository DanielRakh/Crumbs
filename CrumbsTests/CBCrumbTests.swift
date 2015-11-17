//
//  CBCrumbTests.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import XCTest

@testable import Crumbs


// Mock Properties:

let kUserId = 1
let kCrumbId = 2
let kTitle = "Fake Title"
let kImageURL = "https://fakeurl.com"
let kLongitude = -34.10240
let kLatitude = 45.01023
let kCreatedOn = "2015-10-06T20:02:25.061Z"


class CBCrumbTests: XCTestCase {
    
    var testCrumb: CBCrumbEntity!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testCrumb = CBCrumbEntity(
            userId: kUserId,
            crumbId: kCrumbId,
            title: kTitle,
            imageURL: kImageURL,
            longitude: kLongitude,
            latitude: kLatitude,
            createdOn: kCreatedOn
        )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCrumbItem() {
        XCTAssertNotNil(testCrumb, "CBCrumb should not be nil")
    }



}
