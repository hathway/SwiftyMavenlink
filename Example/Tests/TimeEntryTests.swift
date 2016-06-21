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
        let dataPages = JSON(data: self.fullJson(TimeEntry)).arrayObject!

        stub(uri(uriPath(TimeEntry))) { (request) -> (Response) in
            let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!

            guard let page = getQueryStringParameter(request.URL!.absoluteString, param: "page"),
                pageNum = Int(page) else {
                    let responseData = try! NSJSONSerialization.dataWithJSONObject(dataPages[0], options: NSJSONWritingOptions())
                    return .Success(response, responseData)
            }

            let responseData = try! NSJSONSerialization.dataWithJSONObject(dataPages[pageNum], options: NSJSONWritingOptions())
            return .Success(response, responseData)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeEntryDataMapping() {
        let singleJson = singleJsonFixture(TimeEntry)
        let result = Mapper<TimeEntry>().map(singleJson)!
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
        let workspaceId = "9999"
        setupQueryParamTestExpectation(TimeEntry.Params.WorkspaceId.rawValue, expectedValue: workspaceId, uriTemplate: uriPath(TimeEntry)) {
            TimeEntryService.get(workspaceId).getNextPage()
        }
    }

    func testGet_TimeParameters() {
        let startTime = NSDate(timeIntervalSinceNow: -(60*60*24*7)), endTime = NSDate()
        let expectedValue = ShortDateFormatter.transformToJSON(startTime)! + "%3A" + ShortDateFormatter.transformToJSON(endTime)!
        setupQueryParamTestExpectation(TimeEntry.Params.BetweenDate.rawValue, expectedValue: expectedValue, uriTemplate: uriPath(TimeEntry)) {
            TimeEntryService.get(startDate: startTime, endDate: endTime).getNextPage()
        }
    }
}
