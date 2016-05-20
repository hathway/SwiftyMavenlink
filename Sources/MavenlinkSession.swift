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
    private let apiHost: String! = "https://api.mavenlink.com/api/v1/"
    private var request: JSONRequest! = JSONRequest()

    public func configure(oAuthToken: String) {
        precondition(oAuthToken != "", "oAuthToken parameter cannot be blank")
        self.request.httpRequest?.setValue("Bearer \(oAuthToken)", forHTTPHeaderField: "Authorization")
    }

    func get(urlPath: String, params: MavenlinkQueryParams? = nil) -> JSONResult {
        guard let url = buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        return request.get(url, queryParams: params)
    }

    func post(urlPath: String, params: MavenlinkQueryParams? = nil,
              payload: MavenlinkPayload? = nil) -> JSONResult {
        guard let url = buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        return request.post(url, queryParams: params, payload: payload)
    }

    func put(urlPath: String, params: MavenlinkQueryParams? = nil,
             payload: MavenlinkPayload? = nil) -> JSONResult {
        guard let url = buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        return request.put(url, queryParams: params, payload: payload)
    }

    func buildUrl(urlPath: String) -> String? {
        return NSURL(string: apiHost)?
            .URLByAppendingPathComponent(urlPath ?? "")
            .absoluteString
    }
}
