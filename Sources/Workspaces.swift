//
//  MavenlinkWorkspaceService.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Workspace: Mappable, MavenlinkResource {
    public fileprivate(set) var access_level: String?
    public fileprivate(set) var archived: Bool?
    public fileprivate(set) var budget_used: String?
    public fileprivate(set) var budget_used_in_cents: Int?
    public fileprivate(set) var budgeted: Bool?
    public fileprivate(set) var can_create_line_items: Bool?
    public fileprivate(set) var can_invite: Bool?
    public fileprivate(set) var change_orders_enabled: Bool?
    public fileprivate(set) var client_role_name: String?
    public fileprivate(set) var consultant_role_name: String?
    public fileprivate(set) var created_at: Date?
    public fileprivate(set) var creator_id: Int?
    public fileprivate(set) var currency: String?
    public fileprivate(set) var currency_base_unit: Int?
    public fileprivate(set) var currency_symbol: String?
    public fileprivate(set) var default_rate: String?
    public fileprivate(set) var workspace_description: String?
    public fileprivate(set) var due_date: Date?
    public fileprivate(set) var effective_due_date: Date?
    public fileprivate(set) var exclude_archived_stories_percent_complete: Bool?
    public fileprivate(set) var expenses_in_burn_rate: Bool?
    public fileprivate(set) var has_budget_access: Bool?
    public fileprivate(set) var id: Int?
    public fileprivate(set) var over_budget: Bool?
    public fileprivate(set) var percentage_complete: Int?
    public fileprivate(set) var posts_require_privacy_decision: Bool?
    public fileprivate(set) var price: String?
    public fileprivate(set) var price_in_cents: Int?
    public fileprivate(set) var rate_card_id: Int?
    public fileprivate(set) var require_expense_approvals: Bool?
    public fileprivate(set) var require_time_approvals: Bool?
    public fileprivate(set) var start_date: Date?
    public fileprivate(set) var status: WorkspaceStatus?
    public fileprivate(set) var tasks_default_non_billable: Bool?
    public fileprivate(set) var title: String?
    public fileprivate(set) var total_expenses_in_cents: Int?
    public fileprivate(set) var updated_at: Date?
    public fileprivate(set) var workspace_invoice_preference_id: Int?

    // Enums
    public enum Params: RESTApiParams {
        // bool
        case includeArchived(include: Bool)
        // string of WS title
        case matchesTitle(title :String)
        // string of title, description, or team lead names
        case only(id :Int)

        public var paramName: String {
            get {
                switch self {
                case .includeArchived:
                    return "include_archived"
                // string of WS title
                case .matchesTitle:
                    return "matching"
                // string of title, description, or team lead names
                case .only:
                    return "only"
                }
            }
        }

        public var queryParam: MavenlinkQueryParams {
            get {
                let value: AnyObject
                switch self {
                case .includeArchived(let include):
                    value = include as AnyObject
                // string of WS title
                case .matchesTitle(let title):
                    value = title as AnyObject
                // string of title, description, or team lead names
                case .only(let id):
                    value = id as AnyObject
                }
                return [self.paramName: value]
            }
        }
    }

    public init?(map: Map) { }

    public static var resourceName: String { get { return "workspaces" } }
    public static var searchable: Bool { get { return true } }

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
}

public func ==(lhs: Workspace, rhs: Workspace) -> Bool {
    return (lhs.id ?? 0) == (rhs.id ?? 0)
}

extension Workspace: Hashable {
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
            case .Red:
                return 1
            case .Yellow:
                return 2
            case .Green:
                return 3
            case .LightGreen:
                return 4
            case .Blue:
                return 5
            case .Grey:
                return 6
            }
        }
    }

    public init?(map: Map) { }
    mutating public func mapping(map: Map) {
        color <- map["color"]
        message <- map["message"]
        key <- (map["key"], NumericalStringConverter())
    }
}

open class WorkspaceService: MavenlinkResourceService<Workspace> {
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

