//
//  WorkspaceTests.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Mockingjay
import ObjectMapper

class WorkspaceTests: SwiftyMavenlinkTestBase {
    
    func testTimeEntryDataMapping() {
        let jsonText = self.singleJsonFixture(Workspace)
        let result = Mapper<Workspace>().map(jsonText)!
        let message = "No properties should be nil, mapping test data should always succeed"
        XCTAssertNotNil(result.access_level, message)
        XCTAssertNotNil(result.archived, message)
        XCTAssertNotNil(result.budget_used, message)
        XCTAssertNotNil(result.budget_used_in_cents, message)
        XCTAssertNotNil(result.budgeted, message)
        XCTAssertNotNil(result.can_create_line_items, message)
        XCTAssertNotNil(result.can_invite, message)
        XCTAssertNotNil(result.change_orders_enabled, message)
        XCTAssertNotNil(result.client_role_name, message)
        XCTAssertNotNil(result.consultant_role_name, message)
        XCTAssertNotNil(result.created_at, message)
        XCTAssertNotNil(result.creator_id, message)
        XCTAssertNotNil(result.currency, message)
        XCTAssertNotNil(result.currency_base_unit, message)
        XCTAssertNotNil(result.currency_symbol, message)
        XCTAssertNotNil(result.default_rate, message)
        XCTAssertNotNil(result.workspace_description, message)
        XCTAssertNotNil(result.due_date, message)
        XCTAssertNotNil(result.effective_due_date, message)
        XCTAssertNotNil(result.exclude_archived_stories_percent_complete, message)
        XCTAssertNotNil(result.expenses_in_burn_rate, message)
        XCTAssertNotNil(result.has_budget_access, message)
        XCTAssertNotNil(result.id, message)
        XCTAssertNotNil(result.over_budget, message)
        XCTAssertNotNil(result.percentage_complete, message)
        XCTAssertNotNil(result.posts_require_privacy_decision, message)
        XCTAssertNotNil(result.price, message)
        XCTAssertNotNil(result.price_in_cents, message)
        XCTAssertNotNil(result.rate_card_id, message)
        XCTAssertNotNil(result.require_expense_approvals, message)
        XCTAssertNotNil(result.require_time_approvals, message)
        XCTAssertNotNil(result.start_date, message)
        XCTAssertNotNil(result.status, message)
        XCTAssertNotNil(result.tasks_default_non_billable, message)
        XCTAssertNotNil(result.title, message)
        XCTAssertNotNil(result.total_expenses_in_cents, message)
        XCTAssertNotNil(result.updated_at, message)
//        XCTAssertNotNil(result.workspace_invoice_preference_id, message)

        // Test nested elements
        XCTAssertNotNil(result.status?.color, message)
        XCTAssertNotNil(result.status?.key, message)
        XCTAssertNotNil(result.status?.message, message)
    }

    func testWorkspaceSearchParam() {
        let searchTerm = "testing"
        setupQueryParamTestExpectation(Workspace.Params.Search.rawValue, expectedValue: searchTerm, uriTemplate: uriPath(Workspace)) {
            WorkspaceService.get(searchTerm).getNextPage()
        }

    }

    func testWorkspaceMatchingNameParam() {
        let matchingName = "testing"
        setupQueryParamTestExpectation(GenericParams.Search(matchingName).paramName(), expectedValue: matchingName, uriTemplate: uriPath(Workspace)) {
            WorkspaceService.search(matchingName, includeArchived: true).getNextPage()
        }
    }

    func testIncludeArchiveParam() {
        let includeArchived = true
        setupQueryParamTestExpectation(Workspace.Params.IncludeArchived.rawValue, expectedValue: "1", uriTemplate: uriPath(Workspace)) {
            WorkspaceService.get(includeArchived: includeArchived).getNextPage()
        }

        setupQueryParamTestExpectation(Workspace.Params.IncludeArchived.rawValue, expectedValue: "1", uriTemplate: uriPath(Workspace)) {
            WorkspaceService.search("test", includeArchived: includeArchived).getNextPage()
        }

        setupQueryParamTestExpectation(Workspace.Params.IncludeArchived.rawValue, expectedValue: "1", uriTemplate: uriPath(Workspace)) {
            WorkspaceService.getWorkspace(9999, includeArchived: includeArchived)
        }
    }

    func testGetSpecificWorkspace() {
        let id = 123458
        setupQueryParamTestExpectation(Workspace.Params.Only.rawValue, expectedValue: String(id), uriTemplate: uriPath(Workspace)) {
            WorkspaceService.getWorkspace(id)
        }
    }
}
