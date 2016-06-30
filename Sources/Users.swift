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
    public var full_name: String?
    public var photo_path: NSURL?
    public var email_address: String?
    public var headline: String?
    public var account_id: Int?
    public var id: Int?

    public init?(_ map: Map) { }

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
        case OnMyAccount
        // only return users that are active participants in the given Workspace
        case ParticipantIn(workspaceId: Int)
        // only return users that are on the given Account. This filter is not available in conjunction with the on_my_account option.
        case ByAccount(accountId: Int)
        // only return users that are in at least one Workspace as a consultant
        case ConsultantsOnly(enabled: Bool)
        // only return users that are in at least one Workspace as a client
        case ClientsOnly(enabled: Bool)
        // Get a specific user
        case SpecificUsers(userIds: [Int])

        public var queryParam: MavenlinkQueryParams {
            get {
                switch(self) {
                case .OnMyAccount:
                    return ["on_my_account": true]
                case .ParticipantIn(let id):
                    return ["participant_in": id]
                case .ByAccount(let id):
                    return ["account_id": id]
                case .ConsultantsOnly:
                    return ["consultants_only": true]
                case ClientsOnly:
                    return ["clients_only": true]
                case .SpecificUsers(let userIds):
                    return ["only": userIds.toJSONString()]
                }
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

public class UserService: MavenlinkResourceService<Users> {
    public class func getVisibleUsers() -> PagedResultSet<Users> {
        return PagedResultSet<Users>(resource: Users.resourceName, params: [:])
    }

    public class func getAccountUsers() -> PagedResultSet<Users> {
        return PagedResultSet<Users>(resource: Users.resourceName, params:
            Users.Params.OnMyAccount.queryParam
        )
    }

    public class func getSpecificUsers(userIds: [Int]) -> PagedResultSet<Users> {
        return PagedResultSet<Users>(resource: Users.resourceName, params: Users.Params.SpecificUsers(userIds: userIds).queryParam)
    }
}