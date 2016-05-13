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

typealias MavenlinkQueryParams = [String: AnyObject?]
typealias MavenlinkPayload = AnyObject

public class MavenlinkSession {
    public static let instance: MavenlinkSession = MavenlinkSession()
    private let apiHost = "https://api.mavenlink.com/api/v1/"
    private var request: JSONRequest?

    var oAuthToken: String?
//    var appId: String?
//    var secretKey: String?

    public func urlForResource(resource: String) -> NSURL {
        return NSURL(string: resource, relativeToURL: NSURL(string: apiHost))!
    }

    func configure(oAuthToken: String) throws {
        guard oAuthToken != "" else {
            throw NSError(domain: NSInvalidArgumentException, code: 0, userInfo: nil)
        }

        self.oAuthToken = oAuthToken
//        self.appId = appId
//        self.secretKey = secretKey
        self.request = JSONRequest()
        self.request?.httpRequest?.setValue("Bearer \(oAuthToken)", forHTTPHeaderField: "Authorization")
    }

    func get(urlPath: String, params: MavenlinkQueryParams? = nil) -> JSONResult {
        guard let url = buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        guard let request = request else {
            return JSONResult.Failure(error: JSONError.RequestFailed, response: nil, body: nil)
        }
        return request.get(url, queryParams: params)
    }

    func post(urlPath: String, params: MavenlinkQueryParams? = nil,
              payload: MavenlinkPayload? = nil) -> JSONResult {
        guard let url = buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        guard let request = request else {
            return JSONResult.Failure(error: JSONError.RequestFailed, response: nil, body: nil)
        }
        return request.post(url, queryParams: params, payload: payload)
    }

    func put(urlPath: String, params: MavenlinkQueryParams? = nil,
             payload: MavenlinkPayload? = nil) -> JSONResult {
        guard let url = buildUrl(urlPath) else {
            return JSONResult.Failure(error: JSONError.InvalidURL, response: nil, body: nil)
        }
        guard let request = request else {
            return JSONResult.Failure(error: JSONError.RequestFailed, response: nil, body: nil)
        }
        return request.put(url, queryParams: params, payload: payload)
    }

    func buildUrl(urlPath: String) -> String? {
        return NSURL(string: apiHost ?? "")?
            .URLByAppendingPathComponent(urlPath ?? "")
            .absoluteString
    }
}
