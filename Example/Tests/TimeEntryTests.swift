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

class TimeEntryTests: SwiftyMavenlinkTestBase {
    
    override func setUp() {
        super.setUp()

        let path = NSBundle(forClass: self.dynamicType).pathForResource("TimeEntries", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let dataPages = JSON(data: data).arrayObject!

        stub(uri("/api/v1/time_entries.json")) { (request) -> (Response) in
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
    
    func testTimeEntryGet() {
        let result = TimeEntryService.get(nil, startDate: nil, endDate: nil)
        let firstPage = try? result.getItems(1)
        XCTAssertNotNil(result, "Result set should not be empty")
        XCTAssertNotNil(firstPage)
        let secondPage = result.getNextPage()
    }

}
