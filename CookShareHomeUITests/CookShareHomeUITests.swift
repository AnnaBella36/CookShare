//
//  CookShareHomeUITests.swift
//  CookShareHomeUITests
//
//  Created by Olga Dragon on 30.10.2025.
//

import XCTest

@MainActor
final class CookShareHomeUITests: XCTest {
    
    func testLaunchAutoLoggedAndSearchFlow() {
        let app = XCUIApplication()
        app.launchArguments.append("UITests_AutoLogin")
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Search"].exists, "Search tab not found")
        app.tabBars.buttons["Search"].tap()

        XCTAssertTrue(app.navigationBars["CookBook"].waitForExistence(timeout: 3.0))

        let searchField = app.textFields["searchButton"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3.0), "Search field not found")
        searchField.tap()
        searchField.typeText("pasta")

        let searchButton = app.buttons["searchButton"]
        XCTAssertTrue(searchButton.exists, "Search button not found")
        searchButton.tap()

        let cell = app.staticTexts["Spicy Arrabiata Penne"]
        XCTAssertTrue(cell.waitForExistence(timeout: 5.0), "No search results found")

        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 3.0))
        app.tabBars.buttons["Search"].tap()
        XCTAssertTrue(app.navigationBars["CookBook"].exists)
    }
    
}
