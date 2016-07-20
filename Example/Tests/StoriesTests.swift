//
//  StoriesTests.swift
//  
//
//  Created by Mike Maxwell on 7/19/16.
//
//

import XCTest
import Mockingjay
import ObjectMapper

class StoriesTests: SwiftyMavenlinkTestBase {
    
    override func setUp() {
        super.setUp()
        self.setUpFixtures(Story)
    }
    
    func testStoryDataMapping() {
        let jsonText = self.singleJsonFixture(Story)
        let result = Mapper<Story>().map(jsonText)!
        let message = "No properties should be nil, mapping test data should always succeed"
        XCTAssertNotNil(result.title, message)
        XCTAssertNotNil(result.description, message)
        XCTAssertNotNil(result.updated_at, message)
        XCTAssertNotNil(result.created_at, message)
        XCTAssertNotNil(result.due_date, message)
        XCTAssertNotNil(result.start_date, message)
        XCTAssertNotNil(result.story_type, message)
        XCTAssertNotNil(result.state, message)
        XCTAssertNotNil(result.position, message)
        XCTAssertNotNil(result.archived, message)
        XCTAssertNotNil(result.deleted_at, message)
        XCTAssertNotNil(result.sub_story_count, message)
        XCTAssertNotNil(result.percentage_complete, message)
        XCTAssertNotNil(result.priority, message)
        XCTAssertNotNil(result.has_proofing_access, message)
        XCTAssertNotNil(result.ancestor_ids, message)
        XCTAssertNotNil(result.subtree_depth, message)
        XCTAssertNotNil(result.time_trackable, message)
        XCTAssertNotNil(result.workspace_id, message)
        XCTAssertNotNil(result.creator_id, message)
        XCTAssertNotNil(result.parent_id, message)
        XCTAssertNotNil(result.root_id, message)
        XCTAssertNotNil(result.id, message)
    }
    
}
