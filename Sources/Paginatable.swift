//
//  Paginatable.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

protocol Paginatable {
    associatedtype ResultType
    var resource: String { get set }
    var totalCount: Int { get set }
    var perPage: Int { get set }
    var currentPage: Int { get }
    func getNextPage() throws -> [ResultType]?
    func getPrevPage() throws -> [ResultType]?
}

public class MavenlinkResponse<T:Mappable>: Paginatable, CustomStringConvertible {
    typealias ResultType = T
    typealias CompletionBlock = (([T]) -> Void)

    var resource: String
    var totalCount: Int = 0
    var currentPage: Int = 0
    var perPage: Int = 0

    var queryParams: MavenlinkQueryParams?

    var resultsCache: [T] = []

    public var description: String {
        get {
            return "\(resource): resultType=\(ResultType.self); totalCount=\(totalCount); currentPage=\(currentPage);"
        }
    }

    init(resource: String, params: MavenlinkQueryParams? = nil) {
        self.resource = resource
        self.queryParams = params
    }

    func getPage(page: Int) -> [T]? {
        currentPage = page
        var params: MavenlinkQueryParams = (queryParams ?? [:])

        if (currentPage != 0) {
            params["page"] = currentPage
        }

        let result = MavenlinkSession.instance.get(resource + ".json", params: params)
        if let data = result.data as? NSDictionary {
            totalCount = data["count"] as! Int
            if let pageCount = data["time_entries"]?.allKeys.count {
                perPage = pageCount
            }
            if let items = data[resource] as? NSDictionary {
                return Mapper<T>().mapArray(items.map { $0.value })
            }
        }
        return []
    }

    func getNextPage() -> [T]? {
        return getPage(currentPage+1)
    }

    func getPrevPage() -> [T]? {
        return getPage(currentPage-1)
    }
}
