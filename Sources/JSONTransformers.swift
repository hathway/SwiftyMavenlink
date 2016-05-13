//
//  JSONTransformers.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

public enum MavenlinkDateFormat: String {
    case Short = "YYYY-MM-dd"
    case Long = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
}

public class MavenlinkDateTransform: TransformType {
    public typealias Object = NSDate
    public typealias JSON = String

    private var formatter: NSDateFormatter

    public init(format: MavenlinkDateFormat) {
        formatter = NSDateFormatter()
        formatter.dateFormat = format.rawValue
    }

    public func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let timeStr = value as? String {
            return formatter.dateFromString(timeStr)
        }
        return nil
    }

    public func transformToJSON(value: NSDate?) -> String? {
        if let date = value {
            return formatter.stringFromDate(date)
        }
        return nil
    }
}

let ShortDateFormatter = MavenlinkShortDateTransform()
let LongDateFormatter = MavenlinkLongDateTransform()
let IntFormatter = NumericalStringConverter()

public class MavenlinkShortDateTransform: MavenlinkDateTransform {
    init() {
        super.init(format: .Short)
    }
}

public class MavenlinkLongDateTransform: MavenlinkDateTransform {
    init() {
        super.init(format: .Long)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone(abbreviation: "GMT")
    }
}

public class NumericalStringConverter: TransformType {
    public typealias Object = Int
    public typealias JSON = String
    public init() {}
    public func transformFromJSON(value: AnyObject?) -> Object? {
        return value?.integerValue
    }
    public func transformToJSON(value: Object?) -> JSON? {
        return String(value)
    }
}