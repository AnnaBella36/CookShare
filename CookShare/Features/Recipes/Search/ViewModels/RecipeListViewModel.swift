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
    
    private var apiClient: APIClientProtocol
    private var lastQuery: String?
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
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
}

