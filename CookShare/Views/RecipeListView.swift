//
//  RecipeListView.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var vm = RecipeListViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            
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
            .padding(.horizontal)
            .padding(.top)
            
            if vm.isLoading {
                ProgressView("Loading...").padding()
            } else if let message = vm.errorMessage {
                ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(message))
                    .padding()
            } else if vm.recipes.isEmpty {
                ContentUnavailableView("No results",
                                       systemImage: "fork.knife",
                                       description: Text("Try searching for “pasta”, “chicken”, etc."))
                .padding()
            } else {
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
        .task {
            await vm.loadInitial()
        }
    }
}


#Preview("Loaded") {
    NavigationStack {
        RecipeListView() 
    }
}
