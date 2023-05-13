//
//  ListViewModelTests.swift
//  OnTopPokeTests
//
//  Created by Lucas Farah on 13/05/23.
//

import XCTest
@testable import OnTopPoke

final class ListViewModelTests: XCTestCase {

    func testInformationUpdatedAfterFetchingSuccess() {
        let requestHandler = FakeRequestHandler()
        let viewModel = ListViewModel(requestHandler: requestHandler)
        
        // create the expectation
        let exp = expectation(description: "reloadData called")

        viewModel.reloadData = {
            exp.fulfill()
        }
        
        viewModel.showError = { _ in
            XCTFail("Error is being called in a success state")
        }

        viewModel.fetchSpecies()

        waitForExpectations(timeout: 3)
        XCTAssertTrue(viewModel.species.count > 0)
    }
    
    func testErrorShownAfterFailure() {
        let requestHandler = FakeRequestHandler()
        requestHandler.isError = true
        let viewModel = ListViewModel(requestHandler: requestHandler)
        
        // create the expectation
        let exp = expectation(description: "error shown")

        viewModel.showError = { _ in
            exp.fulfill()
        }
        
        viewModel.fetchSpecies()

        waitForExpectations(timeout: 3)
    }
}
