//
//  ContentView.swift
//  CookShare
//
//  Created by Olga Dragon on 21.08.2025.
//

import SwiftUI

struct RootView: View {
    
    let deps: AppDependencies
    
    var body: some View {
        NavigationStack{
            RecipeListView()
                .navigationTitle("CookBook")
        }
    }
}

#Preview {
    struct MockAPI: APIClientProtocol {
        func fetch<T>(_ type: T.Type, from endpoint: Endpoint) async throws -> T where T : Decodable {
            if T.self == MealSearchResponse.self {
                return MealSearchResponse(meals: PreviewData.recipes) as! T
            }
            throw APIError.noData
        }
    }
    let deps = AppDependencies(api: MockAPI())
    let vm = RecipeListViewModel(api: deps.api)
    return NavigationStack {
        RootView(deps: deps)
            .environmentObject(vm) 
    }
}
