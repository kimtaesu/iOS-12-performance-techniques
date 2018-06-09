//
//  blog_ios12_performanceUITests.swift
//  blog-ios12-performanceUITests
//
//  Created by ttillage on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import XCTest

class blog_ios12_performanceUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }
    
    func testApplicationLaunchPerformance() {
        self.measure {
            XCUIApplication().launch()
            XCTAssertTrue(XCUIApplication().navigationBars["Top Headlines"].waitForExistence(timeout: 10.0))
        }
    }
}
