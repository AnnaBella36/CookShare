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
    
    func testCanSaveDependsOnTitle() {
        let viewModel = AddRecipeViewModel()
        XCTAssertFalse(viewModel.canSave)
        viewModel.title = "  "
        XCTAssertFalse(viewModel.canSave)
        viewModel.title = "Pancakes"
        XCTAssertTrue(viewModel.canSave)
    }
    
    func testMakeUserRecipeTrimsAndAllowsEmptyDescription() {
        let viewModel = AddRecipeViewModel()
        viewModel.title = "  Pie  "
        viewModel.description = "   "
        let r = viewModel.makeUserRecipe()
        XCTAssertEqual(r.title, "Pie")
        XCTAssertNil(r.description)
    }
    
    func testResetClearsState() {
        let viewModel = AddRecipeViewModel()
        viewModel.title = "A"; viewModel.description = "B"
        viewModel.reset()
        XCTAssertTrue(viewModel.title.isEmpty)
        XCTAssertTrue(viewModel.description.isEmpty)
        XCTAssertNil(viewModel.selectedImage)
    }
}

