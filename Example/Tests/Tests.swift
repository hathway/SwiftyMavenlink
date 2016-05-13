import UIKit
import XCTest
//import Pods_SwiftyMavenlink_Tests
import SwiftyMavenlink

class Tests: XCTestCase {

    var oAuthToken = ""
    
    override func setUp() {
        super.setUp()
        let bundle = NSBundle(forClass: Tests.self)
        if let path = bundle.pathForResource("Config", ofType: "plist") {
            if let config = NSDictionary(contentsOfFile: path) as? [String : AnyObject] {
                oAuthToken = config["oAuthToken"] as? String ?? ""
                try! MavenlinkSession.instance.configure(oAuthToken)
            }
        }
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigNotEmpty() {
        let session = MavenlinkSession.instance
        XCTAssertNotEqual(session.oAuthToken, "")
    }

    func testTimeEntryGet() {
        let result = TimeEntryService.get(nil, startDate: nil, endDate: nil)
        XCTAssertNotNil(result, "Result set should not be empty")
        let firstPage = result.getPage(0)
        XCTAssertNotNil(firstPage)
        let secondPage = result.getNextPage()
    }

    func testWorkspacesGet() {
        let result = WorkspaceService.get()
        XCTAssertNotNil(result, "Result set should not be empty")
        let firstPage = result.getPage(0)
        XCTAssertNotNil(firstPage)
        let secondPage = result.getNextPage()
    }
}
