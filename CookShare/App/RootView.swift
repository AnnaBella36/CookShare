//
//  ContentView.swift
//  CookShare
//
//  Created by Olga Dragon on 21.08.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var viewModel: RecipeListViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                AuthGateView(viewModel: authViewModel)
            } else {
                TabView {
                    FeedView()
                        .tabItem {
                            Label("Feed", systemImage: "house.fill")
                        }
                    
                    RecipeListView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RootView()
            .environmentObject(RecipeListViewModel(apiClient: MockAPIClient()))
            .environmentObject(AuthViewModel())
    }
}

