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

    public private(set) var title: String?
    public private(set) var description: String?
    public private(set) var updated_at: NSDate?
    public private(set) var created_at: NSDate?
    public private(set) var due_date: NSDate?
    public private(set) var start_date: NSDate?
    public private(set) var story_type: String?
    public private(set) var state: String?
    public private(set) var position: Int?
    public private(set) var archived: Bool?
    public private(set) var deleted_at: NSDate?
    public private(set) var sub_story_count: Int?
    public private(set) var percentage_complete: Int?
    public private(set) var priority: String?
    public private(set) var has_proofing_access: Bool?
    public private(set) var ancestor_ids: [Int]?
    public private(set) var subtree_depth: Int?
    public private(set) var time_trackable: Bool?
    public private(set) var workspace_id: Int?
    public private(set) var creator_id: Int?
    public private(set) var parent_id: Int?
    public private(set) var root_id: Int?
    public private(set) var id: Int?

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
        case ShowArchived(_:Bool)
        case AllOnAccount(_:Bool)
        case Type(_:StoryType)

        public var paramName: String {
            get {
                switch self {
                case .ShowArchived(_):
                    return "show_archived"
                case .AllOnAccount(_):
                    return "all_on_account"
                case .Type(_):
                    return "story_type"
                }
            }
        }

        public var queryParam: MavenlinkQueryParams {
            get {
                var value: AnyObject
                switch self {
                case .ShowArchived(let show):
                    value = show
                case .AllOnAccount(let show):
                    value = show
                case .Type(let type):
                    value = type.rawValue
                }
                return [self.paramName: value]
            }
        }
    }

    public init?(_ map: Map) { }

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

    public static func nextStoryReducer(accumulator: Story?, current: Story) -> Story? {
        // If the task is completed, don't return it
        guard !current.isCompleted else { return accumulator }
        // If the accumulator is nil, return current if it's not completed
        guard let accumulatorDue = accumulator?.due_date else {
            return (!current.isCompleted ? current : nil)
        }
        // If current has no due date, don't return it
        guard let currentDue = current.due_date else { return accumulator }

        // At this point, return the item with the soonest due date
        return (currentDue.timeIntervalSinceDate(accumulatorDue) < 0)
            ? current
            : accumulator
    }

    static func getUpcomingStory(stories: [Story]?, date: NSDate) -> Story? {
        let now = NSDate()
        guard let storyArray = stories else { return nil }
        let nextStory = storyArray.reduce(nil) { (var result, story) -> Story? in
            if let resultDueDate = result?.due_date, nextDueDate = story.due_date {
                result = (nextDueDate.timeIntervalSinceDate(resultDueDate) > 0
                    && now.timeIntervalSinceDate(nextDueDate) > 0)
                    ? story
                    : result
            }
            return result
        }
        return nextStory
    }
}

public class StoryService: MavenlinkResourceService<Story> {
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

