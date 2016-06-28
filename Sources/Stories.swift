//
//  MavenlinkWorkspaceService.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Story: Mappable, MavenlinkResource {


    // Enums
    public enum Params: String {
        // bool
        case IncludeArchived = "include_archived"
        // string of WS title
        case MatchesTitle = "matching"
        // string of title, description, or team lead names
        case Search = "search"
        // get a specific workspace by ID
        case Only = "only"
    }

    public init?(_ map: Map) { }

    public static var resourceName: String { get { return "workspaces" } }
    public static var searchQueryParam: String { get { return "search" } }

    mutating public func mapping(map: Map) {

    }
}

public class StoryService: MavenlinkResourceService<Story> {
    public class func get(searchTerm: String? = nil, includeArchived: Bool? = nil) -> PagedResultSet<Story> {
        var params: MavenlinkQueryParams = [:]
        if let search = searchTerm {
            params[Workspace.Params.Search.rawValue] = search
        }
        if let includeArchived = includeArchived {
            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
        }
        return PagedResultSet<Story>(resource: Workspace.resourceName, params: params)
    }

    public class func search(matchingTitle: String, includeArchived: Bool? = nil) -> PagedResultSet<Story> {
        var params: MavenlinkQueryParams = [Workspace.Params.MatchesTitle.rawValue: matchingTitle]
        if let includeArchived = includeArchived {
            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
        }
        return super.search(matchingTitle, extraParams: params)
    }

    public class func getSpecific(workspaceId: Int, includeArchived: Bool? = nil) -> Story? {
        var params: MavenlinkQueryParams = [Workspace.Params.Only.rawValue: workspaceId]
        if let includeArchived = includeArchived {
            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
        }
        return super.getSpecific(workspaceId, params: params)
    }
}

