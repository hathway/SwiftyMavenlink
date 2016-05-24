//
//  MavenlinkMappableObject.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import ObjectMapper

public class MavenlinkObject<T:Mappable>: CustomStringConvertible {
    required public init() {}
    required public init?(_ map: Map) { }

    public var description: String {
        get {
//            guard let string = self.toJSONString() else { return "JSON error" }
//            return string
            return "test"
        }
    }

//    public static func objectForMapping(map: Map) -> Mappable? {
//        return self.mappingObject()
//    }
}
