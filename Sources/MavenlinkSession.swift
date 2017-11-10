//
//  MavenlinkSession.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyJSON
import JSONRequest

public typealias MavenlinkQueryParams = [String: AnyObject]
func +=<K, V> (left: inout [K : V], right: [K : V]) {
    for (k, v) in right {
        left[k] = v
    }
}

public typealias MavenlinkPayload = AnyObject

/*
protocol RestSession {
    associatedtype SessionType
    static var instance: SessionType { get }
    func configure(oAuthToken: String)
    func get(urlPath: String, params: MavenlinkQueryParams?) -> JSONResult
    func post(urlPath: String, params: MavenlinkQueryParams?, payload: MavenlinkPayload?) -> JSONResult
}
 */

open class MavenlinkSession {
    open static let instance: MavenlinkSession = MavenlinkSession()
    fileprivate var oAuthToken: String?
    static let apiHost: String! = "https://api.mavenlink.com/api/v1/"

    fileprivate func request() -> JSONRequest {
        precondition(oAuthToken != nil, "OAuth token must be configured before making requests")
        let result = JSONRequest()
        result.httpRequest?.setValue("Bearer \(oAuthToken!)", forHTTPHeaderField: "Authorization")
        return result
    }

    open func configure(_ oAuthToken: String) {
        precondition(oAuthToken != "", "oAuthToken parameter cannot be blank")
        self.oAuthToken = oAuthToken
    }

    func get(_ urlPath: String, params: MavenlinkQueryParams? = nil) -> JSONResult {
        guard let url = MavenlinkSession.buildUrl(urlPath) else {
            return JSONResult.failure(error: JSONError.invalidURL, response: nil, body: nil)
        }
        return request().get(url: url, queryParams: params)
    }

    func post(_ urlPath: String, params: MavenlinkQueryParams? = nil,
              payload: MavenlinkPayload? = nil) -> JSONResult {
        guard let url = MavenlinkSession.buildUrl(urlPath) else {
            return JSONResult.failure(error: JSONError.invalidURL, response: nil, body: nil)
        }
        return request().post(url: url, queryParams: params, payload: payload)
    }

    func put(_ urlPath: String, params: MavenlinkQueryParams? = nil,
             payload: MavenlinkPayload? = nil) -> JSONResult {
        guard let url = MavenlinkSession.buildUrl(urlPath) else {
            return JSONResult.failure(error: JSONError.invalidURL, response: nil, body: nil)
        }
        return request().put(url: url, queryParams: params, payload: payload)
    }

    class func buildUrl(_ urlPath: String) -> String? {
        return URL(string: apiHost)?
            .appendingPathComponent(urlPath ?? "")
            .absoluteString
    }
}
