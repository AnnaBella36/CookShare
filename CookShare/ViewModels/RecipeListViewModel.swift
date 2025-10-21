//
//  RecipeListViewModel.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import Foundation
import Combine

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
    
    @Published var searchQuery: String = ""
    
    private var apiClient: APIClientProtocol
    private var lastQuery: String?
    private var cancellables = Set<AnyCancellable>()
    private let networkMonitor = NetworkMonitor.shared
    private let cache = OfflineCache.shared
    
    var hasFiltersApplied: Bool {
        selectedCategory != nil || selectedArea != nil || showOnlyFavorites
    }
    
    var shouldShowResetButton: Bool {
        hasFiltersApplied || isSearchActive
    }
    
    private var isSearchActive: Bool {
        !trimmedSearchQuery.isEmpty
    }
    
    private var trimmedSearchQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isSearchQueryEmpty: Bool {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard let self else {return}
                let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    self.resetSearchState()
                    self.hasSearched = false
                } else if trimmed.count < 3 {
                    self.recipes = []
                    self.hasSearched = false
                } else {
                    Task { await self.performSearch(trimmed)}
                }
            }
            .store(in: &cancellables)
        
        observeNetworkChanges()
    }
    
    private func observeNetworkChanges() {
        networkMonitor.$isConnected
            .sink { [weak self] connected in
                if connected {
                    Task { await self?.syncCachedData() }
                }
            }
            .store(in: &cancellables)
    }
    
    private func syncCachedData() async{
        guard !recipes.isEmpty else { return }
        await performSearch(searchQuery)
    }
    
    func resetFilters() {
        selectedCategory = nil
        selectedArea = nil
        showOnlyFavorites = false
    }
    
    func resetSearchState() {
        recipes = []
        errorMessage = nil
        isLoading = false
        lastQuery = nil
    }
    
    func resetAll() {
        searchQuery = ""
        resetFilters()
        selectedArea = nil
        showOnlyFavorites = false
    }
    
    func performSearch(_ query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            resetSearchState()
            hasSearched = false
            return
        }
        
        if trimmed == lastQuery {
            return
        }
        
        if !networkMonitor.isConnected {
            recipes = cache.load()
            errorMessage = "Offline mode — showing cached results."
            hasSearched = true
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
            cache.save(recipes)
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
            print("Categories fetch failed:", error)
        }
    }
    
    func fetchAreas() async {
        do {
            let response = try await apiClient.fetch(AreaResponse.self, from: .listAreas())
            areas = response.meals
        } catch {
            print("Areas fetch failed:", error)
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

