//
//  CategoryListView.swift
//  CookShare
//
//  Created by Olga Dragon on 12.10.2025.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var viewModel: RecipeListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var onSelect: (String) -> Void
    
    var body: some View {
        NavigationStack {
            List(viewModel.categories) { category in
                Button(category.name) {
                    onSelect(category.name)
                    dismiss()
                }
            }
            .navigationTitle("Categories")
            .task {
                await viewModel.fetchCategories()
            }
        }
    }
}

#Preview {
    CategoryListView { _ in }
        .environmentObject(RecipeListViewModel(apiClient: MockAPIClient()))
}

