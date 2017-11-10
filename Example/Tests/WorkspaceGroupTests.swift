//
//  WorkspaceGroupTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import ObjectMapper

class WorkspaceGroupTests: SwiftyMavenlinkTestBase {

    override func setUp() {
        super.setUp()
        self.setUpFixtures(testClass: WorkspaceGroup.self)
    }

    func testMapping() {
        let jsonText = self.singleJsonFixture(testClass: WorkspaceGroup.self)
        let result = Mapper<WorkspaceGroup>().map(JSONString: jsonText)!
        let message = "No properties should be nil, mapping test data should always succeed"
        XCTAssertNotNil(result.id, message)
        XCTAssertNotNil(result.name, message)
        XCTAssertNotNil(result.company, message)
        XCTAssertNotNil(result.workspace_ids, message)
    }

    func testGetSpecific() {
        let id = 12345
        let param = GenericParams.only(id).queryParam.first!.0
        setupQueryParamTestExpectation(paramName: param, expectedValue: String(id) as AnyObject, uriTemplate: uriPath(testClass: WorkspaceGroup)) {
            WorkspaceGroupService.getSpecific(id)
        }
    }
}
