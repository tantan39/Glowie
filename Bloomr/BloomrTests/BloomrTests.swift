//
//  BloomrTests.swift
//  BloomrTests
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import XCTest
@testable import Bloomr

class BloomrTests: XCTestCase {
    var mainContest: Contest!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mainContest = Contest(json: [:])
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.mainContest = nil
    }

    func testContest() {
        self.mainContest.category = 1
        self.mainContest.itemNumbers = 3
        XCTAssertEqual(self.mainContest.contestType, ContestItemType.country)
        XCTAssertEqual(self.mainContest.itemNumbers, 3)
        XCTAssertEqual(self.mainContest.contestFormat, ContestItemFormatType.audio)
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
