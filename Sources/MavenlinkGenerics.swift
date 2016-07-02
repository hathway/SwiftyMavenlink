//
//  MavenlinkGenerics.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

enum GenericParams: RESTApiParams {
    case Only(_: Int)
    case Search(_: String)

    var paramName: String {
        get {
            switch(self) {
            case .Only:
                return "only"
            case .Search:
                return "search"
            }
        }
    }

    var queryParam: MavenlinkQueryParams {
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

public protocol MavenlinkResource {
    static var resourceName: String { get }
}