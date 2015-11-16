//
//  AppDelegateTests.swift
//  Crumbs
//
//  Created by Daniel on 11/16/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import XCTest
import Swinject

@testable import Crumbs

class AppDelegateTests: XCTestCase {
    
    var container: Container!

    override func setUp() {
        super.setUp()
        container = AppDelegate().container
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testContainerResolvesCBNetworking() {
        XCTAssertNotNil(container.resolve(CBNetworking.self), "The container should be able to resolve CBNetworking")
    }
    
    func testContainerResolvesCBCrumbFetching() {
        XCTAssertNotNil(container.resolve(CBCrumbFetching.self), "The container should be able to resolve CBCrumbFetching")
    }
    
    func testContainerResolvesCBCrumbsTableViewModeling() {
        XCTAssertNotNil(container.resolve(CBCrumbsTableViewModeling.self), "The container should be able to resolve CBCrumbsTableViewModeling")
    }
    
    func testContainerInjectsViewModelsToViews() {
        
        let bundle = NSBundle(forClass: CBCrumbsTableViewController.self)
        let storyboard = SwinjectStoryboard.create(
            name: "Main",
            bundle: bundle,
            container: container)
        let crumbsTableViewController = storyboard.instantiateViewControllerWithIdentifier("CBCrumbsTableViewController") as! CBCrumbsTableViewController
        
        XCTAssertNotNil(crumbsTableViewController.viewModel, "The view model for CBCrumbsTableViewController should be initialized")
    }
}
