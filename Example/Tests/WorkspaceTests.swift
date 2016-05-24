//
//  WorkspaceTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Mockingjay

class WorkspaceTests: SwiftyMavenlinkTestBase {
    
    override func setUp() {
        super.setUp()

        let path = NSBundle(forClass: self.dynamicType).pathForResource("Workspaces", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(uri("/api/v1/workspaces.json"), builder: jsonData(data))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWorkspacesGet() {
        let result = WorkspaceService.get()
        let firstPage = try? result.getItems(1)
        XCTAssertNotNil(result, "Result set should not be empty")
        XCTAssertNotNil(firstPage)
        let secondPage = result.getNextPage()
    }

}
