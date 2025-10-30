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
        let viewModel = RecipeListViewModel(apiClient: MockAPIClient())
        await viewModel.performSearch("pasta")
        XCTAssertTrue(viewModel.hasSearched)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.recipes, PreviewData.recipes)
    }

    func testFilteredRecipesAppliesAllFilters() async {
        let viewModel = RecipeListViewModel(apiClient: MockAPIClient())
        await viewModel.performSearch("any")

        viewModel.selectedCategory = "Vegetarian"
        viewModel.selectedArea = "Italian"
        viewModel.showOnlyFavorites = true

        let favorites: Set<String> = ["52771"]
        let displayed = viewModel.filteredRecipes(from: PreviewData.recipes, favorites: favorites)
        XCTAssertEqual(displayed.map { $0.id }, ["52771"])
    }

    func testOfflineLoadsFromCacheWhenNoNetwork() async {
        OfflineCahce.shared.save(PreviewData.recipes)
       
        NetworkMonitor.shared._setConnectionForTests(false)

        let viewModel = RecipeListViewModel(apiClient: MockAPIClient())
        await viewModel.performSearch("pasta")

        XCTAssertEqual(viewModel.recipes, PreviewData.recipes)
        XCTAssertEqual(viewModel.errorMessage, "Offline mode — showing cached results.")

        NetworkMonitor.shared._setConnectionForTests(true)
    }

    func testResetAllClearsState() {
        let viewModel = RecipeListViewModel(apiClient: MockAPIClient())
        viewModel.searchQuery = "abc"
        viewModel.selectedArea = "Italian"
        viewModel.selectedCategory = "Vegetarian"
        viewModel.showOnlyFavorites = true
        viewModel.recipes = PreviewData.recipes

        viewModel.resetAll()

        XCTAssertTrue(viewModel.searchQuery.isEmpty)
        XCTAssertNil(viewModel.selectedArea)
        XCTAssertNil(viewModel.selectedCategory)
        XCTAssertFalse(viewModel.showOnlyFavorites)
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }

}
