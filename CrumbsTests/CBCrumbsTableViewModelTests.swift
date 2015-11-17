//
//  CBCrumbsTableViewModelTests.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import XCTest

@testable import Crumbs


class CBCrumbsTableViewModelTests: XCTestCase {
    
    let networking = CBNetworkingService()
    var crumbsFetcher: CBCrumbFetching!
    var crumbsTableViewModel: CBCrumbsTableViewModeling!
    
    override func setUp() {
        super.setUp()
        
        crumbsFetcher = CBCrumbFetcher(networking: networking)
        crumbsTableViewModel = CBCrumbsTableViewModel(crumbFetcher: crumbsFetcher)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testStartFetchFillsAnArrayOfCellModels() {
//        crumbsTableViewModel.startFetch()
//        XCTAssertNotNil(crumbsTableViewModel.cellModels, "Cell Models Array should be filled after fetch")
//    }


}
