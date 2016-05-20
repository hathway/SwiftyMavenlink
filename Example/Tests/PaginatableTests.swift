//
//  PaginatableTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import SwiftyMavenlink

class PaginatableTests: XCTestCase {

    let resource = "test"
    let perPage = 50

    var testObject: PagedResultSet<TestClass>?

    override func setUp() {
        super.setUp()

        let params: MavenlinkQueryParams = [ "TestQuery" : "TestThing"]
        testObject = PagedResultSet<TestClass>(resource: resource, itemsPerPage: perPage, params: params)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDictionaryAddition() {
        var destDict = [
            "key1": "value1",
            "key2": "value2"
        ]

        let otherDict = [
            "key3": "value3",
            "key4": "value4"
        ]

        var testResultDict = destDict
        otherDict.forEach { key, value in testResultDict[key] = value }

        destDict += otherDict
        XCTAssertEqual(destDict, testResultDict)
    }

    func testAppendingQueryParams() {
        
    }

    func testInitializePaginatableResult() {
        XCTAssertNotNil(testObject)
        XCTAssertEqual(testObject?.resource, resource)
        XCTAssertNotNil(testObject?.queryParams)
    }
    
}
