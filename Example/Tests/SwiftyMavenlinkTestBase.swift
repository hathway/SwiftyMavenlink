import UIKit
import XCTest
import SwiftyMavenlink

class SwiftyMavenlinkTestBase: XCTestCase {

    var oAuthToken = ""
    
    override func setUp() {
        super.setUp()
        let bundle = NSBundle(forClass: SwiftyMavenlinkTestBase.self)
        if let path = bundle.pathForResource("Config", ofType: "plist") {
            if let config = NSDictionary(contentsOfFile: path) as? [String : AnyObject] {
                oAuthToken = config["oAuthToken"] as? String ?? ""
                MavenlinkSession.instance.configure(oAuthToken)
            }
        }
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
