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

open class MavenlinkDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String

    fileprivate(set) var formatter: DateFormatter

    public init(format: MavenlinkDateFormat) {
        formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone(abbreviation: "GMT")
    }

    open func transformFromJSON(_ value: Any?) -> Date? {
        if let timeStr = value as? String {
            return formatter.date(from: timeStr)
        }
        return nil
    }

    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return formatter.string(from: date)
        }
        return nil
    }
}

let ShortDateFormatter = MavenlinkShortDateTransform()
let LongDateFormatter = MavenlinkLongDateTransform()
let IntFormatter = NumericalStringConverter()
let IntArrayFormatter = NumericalArrayConverter()
let URLFormatter = URLTransform()

open class MavenlinkShortDateTransform: MavenlinkDateTransform {
    init() {
        super.init(format: .Short)
    }
}

open class MavenlinkLongDateTransform: MavenlinkDateTransform {
    init() {
        super.init(format: .Long)
        formatter.locale = Locale(identifier: "en_US_POSIX")
    }
}

open class NumericalArrayConverter: TransformType {
    public typealias Object = [Int]
    public typealias JSON = [String]
    public init() {}
    open func transformFromJSON(_ value: Any?) -> Object? {
        guard let array = value as? [String] else { return [] }
        var numArray: [Int] = []
        array.forEach { value in
            if let int = Int(value) {
                numArray.append(int)
            }
        }
        return numArray
    }
    open func transformToJSON(_ value: Object?) -> JSON? {
        return value?.map { String($0) }
    }
}

open class NumericalStringConverter: TransformType {
    public typealias Object = Int
    public typealias JSON = String
    public init() {}
    open func transformFromJSON(_ value: Any?) -> Object? {
        if let intValue = value as? Int {
            return intValue
        }
        guard let stringValue = value as? String else { return nil }
        guard let intValue = Int(stringValue) else { return nil }
        return intValue
    }
    open func transformToJSON(_ value: Object?) -> JSON? {
        return String(describing: value)
    }
}

open class URLTransform: TransformType {
    public typealias Object = URL
    public typealias JSON = String
    public init() {}
    open func transformFromJSON(_ value: Any?) -> Object? {
        guard let urlString = value as? String else { return nil }
        return URL(string: urlString)
    }
    open func transformToJSON(_ value: Object?) -> JSON? {
        return String(describing: value)
    }
}

extension Array {
    func toJSONString() -> String {
        return self.reduce("") { $0 + "," + String(describing: $1) }
    }
}
