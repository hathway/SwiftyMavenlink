//
//  MavenlinkWorkspaceService.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

public struct WorkspaceResultSet: Mappable {
    public private(set) var results: [Workspace]?
    public private(set) var participants: [Users]?
    public private(set) var workspace_groups: [WorkspaceGroup]?


    // Enums
    public enum Params: RESTApiParams {
        // bool
        case IncludeArchived(include: Bool)
        // string of WS title
        case MatchesTitle(title :String)
        // string of title, description, or team lead names
        case Only(id :Int)

        public var paramName: String {
            get {
                switch self {
                case IncludeArchived:
                    return "include_archived"
                // string of WS title
                case MatchesTitle:
                    return "matching"
                // string of title, description, or team lead names
                case Only:
                    return "only"
                }
            }
        }

        public var queryParam: MavenlinkQueryParams {
            get {
                let value: AnyObject
                switch self {
                case IncludeArchived(let include):
                    value = include
                // string of WS title
                case MatchesTitle(let title):
                    value = title
                // string of title, description, or team lead names
                case Only(let id):
                    value = id
                }
                return [self.paramName: value]
            }
        }
    }

    public init?(_ map: Map) { }
    public mutating func mapping(map: Map) {
        results <- map["results"]
        participants <- map["users"]
        workspace_groups <- map["workspace_groups"]
    }

    public static var resourceName: String { get { return "workspaces" } }
}

public struct Workspace: Mappable, MavenlinkResource {
    public private(set) var access_level: String?
    public private(set) var archived: Bool?
    public private(set) var budget_used: String?
    public private(set) var budget_used_in_cents: Int?
    public private(set) var budgeted: Bool?
    public private(set) var can_create_line_items: Bool?
    public private(set) var can_invite: Bool?
    public private(set) var change_orders_enabled: Bool?
    public private(set) var client_role_name: String?
    public private(set) var consultant_role_name: String?
    public private(set) var created_at: NSDate?
    public private(set) var creator_id: Int?
    public private(set) var currency: String?
    public private(set) var currency_base_unit: Int?
    public private(set) var currency_symbol: String?
    public private(set) var default_rate: String?
    public private(set) var workspace_description: String?
    public private(set) var due_date: NSDate?
    public private(set) var effective_due_date: NSDate?
    public private(set) var exclude_archived_stories_percent_complete: Bool?
    public private(set) var expenses_in_burn_rate: Bool?
    public private(set) var has_budget_access: Bool?
    public private(set) var id: Int?
    public private(set) var over_budget: Bool?
    public private(set) var percentage_complete: Int?
    public private(set) var posts_require_privacy_decision: Bool?
    public private(set) var price: String?
    public private(set) var price_in_cents: Int?
    public private(set) var rate_card_id: Int?
    public private(set) var require_expense_approvals: Bool?
    public private(set) var require_time_approvals: Bool?
    public private(set) var start_date: NSDate?
    public private(set) var status: WorkspaceStatus?
    public private(set) var tasks_default_non_billable: Bool?
    public private(set) var title: String?
    public private(set) var total_expenses_in_cents: Int?
    public private(set) var updated_at: NSDate?
    public private(set) var workspace_invoice_preference_id: Int?

    public init?(_ map: Map) { }
    mutating public func mapping(map: Map) {
        access_level <- map["access_level"]
        archived <- map["archived"]
        budget_used <- map["budget_used"]
        budget_used_in_cents <- (map["budget_used_in_cents"], IntFormatter)
        budgeted <- map["budgeted"]
        can_create_line_items <- map["can_create_line_items"]
        can_invite <- map["can_invite"]
        change_orders_enabled <- map["change_orders_enabled"]
        client_role_name <- map["client_role_name"]
        consultant_role_name <- map["consultant_role_name"]
        created_at <- (map["created_at"], LongDateFormatter)
        creator_id <- (map["creator_id"], IntFormatter)
        currency_base_unit <- (map["currency_base_unit"], IntFormatter)
        currency_symbol <- map["currency_symbol"]
        currency <- map["currency"]
        default_rate <- map["default_rate"]
        workspace_description <- map["description"]
        due_date <- (map["due_date"], ShortDateFormatter)
        effective_due_date <- (map["effective_due_date"], ShortDateFormatter)
        exclude_archived_stories_percent_complete <- map["exclude_archived_stories_percent_complete"]
        expenses_in_burn_rate <- map["expenses_in_burn_rate"]
        has_budget_access <- map["has_budget_access"]
        id <- (map["id"], IntFormatter)
        over_budget <- map["over_budget"]
        percentage_complete <- (map["percentage_complete"], IntFormatter)
        posts_require_privacy_decision <- map["posts_require_privacy_decision"]
        price_in_cents <- (map["price_in_cents"], IntFormatter)
        price <- map["price"]
        price_in_cents <- (map["price_in_cents"], IntFormatter)
        rate_card_id <- (map["rate_card_id"], IntFormatter)
        require_expense_approvals <- map["require_expense_approvals"]
        require_time_approvals <- map["require_time_approvals"]
        start_date <- (map["start_date"], ShortDateFormatter)
        status <- map["status"]
        tasks_default_non_billable <- map["tasks_default_non_billable"]
        title <- map["title"]
        total_expenses_in_cents <- (map["total_expenses_in_cents"], IntFormatter)
        updated_at <- (map["updated_at"], LongDateFormatter)
        workspace_invoice_preference_id <- (map["workspace_invoice_preference_id"], IntFormatter)
    }

    public static var resourceName: String { get { return "workspaces" } }
}

public func ==<T where T:MavenlinkResource>(lhs: T, rhs: T) -> Bool {
    return (lhs.id ?? 0) == (rhs.id ?? 0)
}

extension MavenlinkResource {
    public var hashValue: Int {
        get {
            return self.id ?? 0
        }
    }
}

public struct WorkspaceStatus: Mappable {
    public var color: Color?
    public var message: String?
    public var key: Int?

    public enum Color: String {
        case Green = "green"
        case Grey = "grey"
        case Red = "red"
        case Blue = "blue"
        case LightGreen = "light-green"
        case Yellow = "yellow"

        public var priorityStatus: Int {
            switch self {
            case Red:
                return 1
            case Yellow:
                return 2
            case Green:
                return 3
            case LightGreen:
                return 4
            case Blue:
                return 5
            case Grey:
                return 6
            }
        }
    }

    public init?(_ map: Map) { }
    mutating public func mapping(map: Map) {
        color <- map["color"]
        message <- map["message"]
        key <- (map["key"], NumericalStringConverter())
    }
}

public class WorkspaceService: MavenlinkResourceService<WorkspaceResultSet> {
//    public class func search(matchingTitle: String, includeArchived: Bool? = nil) -> PagedResultSet<Resource> {
//        var params: MavenlinkQueryParams = [:]
//        if let includeArchived = includeArchived {
//            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
//        }
//        return super.search(matchingTitle, extraParams: params)
//    }
//
//    public class func getWorkspace(workspaceId: Int, includeArchived: Bool? = nil) -> Workspace? {
//        var params: MavenlinkQueryParams = [Workspace.Params.Only.rawValue: workspaceId]
//        if let includeArchived = includeArchived {
//            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
//        }
//        return super.getSpecific(workspaceId, params: params)
//    }
}

