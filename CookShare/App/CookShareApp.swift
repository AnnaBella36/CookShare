//
//  CookShareApp.swift
//  CookShare
//
//  Created by Olga Dragon on 21.08.2025.
//

import SwiftUI

@main
struct CookShareApp: App {
    
    private let dependencies: AppContainer
    private let viewModel: RecipeListViewModel
    private let authViewModel: AuthViewModel
    private let socialStore: SocialStore
    init() {
        let container = AppContainer(apiClient: APIClient(), authService: KeychainAuthService())
        self.dependencies = container
        self.viewModel = RecipeListViewModel(apiClient: container.apiClient)
        self.authViewModel = AuthViewModel(authService: container.authService)
        self.socialStore = SocialStore()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewModel)
                .environmentObject(authViewModel)
                .environmentObject(socialStore)
        }
    }
}

