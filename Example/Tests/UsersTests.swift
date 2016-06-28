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
        self.setUpFixtures(Users)
    }

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

    func testGetUser() {
        let ids = [12345, 67890]
        let param = Users.Params.SpecificUsers(userIds: ids).queryParam().first!.0
        setupQueryParamTestExpectation(param, expectedValue: ids.toJSONString(), uriTemplate: uriPath(Users)) {
            UserService.getSpecificUsers(ids).getNextPage()
        }
    }

    func testGetUserList() {
        let id = 5725577
        let param = GenericParams.Only(id).queryParam().first!.0
        setupQueryParamTestExpectation(param, expectedValue: String(id), uriTemplate: uriPath(Users)) {
            UserService.getSpecific(id)
        }
    }

}
