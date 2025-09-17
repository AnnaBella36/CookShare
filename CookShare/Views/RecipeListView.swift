//
//  RecipeListView.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var vm: RecipeListViewModel
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            searchBar
                .padding(.horizontal)
                .padding(.top)

            contentView
        }
        .task {
            await vm.loadInitial()
        }
    }

    // MARK: - Subviews

    private var searchBar: some View {
        HStack {
            TextField("Search recipes (e.g. “pasta”)", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit { Task { await vm.search(searchText) } }

            Button {
                Task { await vm.search(searchText) }
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.bordered)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if vm.isLoading {
            ProgressView("Loading...").padding()
        } else if let message = vm.errorMessage {
            ContentUnavailableView("Error",
                                   systemImage: "exclamationmark.triangle",
                                   description: Text(message))
            .padding()
        } else if vm.recipes.isEmpty {
            ContentUnavailableView(
                "No results",
                systemImage: "fork.knife",
                description: Text("Try searching for “pasta”, “chicken”, etc.")
            )
            .padding()
        } else {
            listView
        }
    }

    private var listView: some View {
        List(vm.recipes) { recipe in
            NavigationLink {
                RecipeDetailView(recipe: recipe)
            } label: {
                RecipeRow(recipe: recipe)
            }
        }
        .listStyle(.plain)
    }
}

#Preview("Loaded") {
    struct MockAPI: APIClientProtocol {
        func fetch<T>(_ type: T.Type, from endpoint: Endpoint) async throws -> T where T : Decodable {
            if T.self == MealSearchResponse.self {
                return MealSearchResponse(meals: PreviewData.recipes) as! T
            }
            throw APIError.noData
        }
    }
    let vm = RecipeListViewModel(api: MockAPI())
    return NavigationStack {
        RecipeListView()
            .environmentObject(vm)
    }
}
