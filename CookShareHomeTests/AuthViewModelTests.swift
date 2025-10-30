//
//  AuthViewModelTests.swift
//  CookShareHomeTests
//
//  Created by Olga Dragon on 30.10.2025.
//

import XCTest
@testable import CookShare
@MainActor
final class AuthViewModelTests: XCTestCase {
    
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

    func testSignupSuccessSetsSession() async {
        let service = InMemoryAuthService()
        let viewModel = AuthViewModel(authService: service)
        viewModel.name = "Olya"; viewModel.email = "o@a.com"; viewModel.password = "12345678"

        await viewModel.signup()

        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.session)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoginWrongPasswordShowsError() async {
        let service = InMemoryAuthService()
        _ = try? await service.signup(name: "O", email: "u@u.com", password: "correctpass")

        let viewModel = AuthViewModel(authService: service)
        viewModel.email = "u@u.com"; viewModel.password = "wrongpass"

        await viewModel.login()

        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testRestoreAfterSignup() async {
        let service = InMemoryAuthService()
        _ = try? await service.signup(name: "N", email: "x@x.com", password: "12345678")

        let viewModel = AuthViewModel(authService: service)
        await viewModel.restore()

        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.session?.email, "x@x.com")
    }
}
