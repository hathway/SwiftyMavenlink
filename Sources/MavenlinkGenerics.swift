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

    func paramName() -> String {
        switch(self) {
        case .Only:
            return "only"
        case .Search:
            return "search"
        }
    }

    func queryParam() -> MavenlinkQueryParams {
        let value: AnyObject
        switch(self) {
        case .Only(let id):
            value = id
        case .Search(let searchString):
            value = searchString
        }

        return [self.paramName(): value]
    }
}

public protocol RESTApiParams {
    func queryParam() -> MavenlinkQueryParams
}

public protocol MavenlinkResource {
    static var resourceName: String { get }
}