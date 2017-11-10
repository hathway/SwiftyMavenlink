//
//  WorkspaceGroup.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 6/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

public struct WorkspaceGroup: Mappable, MavenlinkResource {
    public fileprivate(set) var id: Int?
    public fileprivate(set) var name: String?
    public fileprivate(set) var company: Bool?
    public fileprivate(set) var created_at: Date?
    public fileprivate(set) var updated_at: Date?
    public fileprivate(set) var workspace_ids: [Int]?

    public init?(map: Map) { }

    public static var resourceName: String { get { return "workspace_groups" } }
    public static var searchable: Bool { get { return false } }

    mutating public func mapping(map: Map) {
        id <- (map["id"], IntFormatter)
        name <- map["name"]
        company <- map["company"]
        created_at <- (map["created_at"], LongDateFormatter)
        updated_at <- (map["updated_at"], LongDateFormatter)
        workspace_ids <- (map["workspace_ids"], IntArrayFormatter)
    }
}

extension WorkspaceGroup {
    public enum Params: RESTApiParams {
        /// Include the workspace IDs contained in each group in the response. 
        case includeWorkspaces

        public var paramName: String {
            get {
                switch(self) {
                case .includeWorkspaces:
                    return "include"
                }
            }
        }

        public var queryParam: MavenlinkQueryParams {
            get {
                let value: AnyObject
                switch(self) {
                case .includeWorkspaces:
                    value = "workspaces" as AnyObject
                }
                return [self.paramName: value]
            }
        }
    }
}


open class WorkspaceGroupService: MavenlinkResourceService<WorkspaceGroup> {
//    override public class func get(params: MavenlinkQueryParams? = WorkspaceGroup.Params.IncludeWorkspaces.queryParam) -> PagedResultSet<Resource> {
//        return PagedResultSet<Resource>(resource: Resource.resourceName, params: params)
//    }
}
