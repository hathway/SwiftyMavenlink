//
//  Service.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper



public class MavenlinkResourceService<T where T:MavenlinkResource, T:Mappable> {
    public typealias Resource = T

    public class func get(params: MavenlinkQueryParams? = nil) -> PagedResultSet<T> {
        return PagedResultSet<T>(resource: T.resourceName, params: params)
    }

    public class func getSpecific(id: Int) -> T? {
        return getSpecific(id, params: nil)
    }

    public class func getSpecific(id: Int, params: MavenlinkQueryParams? = nil) -> T? {
        var finalParams = (params ?? [:])
        finalParams += GenericParams.Only(id).queryParam
        return PagedResultSet<T>(resource: T.resourceName,
                                 params: finalParams).getNextPage()?.first
    }

    public class func search(term: String, extraParams: MavenlinkQueryParams? = nil) -> PagedResultSet<T> {
        var finalParams = (extraParams ?? [:])
        finalParams += GenericParams.Search(term).queryParam
        return PagedResultSet<T>(resource: T.resourceName, params: finalParams)
    }
}