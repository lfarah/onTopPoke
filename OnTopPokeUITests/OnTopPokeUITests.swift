//
//  OnTopPokeUITests.swift
//  OnTopPokeUITests
//
//  Created by Lucas Farah on 12/05/23.
//

import XCTest

final class OnTopPokeUITests: XCTestCase {

    func testHappyPath() throws {
        let app = XCUIApplication()
        app.launch()
        
        let row = app.tables.staticTexts["ivysaur"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: row, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        row.tap()
        
        let ivysaurNavigationBar = app.navigationBars["ivysaur"]
        XCTAssert(ivysaurNavigationBar.exists)
        
        ivysaurNavigationBar.buttons["POKéMON"].tap()
    }
}
