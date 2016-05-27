//
//  MavenlinkWorkspaceService.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Workspace: Mappable {
    public var access_level: String?
    public var archived: Bool?
    public var budget_used: String?
    public var budget_used_in_cents: Int?
    public var budgeted: Bool?
    public var can_create_line_items: Bool?
    public var can_invite: Bool?
    public var change_orders_enabled: Bool?
    public var client_role_name: String?
    public var consultant_role_name: String?
    public var created_at: NSDate?
    public var creator_id: Int?
    public var currency: String?
    public var currency_base_unit: Int?
    public var currency_symbol: String?
    public var default_rate: String?
    public var workspace_description: String?
    public var due_date: NSDate?
    public var effective_due_date: NSDate?
    public var exclude_archived_stories_percent_complete: Bool?
    public var expenses_in_burn_rate: Bool?
    public var has_budget_access: Bool?
    public var id: Int?
    public var over_budget: Bool?
    public var percentage_complete: Int?
    public var posts_require_privacy_decision: Bool?
    public var price: String?
    public var price_in_cents: Int?
    public var rate_card_id: Int?
    public var require_expense_approvals: Bool?
    public var require_time_approvals: Bool?
    public var start_date: NSDate?
    public var status: WorkspaceStatus?
    public var tasks_default_non_billable: Bool?
    public var title: String?
    public var total_expenses_in_cents: Int?
    public var updated_at: NSDate?
    public var workspace_invoice_preference_id: Int?

    // Enums
    public enum Params: String {
        // bool
        case IncludeArchived = "include_archived"
        // string of WS title
        case MatchesTitle = "matching"
        // string of title, description, or team lead names
        case Search = "search"
    }

    public init?(_ map: Map) { }

    static var resourceName: String { get { return "workspaces" } }

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

public struct WorkspaceStatus: Mappable {
    public var color: String?
    public var message: String?
    public var key: Int?

    public init?(_ map: Map) { }
    mutating public func mapping(map: Map) {
        color <- map["color"]
        message <- map["message"]
        key <- (map["key"], NumericalStringConverter())
    }
}

public class WorkspaceService {
    public class func get(searchTerm: String? = nil, includeArchived: Bool? = nil) -> PagedResultSet<Workspace> {
        var params: MavenlinkQueryParams = [:]
        if let search = searchTerm {
            params[Workspace.Params.Search.rawValue] = search
        }
        if let includeArchived = includeArchived {
            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
        }
        return PagedResultSet<Workspace>(resource: Workspace.resourceName, params: params)
    }

    public class func getSpecific(matchingTitle: String, includeArchived: Bool? = nil) -> PagedResultSet<Workspace> {
        var params: MavenlinkQueryParams = [Workspace.Params.MatchesTitle.rawValue: matchingTitle]
        if let includeArchived = includeArchived {
            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
        }
        return PagedResultSet<Workspace>(resource: Workspace.resourceName,
                                         params: params)
    }

    public class func getWorkspace(workspaceId: Int) -> Workspace? {
        let response = PagedResultSet<Workspace>(resource: Workspace.resourceName)
        return response.getNextPage()?.first
    }
}

