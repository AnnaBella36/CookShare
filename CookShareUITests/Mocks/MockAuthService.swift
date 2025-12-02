//
//  MockAuthService.swift
//  CookShareHomeUITests
//
//  Created by Olga Dragon on 01.11.2025.
//

import Foundation

#if DEBUG
@MainActor
struct MockAuthService: AuthServiceProtocol {
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
