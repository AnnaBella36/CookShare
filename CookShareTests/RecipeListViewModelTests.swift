//
//  RecipeListViewModelTests.swift
//  CookShareHomeTests
//
//  Created by Olga Dragon on 30.10.2025.
//

import XCTest
@testable import CookShare

@MainActor
final class RecipeListViewModelTests: XCTest {
    
    func testPerformSearchLoadsRecipesFromNetwork() async {
        //Arrange
        let viewModel = RecipeListViewModel(apiClient: MockAPIClient())
        //Act
        await viewModel.performSearch("pasta")
        //Assert
        XCTAssertTrue(viewModel.hasSearched)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.recipes, PreviewData.recipes)
    }

    func testFilteredRecipesAppliesAllFilters() async {
        //Arrange
        let viewModel = RecipeListViewModel(apiClient: MockAPIClient())
        //Act
        await viewModel.performSearch("any")
        //Arrange
        viewModel.selectedCategory = "Vegetarian"
        viewModel.selectedArea = "Italian"
        viewModel.showOnlyFavorites = true
        let favorites: Set<String> = ["52771"]
        //Act
        let displayed = viewModel.filteredRecipes(from: PreviewData.recipes, favorites: favorites)
        //Assert
        XCTAssertEqual(displayed.map { $0.id }, ["52771"])
    }

    func testOfflineLoadsFromCahceWhenNoNetwork() async {
        //Arrange
        OfflineCahce.shared.save(PreviewData.recipes)
        let _ = FakeNetworkMonitor(isConnected: false)
        let viewModel = RecipeListViewModel(apiClient: MockAPIClient())
        //Act
        await viewModel.performSearch("pasta")
        //Assert
        XCTAssertEqual(viewModel.recipes, PreviewData.recipes)
        XCTAssertEqual(viewModel.errorMessage, "Offline mode — showing cached results.")
    }

    func testResetAllClearsState() {
        //Arrange
        let viewModel = RecipeListViewModel(apiClient: MockAPIClient())
        viewModel.searchQuery = "abc"
        viewModel.selectedArea = "Italian"
        viewModel.selectedCategory = "Vegetarian"
        viewModel.showOnlyFavorites = true
        viewModel.recipes = PreviewData.recipes
        //Act
        viewModel.resetAll()
        //Assert
        XCTAssertTrue(viewModel.searchQuery.isEmpty)
        XCTAssertNil(viewModel.selectedArea)
        XCTAssertNil(viewModel.selectedCategory)
        XCTAssertFalse(viewModel.showOnlyFavorites)
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }

}
