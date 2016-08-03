//
//  Service.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

public class MavenlinkResourceService<T where T:MavenlinkResultSet, T:Mappable> {
    public typealias Resource = T

    public class func get(params: [RESTApiParams] = []) -> PagedResultSet<T> {
        return PagedResultSet<T>(resource: T.Result.resourceName, params: params)
    }

    public class func getSpecific(id: Int, params: [RESTApiParams] = []) -> T? {
        var finalParams: [RESTApiParams] = params
        finalParams.append(GenericParams.Only(id))
        return PagedResultSet<T>(resource: T.resourceName,
                                 params: finalParams).getNextPage()
    }

    public class func search(term: String, extraParams: [RESTApiParams] = []) -> PagedResultSet<T> {
        var finalParams = extraParams
        finalParams.append(GenericParams.Search(term))
        return PagedResultSet<T>(resource: T.resourceName, params: finalParams)
    }
}