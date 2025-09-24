//
//  ContentView.swift
//  CookShare
//
//  Created by Olga Dragon on 21.08.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var viewModel: RecipeListViewModel
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                AuthGateView(viewModel: authViewModel)
            } else {
                NavigationStack{
                    RecipeListView()
                        .navigationTitle("CookBook")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Logout") {
                                    authViewModel.logout()
                                }
                            }
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
    }
}

