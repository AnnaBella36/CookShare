//
//  InMemoryAuthService.swift
//  CookShareHomeTests
//
//  Created by Olga Dragon on 01.11.2025.
//

import Foundation
@testable import CookShare

final class InMemoryAuthService: AuthServiceProtocol {
    var users: [String: UserAccount] = [:]
    var current: AuthSession?

    func signup(name: String, email: String, password: String) async throws -> AuthSession {
        let key = email.lowercased()
        if users[key] != nil { throw AuthValidationError.emailAlreadyUsed }
        guard email.contains("@") else { throw AuthValidationError.invalidEmail }
        guard password.count >= 8 else { throw AuthValidationError.weakPassword }
        users[key] = UserAccount(name: name, email: key, passwordHash: "hash:\(password)")
        current = AuthSession(email: key, token: "t", sessionCreationDate: Date())
        return current!
    }

    func login(email: String, password: String) async throws -> AuthSession {
        let key = email.lowercased()
        guard let user = users[key] else { throw AuthValidationError.userNotFound }
        guard user.passwordHash == "hash:\(password)" else { throw AuthValidationError.wrongPassword }
        current = AuthSession(email: key, token: "t", sessionCreationDate: Date())
        return current!
    }

    func logout() async { current = nil }
    func restoreSession() async -> AuthSession? { current }
}
