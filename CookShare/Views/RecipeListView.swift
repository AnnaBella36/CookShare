//
//  RecipeListView.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import SwiftUI

struct RecipeListView: View {
    
    @EnvironmentObject var viewModel: RecipeListViewModel
    @State private var searchText: String = ""
    @FocusState private var searchFocused: Bool
    
    var body: some View {
        VStack {
            searchBar
                .padding(.horizontal, 16)
                .padding(.top)

            contentView
        }
        .task {
            if viewModel.recipes.isEmpty {
                await viewModel.loadInitial()
            }
                
        }
    }

    // MARK: - Subviews

    private var searchBar: some View {
        HStack {
            TextField("Search recipes (e.g. “pasta”)", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit { Task { await viewModel.search(searchText) } }
                .onChange(of: searchText) { newValue in
                    if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        viewModel.reset()
                    }
                }
            Button {
                Task { await viewModel.search(searchText) }
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.bordered)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            ProgressView("Loading...").padding()
        } else if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ContentUnavailableView(
                                   "Search",
                                   systemImage: "magnifyingglass",
                                   description: Text("Type a query to find recipes.")
                                   )
                                   .padding()
        } else if let message = viewModel.errorMessage {
            ContentUnavailableView("Error",
                                   systemImage: "exclamationmark.triangle",
                                   description: Text(message))
            .padding()
        } else if viewModel.recipes.isEmpty {
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
        List(viewModel.recipes) { recipe in
            NavigationLink {
                RecipeDetailView(recipe: recipe)
            } label: {
                RecipeRow(recipe: recipe)
            }
        }
        .listStyle(.plain)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    
    private func performSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchFocused = false
        Task {
            await viewModel.search(query)
            await MainActor.run {searchFocused = false }
        }
    }
}

#Preview("Loaded") {
    NavigationStack {
        RecipeListView()
            .environmentObject(RecipeListViewModel(apiClient: MockAPIClient()))
    }
}

