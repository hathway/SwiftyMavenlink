//
//  MavenlinkGenerics.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public enum GenericParams: RESTApiParams {
    case Only(_: Int)
    case Search(_: String)

    public var paramName: String {
        get {
            switch(self) {
            case .Only:
                return "only"
            case .Search:
                return "search"
            }
        }
    }

    public var queryParam: MavenlinkQueryParams {
        get {
            let value: AnyObject
            switch(self) {
            case .Only(let id):
                value = id
            case .Search(let searchString):
                value = searchString
            }
            return [self.paramName: value]
        }
    }
}

public protocol RESTApiParams {
    var queryParam: MavenlinkQueryParams { get }
    var paramName: String { get }
}

func paramsReducer(accumulator: MavenlinkQueryParams, current: RESTApiParams) -> MavenlinkQueryParams {
    var new = accumulator
    new += current.queryParam
    return new
}

public protocol MavenlinkResource: Hashable {
    var id: Int? { get }
    static var resourceName: String { get }
}