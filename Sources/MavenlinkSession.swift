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
func +=<K, V> (inout left: [K : V], right: [K : V]) {
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

public class MavenlinkSession {
    public static let instance: MavenlinkSession = MavenlinkSession()
    private var oAuthToken: String?
    static let apiHost: String! = "https://api.mavenlink.com/api/v1/"

    private func request() -> JSONRequest {
        let result = JSONRequest()
        result.httpRequest?.setValue("Bearer \(oAuthToken!)", forHTTPHeaderField: "Authorization")
        return result
    }

    public func configure(oAuthToken: String) {
        precondition(oAuthToken != "", "oAuthToken parameter cannot be blank")
        self.oAuthToken = oAuthToken
    }

    func get(urlPath: String, params: MavenlinkQueryParams? = nil) -> JSONResult {
        guard let url = MavenlinkSession.buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        return request().get(url, queryParams: params)
    }

    func post(urlPath: String, params: MavenlinkQueryParams? = nil,
              payload: MavenlinkPayload? = nil) -> JSONResult {
        guard let url = MavenlinkSession.buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        return request().post(url, queryParams: params, payload: payload)
    }

    func put(urlPath: String, params: MavenlinkQueryParams? = nil,
             payload: MavenlinkPayload? = nil) -> JSONResult {
        guard let url = MavenlinkSession.buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        return request().put(url, queryParams: params, payload: payload)
    }

    class func buildUrl(urlPath: String) -> String? {
        return NSURL(string: apiHost)?
            .URLByAppendingPathComponent(urlPath ?? "")
            .absoluteString
    }
}
