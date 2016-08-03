//
//  MavenlinkTimeEntryService.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

public struct TimeEntryResultSet: Mappable {
    public private(set) var results: [TimeEntry]?
    public private(set) var workspaces: [Workspace]?
    public private(set) var users: [Users]?
    public private(set) var stories: [Story]?

    public init?(_ map: Map) { }

    mutating public func mapping(map: Map) {
        results <- map["time_entries"]
        workspaces <- map["workspaces"]
        users <- map["users"]
        stories <- map["stories"]
    }

    // Enums
    public enum Params: RESTApiParams {
        case WorkspaceId(id: Int)
        case BetweenDate(start: NSDate, end: NSDate)
        case Include(_: [MavenlinkResource.Type])

        public var paramName: String { get {
            switch self {
            case WorkspaceId: return "workspace_id"
            case BetweenDate: return "date_performed_between"
            case Include: return "include"
            }
            }
        }

        public var queryParam: MavenlinkQueryParams { get {
            let value: AnyObject
            switch self {
            case WorkspaceId(let id): value = id
            case BetweenDate(let start, let end):
                let startString = ShortDateFormatter.transformToJSON(start)!
                let endString = ShortDateFormatter.transformToJSON(end)!
                value = "\(startString):\(endString)"

            case Include(let resources):
                var string = resources.reduce("", combine: { (current, resource) -> String in
                    let name: String
                    switch resource {
                    case is Users.Type:
                        name = "user"
                    case is Workspace.Type:
                        name = "workspace"
                    default:
                        name = ""
                    }
                    return (name != "" ? name + "," + current : current)
                })
                value = string.substringToIndex(string.endIndex.predecessor()) // Remove trailing comma
            }
            return [self.paramName: value]
            }
        }
    }
}

/// Class for TimeEntry resources in MavenLink
public struct TimeEntry: Mappable, MavenlinkResource {
    // i-vars
    public private(set) var id: String?
    public private(set) var created_at: NSDate?
    public private(set) var updated_at: NSDate?
    public private(set) var date_performed: NSDate?
    public private(set) var story_id: Int?
    public private(set) var time_in_minutes: Int?
    public private(set) var billable: Bool?
    public private(set) var notes: String?
    public private(set) var rate_in_cents: Int?
    public private(set) var currency: String?
    public private(set) var currency_symbol: String?
    public private(set) var currency_base_unit: Int?
    public private(set) var user_can_edit: Bool?
    public private(set) var taxable: Bool?
    public private(set) var workspace_id: Int?
    public private(set) var user_id: Int?
    public private(set) var approved: Bool?

    public init?(_ map: Map) { }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        created_at <- (map["created_at"], LongDateFormatter)
        updated_at <- (map["updated_at"], LongDateFormatter)
        date_performed <- (map["date_performed"], ShortDateFormatter)
        story_id <- (map["story_id"], IntFormatter)
        time_in_minutes <- (map["time_in_minutes"], IntFormatter)
        billable <- map["billable"]
        notes <- map["notes"]
        rate_in_cents <- (map["rate_in_cents"], IntFormatter)
        currency <- map["currency"]
        currency_symbol <- map["currency_symbol"]
        currency_base_unit <- (map["currency_base_unit"], IntFormatter)
        user_can_edit <- map["user_can_edit"]
        taxable <- map["taxable"]
        workspace_id <- (map["workspace_id"], IntFormatter)
        user_id <- (map["user_id"], IntFormatter)
        approved <- map["approved"]
    }

    public static var resourceName: String {
        get { return "time_entries" }
    }
}

// MARK: - REST operations
public class TimeEntryService: MavenlinkResourceService<TimeEntryResultSet> {
//    public class func get(workspace: String? = nil, startDate: NSDate? = nil, endDate: NSDate? = nil) -> PagedResultSet<TimeEntry> {
//        var params: [RESTApiParams] = []
//        if let workspaceId = workspace {
//            params.append(TimeEntry.Params.WorkspaceId = workspaceId
//        }
//        
//        return PagedResultSet<TimeEntry>(resource: TimeEntry.resourceName, itemsPerPage: 100, params: params)
//    }
}
