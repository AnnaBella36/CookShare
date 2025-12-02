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
    private let socialStore: SocialViewModel
    
    init() {
        let container: AppContainer
        
#if DEBUG
        if ProcessInfo.processInfo.arguments.contains("UITests_AutoLogin") {
            container = AppContainer(
                apiClient: MockAPIClient(),
                authService: MockAuthService()
            )
        } else {
            container = AppContainer(
                apiClient: APIClient(),
                authService: KeychainAuthService()
            )
        }
#else
        container = AppContainer(
            apiClient: APIClient(),
            authService: KeychainAuthService()
        )
#endif
        
        dependencies = container
        viewModel = RecipeListViewModel(apiClient: container.apiClient)
        authViewModel = AuthViewModel(authService: container.authService)
        socialStore = SocialViewModel()
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
