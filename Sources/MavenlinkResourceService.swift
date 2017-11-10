//
//  Service.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper



open class MavenlinkResourceService<T> where T:MavenlinkResource, T:Mappable {
    public typealias Resource = T

    open class func get(_ params: [RESTApiParams] = []) -> PagedResultSet<T> {
        return PagedResultSet<T>(resource: T.resourceName, params: params)
    }

    open class func getSpecific(_ id: Int, params: [RESTApiParams] = []) -> T? {
        var finalParams: [RESTApiParams] = params
        finalParams.append(GenericParams.only(id))
        return PagedResultSet<T>(resource: T.resourceName,
                                 params: finalParams).getNextPage()?.first
    }

    open class func search(_ term: String, extraParams: [RESTApiParams] = []) -> PagedResultSet<T> {
        var finalParams = extraParams
        finalParams.append(GenericParams.search(term))
        return PagedResultSet<T>(resource: T.resourceName, params: finalParams)
    }
}
