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
    @EnvironmentObject var social: SocialViewModel
    @State private var searchText: String = ""
    @FocusState private var searchFocused: Bool
   
    @State private var showAddRecipeView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                    .padding(.horizontal, 16)
                    .padding(.top)
                filtersBar()
                contentView
            }
            .task {
                await viewModel.fetchCategories()
                await viewModel.fetchAreas()
            }
            .navigationTitle("CookBook")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        authViewModel.logout()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showAddRecipeView = true
                    } label: {
                        Label("Add Recipe", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddRecipeView) {
                AddRecipeView { recipe in
                    social.addMyRecipe(recipe)
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
    private func filtersBar() -> some View {
        HStack(spacing: 12) {
            Menu {
                Button("All Categories") { viewModel.selectedCategory = nil }
                ForEach(viewModel.categories) { cat in
                    Button(cat.name) { viewModel.selectedCategory = cat.name }
                }
            } label: {
                Label(viewModel.selectedCategory ?? "Category", systemImage: "tag")
            }
            Menu {
                Button("All Areas") { viewModel.selectedArea = nil }
                ForEach(viewModel.areas) { area in
                    Button(area.name) { viewModel.selectedArea = area.name }
                }
            } label: {
                Label(viewModel.selectedArea ?? "Area", systemImage: "globe.europe.africa")
            }
            Toggle(isOn: $viewModel.showOnlyFavorites) {
                Image(systemName: "heart.fill")
                    .imageScale(.medium)
            }
            .toggleStyle(.button)
            .accessibilityLabel("Favorites only")
            
            if viewModel.selectedCategory != nil || viewModel.selectedArea != nil || viewModel.showOnlyFavorites {
                Button("Reset") {
                    viewModel.selectedCategory = nil
                    viewModel.selectedArea = nil
                    viewModel.showOnlyFavorites = false
                }
                .buttonStyle(.bordered)
            }
        }
        .font(.footnote)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            ProgressView("Loading...").padding()
        } else if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if social.myRecipes.isEmpty {
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
        } else if viewModel.recipes.isEmpty && viewModel.hasSearched && social.myRecipes.isEmpty {
            ContentUnavailableView(
                "No results",
                systemImage: "fork.knife",
                description: Text("Try searching for “pasta”, “chicken”, etc.")
            )
            .padding()
        } else {
            List{
                if !social.myRecipes.isEmpty {
                    userRecipesSection()
                }
                Section("Results") {
                    let displayed = viewModel.filteredRecipes(
                                           from: viewModel.recipes,
                                           favorites: social.favorites
                                       )
                    ForEach(displayed) { recipe in
                        NavigationLink { RecipeDetailView(recipe: recipe) } label: {
                            RecipeRow(recipe: recipe)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                social.toggleFavorite(for: recipe)
                            } label: {
                                Label("Like", systemImage: social.isFavorite(recipe) ? "heart.fill" : "heart")
                            }
                            .tint(.red)
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
            ForEach(social.myRecipes) { recipe in
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

