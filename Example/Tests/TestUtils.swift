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
        let testExpectation = expectation(description: "GET request")
        stub(uri(uriTemplate)) { (request) -> (Response) in
            if let responseValue = getQueryStringParameter(url: request.url!.absoluteString, param: paramName) {
                XCTAssertTrue(expectedValue.isEqual(responseValue), "\(paramName) in REST request is \(responseValue), but should be equal to \(expectedValue)")
            } else {
                XCTFail("\(paramName) was not present in REST request")
            }
            testExpectation.fulfill()
            return .success(HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, Download.noContent)
        }

        executionBlock()
        waitForExpectations(timeout: 4, handler: nil)
    }
    
}
