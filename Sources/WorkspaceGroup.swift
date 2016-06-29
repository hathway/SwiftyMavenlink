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
    public var id: Int?
    public var name: String?
    public var company: Bool?
    public var created_at: NSDate?
    public var updated_at: NSDate?
    public var workspace_ids: [Int]?

    public init?(_ map: Map) { }

    public static var resourceName: String { get { return "workspace_groups" } }
    public static var searchable: Bool { get { return false } }

    mutating public func mapping(map: Map) {
        id <- (map["id"], IntFormatter)
        name <- map["name"]
        company <- map["company"]
        created_at <- (map["created_at"], LongDateFormatter)
        updated_at <- (map["updated_at"], LongDateFormatter)
        workspace_ids <- (map["workspace_ids"], IntFormatter)
    }
}


public class WorkspaceGroupService: MavenlinkResourceService<WorkspaceGroup> {
}