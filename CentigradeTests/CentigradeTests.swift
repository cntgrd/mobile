//
//  CentigradeTests.swift
//  CentigradeTests
//
//  Created by Paul Herz on 2017-10-31.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import XCTest
@testable import Centigrade

class CentigradeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		print("A dummy test for Travis infrastructure testing")
		XCTAssert(true)
    }
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
