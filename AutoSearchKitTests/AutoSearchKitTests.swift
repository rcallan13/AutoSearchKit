//
//  AutoSearchKitTests.swift
//  AutoSearchKitTests
//
//  Created by Ron Allan on 2019-02-15.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import XCTest
@testable import AutoSearchKit

class AutoSearchKitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParser() {
        let manager = AutoSearchManager()
        assert(manager.autoSearchParams != nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
