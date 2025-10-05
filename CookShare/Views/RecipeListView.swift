//
//  RecipeListView.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import SwiftUI

struct RecipeListView: View {
    
    @EnvironmentObject var viewModel: RecipeListViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText: String = ""
    @FocusState private var searchFocused: Bool
    
    @State private var userRecipes: [UserRecipe] = []
    @State private var showAddRecipeView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                    .padding(.horizontal, 16)
                    .padding(.top)
                
                contentView
            }
            .navigationTitle("CookBook")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        authViewModel.logout()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showAddRecipeView = true
                    } label: {
                        Label("Add Recipe", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddRecipeView) {
                AddRecipeView { recipe in
                    userRecipes.append(recipe)
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var searchBar: some View {
        HStack {
            TextField("Search recipes (e.g. “pasta”)", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .focused($searchFocused)
                .onSubmit { performSearch() }
                .onChange(of: searchText) { newValue in
                    if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        viewModel.reset()
                    }
                }
            
            Button {
                performSearch()
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
            if userRecipes.isEmpty {
                ContentUnavailableView(
                    "Search",
                    systemImage: "magnifyingglass",
                    description: Text("Type a query to find recipes.")
                )
                .padding()
            } else {
                List{
                    userRecipesSection()
                }
                .listStyle(.plain)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
        } else if let message = viewModel.errorMessage {
            ContentUnavailableView("Error",
                                   systemImage: "exclamationmark.triangle",
                                   description: Text(message))
            .padding()
        } else if viewModel.recipes.isEmpty && viewModel.hasSearched && userRecipes.isEmpty {
            ContentUnavailableView(
                "No results",
                systemImage: "fork.knife",
                description: Text("Try searching for “pasta”, “chicken”, etc.")
            )
            .padding()
        } else {
            List{
                if !userRecipes.isEmpty {
                    userRecipesSection()
                }
                Section("Results") {
                    ForEach(viewModel.recipes) { recipe in
                        NavigationLink { RecipeDetailView(recipe: recipe) } label: {
                            RecipeRow(recipe: recipe)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
    }
    
    private func  userRecipesSection() -> some View {
        Section("My Recipes") {
            ForEach(userRecipes) { recipe in
                userRecipeRow(recipe)
            }
        }
    }
    
    private func userRecipeRow(_ recipe: UserRecipe) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.08))
                if let image = recipe.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.body)
                    .lineLimit(1)
                if let desc = recipe.description, !desc.isEmpty {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
    }
    private func performSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
            .environmentObject(AuthViewModel())
    }
}

