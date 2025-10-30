//
//  CookShareApp.swift
//  CookShare
//
//  Created by Olga Dragon on 21.08.2025.
//

import SwiftUI

@main
struct CookShareApp: App {
    
#if DEBUG
    private var isUITest: Bool {
        ProcessInfo.processInfo.arguments.contains("UITests_AutoLogin")
    }
#endif
    
    
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
                authService: UITestsAuthService()
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

#if DEBUG
struct UITestsAuthService: AuthServiceProtocol {
    func signup(name: String, email: String, password: String) async throws -> AuthSession {
        AuthSession(email: email, token: "ui-tests-token", sessionCreationDate: Date())
    }
    
    func login(email: String, password: String) async throws -> AuthSession {
        AuthSession(email: email, token: "ui-tests-token", sessionCreationDate: Date())
    }
    
    func logout() async {}
    
    func restoreSession() async -> AuthSession? {
        AuthSession(email: "ui@test.com", token: "ui-tests-token", sessionCreationDate: Date())
    }
}
#endif
