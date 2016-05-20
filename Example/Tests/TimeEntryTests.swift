//
//  TimeEntryTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

class TimeEntryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeEntryGet() {
        let result = TimeEntryService.get(nil, startDate: nil, endDate: nil)
        let firstPage = try? result.getPage(1)
        XCTAssertNotNil(result, "Result set should not be empty")
        XCTAssertNotNil(firstPage)
        let secondPage = result.getNextPage()
    }

}
