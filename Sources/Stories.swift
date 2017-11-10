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

    public fileprivate(set) var title: String?
    public fileprivate(set) var description: String?
    public fileprivate(set) var updated_at: Date?
    public fileprivate(set) var created_at: Date?
    public fileprivate(set) var due_date: Date?
    public fileprivate(set) var start_date: Date?
    public fileprivate(set) var story_type: String?
    public fileprivate(set) var state: String?
    public fileprivate(set) var position: Int?
    public fileprivate(set) var archived: Bool?
    public fileprivate(set) var deleted_at: Date?
    public fileprivate(set) var sub_story_count: Int?
    public fileprivate(set) var percentage_complete: Int?
    public fileprivate(set) var priority: String?
    public fileprivate(set) var has_proofing_access: Bool?
    public fileprivate(set) var ancestor_ids: [Int]?
    public fileprivate(set) var subtree_depth: Int?
    public fileprivate(set) var time_trackable: Bool?
    public fileprivate(set) var workspace_id: Int?
    public fileprivate(set) var creator_id: Int?
    public fileprivate(set) var parent_id: Int?
    public fileprivate(set) var root_id: Int?
    public fileprivate(set) var id: Int?

    public enum StoryType: String {
        case Task = "task"
        case Deliverable = "deliverable"
        case Milestone = "milestone"
    }

    /*
    public enum NonIssueState: String {
        case Started = "started"
        case NotStarted = "not started"
        case Completed = "completed"
    }
    public enum IssueState: String {
        case New = "new"
        case Reopened = "reopened"
        case InProgress = "in progress"
        case Blocked = "blocked"
        case Fixed = "fixed"
        case Duplicate = "duplicate"
        case CantRepro = "can't repro"
        case Resolved = "resolved"
        case WontFix = "won't fix"
    }
 */

    // Enums
    public enum Params: RESTApiParams {
        // bool
        case showArchived(_:Bool)
        case allOnAccount(_:Bool)
        case type(_:StoryType)

        public var paramName: String {
            get {
                switch self {
                case .showArchived(_):
                    return "show_archived"
                case .allOnAccount(_):
                    return "all_on_account"
                case .type(_):
                    return "story_type"
                }
            }
        }

        public var queryParam: MavenlinkQueryParams {
            get {
                var value: AnyObject
                switch self {
                case .showArchived(let show):
                    value = show as AnyObject
                case .allOnAccount(let show):
                    value = show as AnyObject
                case .type(let type):
                    value = type.rawValue as AnyObject
                }
                return [self.paramName: value]
            }
        }
    }

    public init?(map: Map) { }

    public static var resourceName: String { get { return "stories" } }
    public static var searchQueryParam: String { get { return "search" } }

    mutating public func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        updated_at <- (map["updated_at"], LongDateFormatter)
        created_at <- (map["created_at"], LongDateFormatter)
        due_date <- (map["due_date"], ShortDateFormatter)
        start_date <- (map["start_date"], ShortDateFormatter)
        story_type <- map["story_type"]
        state <- map["state"]
        position <- (map["position"], IntFormatter)
        archived <- map["archived"]
        deleted_at <- (map["deleted_at"], LongDateFormatter)
        sub_story_count <- (map["sub_story_count"], IntFormatter)
        percentage_complete <- (map["percentage_complete"], IntFormatter)
        priority <- map["priority"]
        has_proofing_access <- map["has_proofing_access"]
        ancestor_ids <- (map["ancestor_ids"], IntArrayFormatter)
        subtree_depth <- (map["subtree_depth"], IntFormatter)
        time_trackable <- map["time_trackable"]
        workspace_id <- (map["workspace_id"], IntFormatter)
        creator_id <- (map["creator_id"], IntFormatter)
        parent_id <- (map["parent_id"], IntFormatter)
        root_id <- (map["root_id"], IntFormatter)
        id <- (map["id"], IntFormatter)
    }
}

extension Story {

    public var isCompleted: Bool { get { return self.state == "completed" } }

    public static func nextStoryReducer(_ accumulator: Story?, current: Story) -> Story? {
        // If the task is completed, don't return it
        guard !current.isCompleted else { return accumulator }
        // If the accumulator is nil, return current if it's not completed
        guard let accumulatorDue = accumulator?.due_date else {
            return (!current.isCompleted ? current : nil)
        }
        // If current has no due date, don't return it
        guard let currentDue = current.due_date else { return accumulator }

        // At this point, return the item with the soonest due date
        return (currentDue.timeIntervalSince(accumulatorDue) < 0)
            ? current
            : accumulator
    }

    static func getUpcomingStory(_ stories: [Story]?, date: Date) -> Story? {
        let now = Date()
        guard let storyArray = stories else { return nil }
        let nextStory = storyArray.reduce(nil) { (result, story) -> Story? in
            if let resultDueDate = result?.due_date, let nextDueDate = story.due_date {
                return (nextDueDate.timeIntervalSince(resultDueDate) > 0
                    && now.timeIntervalSince(nextDueDate) > 0)
                    ? story
                    : result
            }
            return result
        }
        return nextStory
    }
}

open class StoryService: MavenlinkResourceService<Story> {
//    public class func get<T:RESTApiParams>(params: [T]? = nil) -> PagedResultSet<Resource> {
////        var params: MavenlinkQueryParams = Story.Params.AllOnAccount(showAllOnAccount).queryParam
////        params += Story.Params.ShowArchived(showArchived).queryParam
//        return super.get(params)
//    }
//
//    public class func search(matchingTitle: String, includeArchived: Bool? = nil) -> PagedResultSet<Resource> {
//        var params: MavenlinkQueryParams = [Workspace.Params.MatchesTitle.rawValue: matchingTitle]
//        if let includeArchived = includeArchived {
//            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
//        }
//        return super.search(matchingTitle, extraParams: params)
//    }
//
//    public class func getSpecific(id: Int, includeArchived: Bool? = nil) -> Story? {
//        var params: MavenlinkQueryParams = [:]
//        if let includeArchived = includeArchived {
//            params[Workspace.Params.IncludeArchived.rawValue] = includeArchived
//        }
//        return super.getSpecific(id, params: params)
//    }
}

