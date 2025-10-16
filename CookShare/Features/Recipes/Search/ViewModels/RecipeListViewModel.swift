//
//  RecipeListViewModel.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import Foundation

@MainActor
final class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasSearched = false
    
    @Published var categories: [Category] = []
    @Published var areas: [Area] = []
    @Published var selectedCategory: String? = nil
    @Published var selectedArea: String? = nil
    @Published var showOnlyFavorites = false
    
    private var apiClient: APIClientProtocol
    private var lastQuery: String?
    
    var hasFiltersApplied: Bool {
        selectedCategory != nil || selectedArea != nil || showOnlyFavorites
    }
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func resetFilters() {
        selectedCategory = nil
        selectedArea = nil
        showOnlyFavorites = false
    }
    
    func reset() {
        recipes = []
        errorMessage = nil
        isLoading = false
        lastQuery = nil
    }
    
    func search(_ query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            reset()
            hasSearched = false
            return
        }
        
        if trimmed == lastQuery {
            return
        }
        
        isLoading = true
        errorMessage = nil
        hasSearched = true
        
        do {
            let endpoint = Endpoint.searchMeals(query: query)
            let response = try await apiClient.fetch(MealSearchResponse.self, from: endpoint)
            recipes = response.meals ?? []
            lastQuery = trimmed
        } catch {
            errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
        }
        isLoading = false
    }
    
    func fetchCategories() async {
        do {
            let response = try await apiClient.fetch(CategoryResponse.self, from: .listCategories())
            categories = response.meals
        } catch {
            print("⚠️ Categories fetch failed:", error)
        }
    }
    
    func fetchAreas() async {
        do {
            let response = try await apiClient.fetch(AreaResponse.self, from: .listAreas())
            areas = response.meals
        } catch {
            print("⚠️ Areas fetch failed:", error)
        }
    }
    
    func filteredRecipes(from allRecipes: [Recipe], favorites: Set<String>) -> [Recipe] {
        allRecipes.filter { recipe in
          let matchesCategory = selectedCategory == nil || recipe.category == selectedCategory
            let matchesArea = selectedArea == nil || recipe.area == selectedArea
            let matchesFavorites = !showOnlyFavorites || favorites.contains(recipe.id)
            return matchesCategory && matchesArea && matchesFavorites
        }
    }
}

