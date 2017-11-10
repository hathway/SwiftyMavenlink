//
//  MavenlinkGenerics.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

enum GenericParams: RESTApiParams {
    case only(_: Int)
    case search(_: String)

    var paramName: String {
        get {
            switch(self) {
            case .only:
                return "only"
            case .search:
                return "search"
            }
        }
    }

    var queryParam: MavenlinkQueryParams {
        get {
            let value: AnyObject
            switch(self) {
            case .only(let id):
                value = id as AnyObject
            case .search(let searchString):
                value = searchString as AnyObject
            }

            return [self.paramName: value]
        }
    }
}

public protocol RESTApiParams {
    var queryParam: MavenlinkQueryParams { get }
    var paramName: String { get }
}

func paramsReducer(_ accumulator: MavenlinkQueryParams, current: RESTApiParams) -> MavenlinkQueryParams {
    var new = accumulator
    new += current.queryParam
    return new
}

public protocol MavenlinkResource {
    static var resourceName: String { get }
}
