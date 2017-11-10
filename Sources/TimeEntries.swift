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

/// Class for TimeEntry resources in MavenLink
public struct TimeEntry: Mappable, MavenlinkResource {
    // i-vars
    public fileprivate(set) var id: String?
    public fileprivate(set) var created_at: Date?
    public fileprivate(set) var updated_at: Date?
    public fileprivate(set) var date_performed: Date?
    public fileprivate(set) var story_id: Int?
    public fileprivate(set) var time_in_minutes: Int?
    public fileprivate(set) var billable: Bool?
    public fileprivate(set) var notes: String?
    public fileprivate(set) var rate_in_cents: Int?
    public fileprivate(set) var currency: String?
    public fileprivate(set) var currency_symbol: String?
    public fileprivate(set) var currency_base_unit: Int?
    public fileprivate(set) var user_can_edit: Bool?
    public fileprivate(set) var taxable: Bool?
    public fileprivate(set) var workspace_id: Int?
    public fileprivate(set) var user_id: Int?
    public fileprivate(set) var approved: Bool?

    public init?(map: Map) { }

    public static var resourceName: String {
        get { return "time_entries" }
    }

    // Enums
    public enum Params: RESTApiParams {
        case workspaceId(id: Int)
        case betweenDate(start: Date, end: Date)

        public var paramName: String { get {
            switch self {
            case .workspaceId: return "workspace_id"
            case .betweenDate: return "date_performed_between"
            }
            }
        }

        public var queryParam: MavenlinkQueryParams { get {
            let value: AnyObject
            switch self {
            case .workspaceId(let id): value = id as AnyObject
            case .betweenDate(let start, let end):
                let startString = ShortDateFormatter.transformToJSON(start)!
                let endString = ShortDateFormatter.transformToJSON(end)!
                value = "\(startString):\(endString)" as AnyObject
            }
            return [self.paramName: value]
            }
        }
    }

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
}

// MARK: - REST operations
open class TimeEntryService: MavenlinkResourceService<TimeEntry> {
//    public class func get(workspace: String? = nil, startDate: NSDate? = nil, endDate: NSDate? = nil) -> PagedResultSet<TimeEntry> {
//        var params: [RESTApiParams] = []
//        if let workspaceId = workspace {
//            params.append(TimeEntry.Params.WorkspaceId = workspaceId
//        }
//        
//        return PagedResultSet<TimeEntry>(resource: TimeEntry.resourceName, itemsPerPage: 100, params: params)
//    }
}
