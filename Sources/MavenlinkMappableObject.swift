//
//  MavenlinkMappableObject.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import ObjectMapper

public class MavenlinkObject: Mappable, CustomStringConvertible {
    static var _mappingObject: MavenlinkObject?
    class func mappingObject() -> MavenlinkObject {
        if (_mappingObject == nil) {
            _mappingObject = self.init()
        }
        return _mappingObject!
    }

    required public init() {}
    required public init?(_ map: Map) { }

    public func mapping(map: Map) {
        preconditionFailure("This method must be overridden")
    }

    public class func resourceName() -> String {
        preconditionFailure("This method must be overridden")
    }

    public var description: String {
        get {
            guard let string = self.toJSONString() else { return "JSON error" }
            return string
        }
    }

//    public static func objectForMapping(map: Map) -> Mappable? {
//        return self.mappingObject()
//    }
}
