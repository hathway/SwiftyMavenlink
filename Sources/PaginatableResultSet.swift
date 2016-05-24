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

/**
 *  A protocol designed to make working with Paginated results easier
 */
protocol Paginatable {
    associatedtype ResultType

        /// Defines the REST resource for the class.
    var resource: String { get }
        /// The total item count for all items of the request, regardless of whether they've been fetched yet.
    var totalItemCount: Int { get }

    func getNextPage() -> [ResultType]?
    func getPrevPage() -> [ResultType]?
}

/**
 Errors that can be returned when making paginated requests

 - NoData:     No data was returned by the server for the requested resources
 - ParseError: A JSON parsing error was encountered
 - OutOfRange: The page or items that were requsted are outside the known range of results
 */
public enum PaginationError: ErrorType {
    case NoData
    case ParseError
    case OutOfRange
}

/** 
 The purpose of this generic class is to provide a standard interface for a paged result set in response to a particular REST API query. This class does a few key things on behalf of the consumer:
    - Abstracts away the need to keep track of concepts like the total result count, page count, and current page
    - Protects against requesting things that don't exist (i.e. getting the next page of results when the end has already been reached)
    - Makes dealing with paged results generic regardless of the specific resource being returned
    - Caches results that have already been fetched (by this instance only) and uses those results when re-requested by the consumer
 */
public class PagedResultSet<T:Mappable>: Paginatable, CustomStringConvertible {
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
            return "\(resource): resultType=\(ResultType.self); totalCount=\(_totalItemCount); currentPage=\(_currentPage);"
        }
    }

    init(resource: String, itemsPerPage: Int? = 100, params: MavenlinkQueryParams? = nil) {
        _resource = resource
        _perPage = itemsPerPage!
        _queryParams = params ?? [:]
    }


    // MARK: Public functions

    /**
     Gets the next known page of results

     - returns: Result set of the next page, or nil if none exist
     */
    public func getNextPage() -> [T]? {
        let nextPage: Int
        if let page = _currentPage {
            nextPage = page + 1
        } else {
            nextPage = 1
        }

        let results: ResultsPage<T>?
        do {
            try results = getItems(nextPage)
            _currentPage = nextPage
        } catch {
            results = nil
        }
        return results?.items
    }

    /**
     Gets the previous known page of results

     - returns: Result set of the next page, or nil if none exist
     */
    public func getPrevPage() -> [T]? {
        let prevPage: Int
        if let page = _currentPage where page != 0 {
            prevPage = page - 1
        } else {
            prevPage = 1
        }

        let results: ResultsPage<T>?
        do {
            try results = getItems(prevPage)
            _currentPage = prevPage
        } catch {
            results = nil
        }
        return results?.items
    }

    /**
     Loads all known results in the result set from the server and returns those results to the
     provided callback

     - parameter completion: block that will be called when the results have been fetched, or if an error occurs.
     */
    public func preloadData(completion: CompletionBlock) {
        // Get total count so we can parallelize the rest of the fetching
        guard let result = getItems(1, offset: 0) else { return completion(nil, .NoData) }
        guard let totalCount = result.totalCount else { return completion(nil, .ParseError) }
        _totalItemCount = totalCount

        var allItems: [T] = []
        let group = AsyncGroup()
        (1..<_maxPage+1).forEach {i in
            group.background {
                guard let page = try? self.getItems(i),
                    stuff = page?.items else { return }
                allItems.appendContentsOf(stuff)
            }
        }
        group.wait()

        completion(allItems, nil)
    }
}

// MARK: - Private methods extension
extension PagedResultSet {
    // MARK: Caching

    private func addItemsToCache(page: Int, items: [T]) {
        _resultsCache[page] = items
    }

    private func getCacheForPage(page: Int) -> [T]? {
        return _resultsCache[page]
    }

    // MARK: Private methods

    private func parseResult(result: JSONResult, addToCache: Bool = false) -> ResultsPage<T>? {
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

        return ResultsPage(items: parsedItems, totalCount: totalItemCount)
    }

    private func queryParamsAppendedWith(params: MavenlinkQueryParams) -> MavenlinkQueryParams {
        guard queryParams != nil else { return params }
        var result: MavenlinkQueryParams = params
        result += queryParams!
        return result
    }

    private func getItems(limit: Int = 1, offset: Int = 0) -> ResultsPage<T>? {
        let response = MavenlinkSession.instance.get(resource + ".json", params: queryParamsAppendedWith(PagingParams.Indexed(offset: offset, limit: limit).getQueryParams()))
        return parseResult(response)
    }

    internal func getItems(page: Int) throws -> ResultsPage<T>? {
        guard page > 0 && page < _maxPage else { return nil }

        if let cachedResults = getCacheForPage(page) {
            return ResultsPage<T>(items: cachedResults, totalCount: _totalItemCount)
        }

        let params = queryParamsAppendedWith(
            PagingParams.Page(page: page, perPage: _perPage).getQueryParams())

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
}

public enum PagingParams {
    case Page(page: Int, perPage: Int)
    case Indexed(offset: Int, limit: Int)

    func getQueryParams() -> MavenlinkQueryParams {
        switch self {
        case Page(let page, let per): return ["page": page, "per_page": per]
        case .Indexed(let offset, let limit): return ["offset": offset, "limit": limit]
        }
    }
}


/**
 *  Struct that encapsulates a page of results returned by a `PagedResultSet` instance
 */
internal struct ResultsPage<T:Mappable> {
    var items: [T]?
    var totalCount: Int?
}
