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

    override func setUp() {
        super.setUp()
        self.setUpFixtures(testClass: Users.self)
    }

    func testTimeEntryDataMapping() {
        let jsonText = self.singleJsonFixture(testClass: Users.self)
        let result = Mapper<Users>().map(JSONString: jsonText)!
        let message = "No properties should be nil, mapping test data should always succeed"
        XCTAssertNotNil(result.full_name, message)
        XCTAssertNotNil(result.photo_path, message)
        XCTAssertNotNil(result.email_address, message)
        XCTAssertNotNil(result.headline, message)
        XCTAssertNotNil(result.account_id, message)
        XCTAssertNotNil(result.id, message)
    }

    func testGetUser() {
        let ids = [12345, 67890]
        let enumObj = Users.Params.specificUsers(userIds: ids)
        let param = enumObj.queryParam.first!.0
        setupQueryParamTestExpectation(paramName: param, expectedValue: ids.toJSONString() as AnyObject, uriTemplate: uriPath(testClass: Users.self)) {
           _ = UserService.getSpecificUsers(ids).getNextPage()
        }
    }

    func testGetUserList() {
        let id = 5725577
        let param = GenericParams.only(id).queryParam.first!.0
        setupQueryParamTestExpectation(paramName: param, expectedValue: String(id) as AnyObject, uriTemplate: uriPath(testClass: Users.self)) {
            _ = UserService.getSpecific(id)
        }
    }

}
