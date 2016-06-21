//
//  UsersTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/17/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Mockingjay
import ObjectMapper

class UsersTests: SwiftyMavenlinkTestBase {

    func testTimeEntryDataMapping() {
        let jsonText = self.singleJsonFixture(Users)
        let result = Mapper<Users>().map(jsonText)!
        let message = "No properties should be nil, mapping test data should always succeed"
        XCTAssertNotNil(result.full_name, message)
        XCTAssertNotNil(result.photo_path, message)
        XCTAssertNotNil(result.email_address, message)
        XCTAssertNotNil(result.headline, message)
        XCTAssertNotNil(result.account_id, message)
        XCTAssertNotNil(result.id, message)
    }
}
