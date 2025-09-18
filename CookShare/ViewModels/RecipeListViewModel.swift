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
    
    private var api: APIClientProtocol
    
    init(api: APIClientProtocol) {
        self.api = api
    }
    
    func search(_ query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            recipes = []
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let endpoint = Endpoint.searchMeals(query: query)
            let response = try await api.fetch(MealSearchResponse.self, from: endpoint)
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
    static func make(deps: AppDependencies) -> RecipeListViewModel {
        RecipeListViewModel(api: deps.api)
    }
}
