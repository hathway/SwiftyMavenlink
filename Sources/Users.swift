//
//  Users.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/17/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

public struct Users: Mappable, MavenlinkResource {
    public fileprivate(set) var full_name: String?
    public fileprivate(set) var photo_path: URL?
    public fileprivate(set) var email_address: String?
    public fileprivate(set) var headline: String?
    public fileprivate(set) var account_id: Int?
    public fileprivate(set) var id: Int?

    public init?(map: Map) { }

    public static var resourceName: String { get { return "users" } }
    public static var searchable: Bool { get { return false } }

    mutating public func mapping(map: Map) {
        full_name <- map["full_name"]
        photo_path <- (map["photo_path"], URLFormatter)
        email_address <- map["email_address"]
        headline <- map["headline"]
        account_id <- (map["account_id"], IntFormatter)
        id <- (map["id"], IntFormatter)
    }
}

extension Users {
    // Enums
    public enum Params: RESTApiParams {
        // bool
        case onMyAccount
        // only return users that are active participants in the given Workspace
        case participantIn(workspaceId: Int)
        // only return users that are on the given Account. This filter is not available in conjunction with the on_my_account option.
        case byAccount(accountId: Int)
        // only return users that are in at least one Workspace as a consultant
        case consultantsOnly(enabled: Bool)
        // only return users that are in at least one Workspace as a client
        case clientsOnly(enabled: Bool)
        // Get a specific user
        case specificUsers(userIds: [Int])

        public var paramName: String {
            get {
                switch(self) {
                case .onMyAccount:
                    return "on_my_account"
                case .participantIn:
                    return "participant_in"
                case .byAccount:
                    return "account_id"
                case .consultantsOnly:
                    return "consultants_only"
                case .clientsOnly:
                    return "clients_only"
                case .specificUsers:
                    return "only"
                }
            }
        }

        public var queryParam: MavenlinkQueryParams {
            get {
                let value: AnyObject
                switch(self) {
                case .onMyAccount:
                    value = true as AnyObject
                    break
                case .participantIn(let id):
                    value = id as AnyObject
                    break
                case .byAccount(let id):
                    value = id as AnyObject
                    break
                case .consultantsOnly:
                    value = true as AnyObject
                    break
                case .clientsOnly:
                    value = true as AnyObject
                    break
                case .specificUsers(let userIds):
                    value = userIds.toJSONString() as AnyObject
                    break
                }
                return [self.paramName: value]
            }
        }
    }

}

public func ==(lhs: Users, rhs: Users) -> Bool {
    return lhs.id == rhs.id
}

extension Users: Hashable {
    public var hashValue: Int {
        get { return self.id ?? 0 }
    }
}

open class UserService: MavenlinkResourceService<Users> {
    open class func getAccountUsers() -> PagedResultSet<Resource> {
        return super.get([Users.Params.onMyAccount])
    }

    open class func getSpecificUsers(_ userIds: [Int]) -> PagedResultSet<Resource> {
        return super.get([Users.Params.specificUsers(userIds: userIds)])
    }
}
