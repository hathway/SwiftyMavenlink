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
        self.setUpFixtures(WorkspaceGroup)
    }

    func testMapping() {
        let jsonText = self.singleJsonFixture(WorkspaceGroup)
        let result = Mapper<WorkspaceGroup>().map(jsonText)!
        let message = "No properties should be nil, mapping test data should always succeed"
        XCTAssertNotNil(result.id, message)
        XCTAssertNotNil(result.name, message)
        XCTAssertNotNil(result.company, message)
    }

    func testGetSpecific() {
        let id = 12345
        let param = GenericParams.Only(id).queryParam().first!.0
        setupQueryParamTestExpectation(param, expectedValue: String(id), uriTemplate: uriPath(WorkspaceGroup)) {
            WorkspaceGroupService.getSpecific(id)
        }
    }
}