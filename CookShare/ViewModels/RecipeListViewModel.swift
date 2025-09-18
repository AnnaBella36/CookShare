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
    
    private var apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func reset() {
        recipes = []
        errorMessage = nil
        isLoading = false
    }
    
    func search(_ query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            reset()
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let endpoint = Endpoint.searchMeals(query: query)
            let response = try await apiClient.fetch(MealSearchResponse.self, from: endpoint)
            recipes = response.meals ?? []
        } catch {
            errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
        }
        isLoading = false
    }
    
    func loadInitial() async {
        await search("pasta")
    }
}

extension RecipeListViewModel {
    static func make(deps: AppContainer) -> RecipeListViewModel {
        RecipeListViewModel(apiClient: deps.apiClient)
    }
}

