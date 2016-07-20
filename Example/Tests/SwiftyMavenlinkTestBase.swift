import UIKit
import XCTest
import SwiftyMavenlink
import Mockingjay
import ObjectMapper

class SwiftyMavenlinkTestBase: XCTestCase {
    var oAuthToken = ""
    
    func uriPath<T: MavenlinkResource>(testClass: T.Type) -> String {
        return  "/api/v1/\(testClass.resourceName).json"
    }

    func singleJsonFixture<T: MavenlinkResource>(testClass: T.Type) -> String {
        let path = NSBundle(forClass: SwiftyMavenlinkTestBase.self).pathForResource("\(testClass.resourceName)_single", ofType: "json")!
        return try! String(contentsOfFile: path)
    }

    func fullJson<T: MavenlinkResource>(testClass: T.Type) -> NSData {
        let path = NSBundle(forClass: SwiftyMavenlinkTestBase.self).pathForResource(testClass.resourceName, ofType: "json")!
        return NSData(contentsOfFile: path)!
    }

    func setUpFixtures<T: MavenlinkResource>(testClass: T.Type) {
        stub(uri(self.uriPath(testClass)), builder: jsonData(fullJson(testClass)))
    }

    override func setUp() {
        super.setUp()
        // For testing purposes
        MavenlinkSession.instance.configure("testoath1234")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigNotEmpty() {
        let session = MavenlinkSession.instance
        XCTAssertNotNil(session, "")
    }
}
