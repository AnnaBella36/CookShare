//
//  AuthViewModel.swift
//  CookShare
//
//  Created by Olga Dragon on 23.09.2025.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    
    private let authenticationService: AuthServiceProtocol
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published private(set) var session: AuthSession?
    
    init(authService: AuthServiceProtocol = KeychainAuthService()) {
        self.authenticationService = authService
        Task{ await restore() }
    }
    
    func restore() async {
        isLoading = true
        errorMessage = nil
        session = await authenticationService.restoreSession()
        isAuthenticated = (session != nil)
        isLoading = false
    }
    
    func login() async {
        errorMessage = nil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "Enter email and password"
            return
        }
        isLoading = true
        do {
            let newSession = try await authenticationService.login(email: trimmedEmail, password: trimmedPassword)
            session = newSession
            isAuthenticated = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            isAuthenticated = false
        }
        isLoading = false
    }
    
    func signup() async {
        errorMessage = nil
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty, !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return }
        
        isLoading = true
        do {
            let createdSession = try await authenticationService.signup(name: trimmedName,
                                                                        email: trimmedEmail,
                                                                        password: trimmedPassword)
            session = createdSession
            isAuthenticated = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            isAuthenticated = false
        }
        isLoading = false
    }
    
    func logout() {
        Task {
            isLoading = true
            await authenticationService.logout()
            session = nil
            isAuthenticated = false
            name = ""; email = ""; password = ""
            errorMessage = nil
            isLoading = false
        }
    }
}
