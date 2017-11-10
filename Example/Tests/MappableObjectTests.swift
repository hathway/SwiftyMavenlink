//
//  MappableObjectTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import ObjectMapper

class MapableObjectTests: XCTestCase {
    let JsonStringTest: String = "{\"TestProperty\":\"TestValue\"}"
    var mappingResult: TestClass?

    override func setUp() {
        super.setUp()
        mappingResult = Mapper<TestClass>().map(JSONString: JsonStringTest)
    }

    override func tearDown() {
        super.tearDown()
        mappingResult = nil
    }

    func testSimpleObjectMapping() {
        XCTAssertNotNil(mappingResult)
        XCTAssert(mappingResult?.testProperty == "TestValue", "Property should equal value in JSON")
        XCTAssertNil(mappingResult?.otherProperty)
    }

    func testStringDescription() {
        XCTAssertEqual((mappingResult!.toJSONString()), JsonStringTest)
    }
}

struct TestClass: Mappable {
    var testProperty: String?
    var otherProperty: String?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        testProperty <- map["TestProperty"]
    }
}
