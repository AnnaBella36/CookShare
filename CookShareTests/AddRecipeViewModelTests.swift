//
//  AddRecipeViewModelTests.swift
//  CookShareHomeTests
//
//  Created by Olga Dragon on 30.10.2025.
//

import XCTest
@testable import CookShare

@MainActor
final class AddRecipeViewModelTests: XCTestCase {
    
    // MARK: - canSave property tests
    func testCanSaveIsFalseWhenTitleIsEmpty() {
        //Arrange
        let viewModel = AddRecipeViewModel()
        viewModel.title = ""
        //Act
        let result = viewModel.canSave
        //Assert
        XCTAssertFalse(result)
    }
    
    func testCanSaveIsFalseWhenTitleHasOnlySpaces() {
        //Arrange
        let viewModel = AddRecipeViewModel()
        viewModel.title = "  "
        //Act
        let result = viewModel.canSave
        //Assert
        XCTAssertFalse(result)
    }
    
    func testCanSaveIsTrueWhenTitleIsValid() {
        //Arrange
        let viewModel = AddRecipeViewModel()
        viewModel.title = "Pancakes"
        // Act
        let result = viewModel.canSave
        // Assert
        XCTAssertTrue(result)
    }
    // MARK: - makeUserRecipe tests
    
    func testMakeUserRecipeTrimsAndAllowsEmptyDescription() {
        //Arrange
        let viewModel = AddRecipeViewModel()
        viewModel.title = "  Pie  "
        viewModel.description = "   "
        //Act
        let result = viewModel.makeUserRecipe()
        //Assert
        XCTAssertEqual(result.title, "Pie")
        XCTAssertNil(result.description)
    }
    
    // MARK: - reset tests
    func testResetClearsState() {
        //Arrange
        let viewModel = AddRecipeViewModel()
        viewModel.title = "A"; viewModel.description = "B"
        //Act
        viewModel.reset()
        //Assert
        XCTAssertTrue(viewModel.title.isEmpty)
        XCTAssertTrue(viewModel.description.isEmpty)
        XCTAssertNil(viewModel.selectedImage)
    }
}

