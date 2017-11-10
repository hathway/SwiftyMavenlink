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
import Mockingjay
import SwiftyJSON

class PaginatableTests: XCTestCase {

    let resource = "time_entries"
    let perPage = 200

    var testObject: PagedResultSet<TimeEntryTestClass>?

    override func setUp() {
        super.setUp()

        let path = Bundle(for: type(of: self)).path(forResource: "time_entries", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        guard let dataPages = try? JSON(data: data as Data).arrayObject! else { return }
        stub(uri("/api/v1/time_entries.json")) { (request) -> (Response) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!

            guard let page = getQueryStringParameter(url: request.url!.absoluteString, param: "page"),
                let pageNum = Int(page) else {
                    let responseData = try! JSONSerialization.data(withJSONObject: dataPages[0], options: JSONSerialization.WritingOptions())
                    return .success(response, Download.content(responseData))
            }

            let responseData = try! JSONSerialization.data(withJSONObject: dataPages[pageNum-1], options: JSONSerialization.WritingOptions())
            return .success(response, Download.content(responseData))
        }

        let params: [RESTApiParams] = [GenericParams.search("Testing 123")]
        testObject = PagedResultSet<TimeEntryTestClass>(resource: resource, itemsPerPage: perPage, params: params)

        // For testing purposes
        MavenlinkSession.instance.configure("testoath1234")
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
        var pages: [[TimeEntryTestClass]] = []
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

    func testPreloading() {
        
    }
    
}

public struct TimeEntryTestClass: Mappable {
    public var entityId: Int?
    public var name: String?

    public init?(map: Map) { }

    mutating public func mapping(map: Map) {
        entityId <- (map["id"], IntFormatter)
        name <- map["name"]
    }
}
