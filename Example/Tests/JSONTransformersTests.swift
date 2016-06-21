//
//  JSONTransformersTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/31/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import ObjectMapper

func testBlock<U:Equatable, T:TransformType where T.Object == U, T.JSON == String>(testObject: U?, testString: String?, transformObject: T) {

    let stringRepresentation = transformObject.transformToJSON(testObject)
    let objectRepresentation = transformObject.transformFromJSON(stringRepresentation)

    XCTAssertEqual(testString, stringRepresentation)
    XCTAssertEqual(testObject, objectRepresentation)

    XCTAssertNil(transformObject.transformToJSON(nil))
    XCTAssertNil(transformObject.transformFromJSON(nil))
}

class JSONTransformersTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShortDateTransform() {
        let testDate = NSDate(timeIntervalSince1970: 0)
        let testString = "1970-01-01"
        testBlock(testDate, testString: testString, transformObject: ShortDateFormatter)
    }

    func testLongDateTransform() {
        let testDate = NSDate(timeIntervalSince1970: 0)
        let testString = "1970-01-01T00:00:00GMT"
        testBlock(testDate, testString: testString, transformObject: LongDateFormatter)
    }
    
}
