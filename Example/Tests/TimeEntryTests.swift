//
//  TimeEntryTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Mockingjay
import URITemplate
import SwiftyJSON
import ObjectMapper

class TimeEntryTests: SwiftyMavenlinkTestBase {

    override func setUp() {
        super.setUp()
        guard let dataPages = try? JSON(data: self.fullJson(testClass: TimeEntry.self)).arrayObject! else { return }

        stub(uri(uriPath(testClass: TimeEntry.self))) { (request) -> (Response) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!

            guard let page = getQueryStringParameter(url: request.url!.absoluteString, param: "page"),
                let pageNum = Int(page) else {
                    let responseData = try! JSONSerialization.data(withJSONObject: dataPages[0], options: JSONSerialization.WritingOptions())
                    return .success(response, Download.content(responseData))
            }

            let responseData = try! JSONSerialization.data(withJSONObject: dataPages[pageNum], options: JSONSerialization.WritingOptions())
            return .success(response, Download.content(responseData))
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeEntryDataMapping() {
        let singleJson = singleJsonFixture(testClass: TimeEntry.self)
        let result = Mapper<TimeEntry>().map(JSONString: singleJson)!
        let message = "No properties should be nil, mapping test data should always succeed"
        XCTAssertNotNil(result.id, message)
        XCTAssertNotNil(result.created_at, message)
        XCTAssertNotNil(result.updated_at, message)
        XCTAssertNotNil(result.date_performed, message)
        XCTAssertNotNil(result.story_id, message)
        XCTAssertNotNil(result.time_in_minutes, message)
        XCTAssertNotNil(result.billable, message)
        XCTAssertTrue(result.notes != nil, message)
        XCTAssertNotNil(result.rate_in_cents, message)
        XCTAssertNotNil(result.currency, message)
        XCTAssertNotNil(result.currency_symbol, message)
        XCTAssertNotNil(result.currency_base_unit, message)
        XCTAssertNotNil(result.user_can_edit, message)
        XCTAssertNotNil(result.taxable, message)
        XCTAssertNotNil(result.workspace_id, message)
        XCTAssertNotNil(result.user_id, message)
        XCTAssertNotNil(result.approved, message)
    }

    func testGet_WorkspaceParameter() {
        let workspaceId = 9999
        let param = TimeEntry.Params.workspaceId(id: workspaceId)
        setupQueryParamTestExpectation(paramName: param.paramName, expectedValue: String(workspaceId) as AnyObject, uriTemplate: uriPath(testClass: TimeEntry.self)) {
            TimeEntryService.get([param]).getNextPage()
        }
    }

    func testGet_TimeParameters() {
        let startTime = NSDate(timeIntervalSinceNow: -(60*60*24*7)), endTime = NSDate()
        let expectedValue = ShortDateFormatter.transformToJSON(startTime as Date)! + ":" + ShortDateFormatter.transformToJSON(endTime as Date)!
        let param = TimeEntry.Params.betweenDate(start: startTime as Date, end: endTime as Date)
        setupQueryParamTestExpectation(paramName: param.paramName, expectedValue: expectedValue as AnyObject, uriTemplate: uriPath(testClass: TimeEntry.self)) {
            TimeEntryService.get([param]).getNextPage()
        }
    }
}
