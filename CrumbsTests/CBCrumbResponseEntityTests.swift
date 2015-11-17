//
//  CBCrumbResponseEntityTests.swift
//  Crumbs
//
//  Created by Daniel on 11/17/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import Crumbs

class CBCrumbResponseEntityTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    

    func testParsesV1JSONDictionaryResponse() {

        let responseEntity = Mapper<CBCrumbResponseEntity>().map(V1JSONDictionaryResponse)
        
        XCTAssertNotNil(responseEntity, "A ResponseEntity Instance should be created")
        XCTAssertEqual(responseEntity?.id, V1JSONDictionaryResponse["id"] as? Int)
        XCTAssertEqual(responseEntity?.username,V1JSONDictionaryResponse["username"] as? String)
        XCTAssertEqual(responseEntity?.title, V1JSONDictionaryResponse["title"] as? String)
        XCTAssertEqual(responseEntity?.imageURL, V1JSONDictionaryResponse["image_url"] as? String)
        XCTAssertEqual(responseEntity?.latitude, V1JSONDictionaryResponse["latitude"] as? Double)
        XCTAssertEqual(responseEntity?.longitude, V1JSONDictionaryResponse["longitude"] as? Double)
        XCTAssertEqual(responseEntity?.updatedTimestamp, V1JSONDictionaryResponse["updated_at"] as? String)
        XCTAssertEqual(responseEntity?.createdTimestamp, V1JSONDictionaryResponse["created_at"] as? String)
    }


}
