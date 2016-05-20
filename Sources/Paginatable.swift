//
//  Paginatable.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper
import JSONRequest
import Async

func +=<K, V> (inout left: [K : V], right: [K : V]) {
    for (k, v) in right {
        left[k] = v
    }
}

public enum PaginationError: ErrorType {
    case NoData
    case ParseError
    case OutOfRange
}

public enum PaginationParams: String {
    case Limit = "limit"
    case Offset = "offset"
    case Page = "page"
    case PerPage = "per_page"
}

protocol Paginatable {
    associatedtype ResultType

        /// Defines the REST resource for the class.
    var resource: String { get }
        /// The total item count for all items of the request, regardless of whether they've been fetched yet.
    var totalItemCount: Int { get }

    func getNextPage() -> [ResultType]?
    func getPrevPage() -> [ResultType]?
}

public struct Results<T:Mappable> {
    var items: [T]?
    var totalCount: Int?
}

public class MavenlinkResponse<T:Mappable>: Paginatable, CustomStringConvertible {
    typealias ResultType = T
    public typealias CompletionBlock = (([T]?, PaginationError?) -> Void)

    private var _totalItemCount: Int?
    public var totalItemCount: Int {
        get {
            assert(_totalItemCount != nil,
                   "totalItemCount cannot be accessed until results have been fetched")
            return _totalItemCount!
        }
    }

    private var _perPage: Int
    private var _currentPage: Int?
    private var _maxPage: Int {
        get {
            guard let total = _totalItemCount else { return NSIntegerMax }
            return Int(ceil(Double(total) / Double(_perPage)))
        }
    }

    private var _resource: String
    public var resource: String { get { return _resource } }

    private var _queryParams: MavenlinkQueryParams
    public var queryParams: MavenlinkQueryParams? { get { return _queryParams } }

    private var _resultsCache: [Int: [T]] = [:]

    public var description: String {
        get {
            return "\(resource): resultType=\(ResultType.self); totalCount=\(totalItemCount); currentPage=\(_currentPage);"
        }
    }

    init(resource: String, itemsPerPage: Int? = 100, params: MavenlinkQueryParams? = nil) {
        _resource = resource
        _perPage = itemsPerPage!
        _queryParams = params ?? [:]
    }

    // MARK: Caching

    private func addItemsToCache(page: Int, items: [T]) {
        _resultsCache[page] = items
    }

    private func getCacheForPage(page: Int) -> [T]? {
        return _resultsCache[page]
    }

    // MARK: Private methods

    private func parseResult(result: JSONResult, addToCache: Bool = false) -> Results<T>? {
        var totalItemCount = 0
        var parsedItems: [T] = []

        guard let data = result.data as? NSDictionary else { return nil }

        if let count = data["count"] as? Int {
            totalItemCount = count
        }

        if let items = data[resource] as? NSDictionary {
            if let mappedItems = Mapper<T>().mapArray(items.map { $0.value })
                where mappedItems.count != 0 {
                parsedItems = mappedItems
            }
        }

        return Results(items: parsedItems, totalCount: totalItemCount)
    }

    private func queryParamsAppendedWith(params: MavenlinkQueryParams) -> MavenlinkQueryParams {
        guard queryParams != nil else { return params }
        var result: MavenlinkQueryParams = params
        result += queryParams!
        return result
    }

    private func get(limit: Int = 1, offset: Int = 0) -> Results<T>? {
        let params: MavenlinkQueryParams = [
            PaginationParams.Offset.rawValue: offset,
            PaginationParams.Limit.rawValue: limit
        ]
        let response = MavenlinkSession.instance.get(resource + ".json", params: queryParamsAppendedWith(params))
        return parseResult(response)
    }

    internal func getPage(page: Int) throws -> Results<T>? {
        guard page > 0 && page < _maxPage else { return nil }

        if let cachedResults = getCacheForPage(page) {
            return Results<T>(items: cachedResults, totalCount: _totalItemCount)
        }

        let params = queryParamsAppendedWith( [
            PaginationParams.Page.rawValue: page,
            PaginationParams.PerPage.rawValue: _perPage
            ]
        )

        let result = MavenlinkSession.instance.get(resource + ".json", params: params)
        let results = self.parseResult(result)

        if (_totalItemCount == nil) {
            _totalItemCount = results?.totalCount
        }

        if let items = results?.items {
            addItemsToCache(page, items: items)
        }
        return results
    }

    // MARK: Public functions

    public func getNextPage() -> [T]? {
        let nextPage: Int
        if let page = _currentPage {
            nextPage = page + 1
        } else {
            nextPage = 1
        }

        let results: Results<T>?
        do {
            try results = getPage(nextPage)
            _currentPage = nextPage
        } catch {
            results = nil
        }
        return results?.items
    }

    public func getPrevPage() -> [T]? {
        let prevPage: Int
        if let page = _currentPage where page != 0 {
            prevPage = page - 1
        } else {
            prevPage = 1
        }

        let results: Results<T>?
        do {
            try results = getPage(prevPage)
            _currentPage = prevPage
        } catch {
            results = nil
        }
        return results?.items
    }

    public func preloadData(completion: CompletionBlock) {
        // Get total count so we can parallelize the rest of the fetching
        guard let result = get(1, offset: 0) else { return completion(nil, .NoData) }
        guard let totalCount = result.totalCount else { return completion(nil, .ParseError) }
        _totalItemCount = totalCount

        var allItems: [T] = []
        let group = AsyncGroup()
        (1..<_maxPage+1).forEach {i in
            group.background {
                guard let page = try? self.getPage(i),
                    stuff = page?.items else { return }
                allItems.appendContentsOf(stuff)
            }
        }
        group.wait()

        completion(allItems, nil)
    }
}
