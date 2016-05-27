//
//  TestUtils.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import Mockingjay

func getQueryStringParameter(url: String, param: String) -> String? {

    guard let url = NSURLComponents(string: url) else { return nil }
    guard let queryItems = url.queryItems else { return nil }

    return queryItems.filter({ (item) in item.name == param }).first?.value

}

extension XCTestCase {

    func setupQueryParamTestExpectation(paramName: String, expectedValue: AnyObject, uriTemplate: String, executionBlock: () -> Void) {
        let expectation = expectationWithDescription("GET request")
        stub(uri(uriTemplate)) { (request) -> (Response) in
            if let responseValue = getQueryStringParameter(request.URL!.absoluteString, param: paramName) {
                XCTAssertTrue(expectedValue.isEqual(responseValue), "\(paramName) in REST request is \(responseValue), but should be equal to \(expectedValue)")
            } else {
                XCTFail("\(paramName) was not present in REST request")
            }
            expectation.fulfill()
            return .Success(NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!, NSData())
        }

        executionBlock()
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}