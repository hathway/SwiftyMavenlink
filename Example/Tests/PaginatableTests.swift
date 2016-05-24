//
//  PaginatableTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import SwiftyMavenlink
import ObjectMapper

class PaginatableTests: SwiftyMavenlinkTestBase {

    let resource = "workspaces"
    let perPage = 10

    var testObject: PagedResultSet<WorkspaceTestClass>?

    override func setUp() {
        super.setUp()

        let params: MavenlinkQueryParams = [ "TestQuery" : "TestThing"]
        testObject = PagedResultSet<WorkspaceTestClass>(resource: resource, itemsPerPage: perPage, params: params)
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

    func testInitializePaginatableResult() {
        XCTAssertNotNil(testObject)
        XCTAssertEqual(testObject?.resource, resource)
        XCTAssertNotNil(testObject?.queryParams)
    }

    func testPageChanges() {
        var pages: [[WorkspaceTestClass]] = []
        while let currentPage = testObject?.getNextPage() {
            pages.append(currentPage)
        }

        var count = pages.count
        while let currentPage = testObject?.getPrevPage() {
            count -= 1
            XCTAssertEqual(currentPage.map { $0.entityId! }, pages[count].map { $0.entityId! })
        }

        XCTAssert(count == 0, "Page count should be 0 after iterating through all pages")
    }
    
}

public struct WorkspaceTestClass: Mappable {
    public var entityId: Int?
    public var name: String?

    public init?(_ map: Map) { }

    mutating public func mapping(map: Map) {
        entityId <- (map["id"], IntFormatter)
        name <- map["name"]
    }
}
