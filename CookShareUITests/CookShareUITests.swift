//
//  CookShareHomeUITests.swift
//  CookShareHomeUITests
//
//  Created by Olga Dragon on 30.10.2025.
//

import XCTest

@MainActor
final class CookShareUITests: XCTest {
    
    func testLaunchAutoLoggedAndSearchFlow() {
        //Arrange
        let app = XCUIApplication()
        app.launchArguments.append("UITests_AutoLogin")
        //Act
        app.launch()
        //Assert
        XCTAssertTrue(app.tabBars.buttons["Search"].exists, "Search tab not found")
        //Act
        app.tabBars.buttons["Search"].tap()
        //Assert
        XCTAssertTrue(app.navigationBars["CookBook"].waitForExistence(timeout: 3.0))
        //Arrange
        let searchField = app.textFields["searchButton"]
        //Assert
        XCTAssertTrue(searchField.waitForExistence(timeout: 3.0), "Search field not found")
        //Act
        searchField.tap()
        searchField.typeText("pasta")
        //Arrange
        let searchButton = app.buttons["searchButton"]
        //Assert
        XCTAssertTrue(searchButton.exists, "Search button not found")
        //Act
        searchButton.tap()
        //Asesert
        let cell = app.staticTexts["Spicy Arrabiata Penne"]
        XCTAssertTrue(cell.waitForExistence(timeout: 5.0), "No search results found")
    }
}

