//
//  AuthService.swift
//  CookShare
//
//  Created by Olga Dragon on 30.09.2025.
//

import Foundation
import CryptoKit

struct UserAccount: Codable, Equatable {
    let name: String
    let email: String
    let passwordHash: String
}

struct AuthSession: Codable, Equatable {
    let email: String
    let token: String
    let sessionCreationDate: Date
}

enum AuthValidationError: LocalizedError {
    case invalidEmail, weakPassword, emailAlreadyUsed, userNotFound, wrongPassword
    var errorDescription: String? {
        switch self {
            
        case .invalidEmail:
            return "Invalid email address"
        case .weakPassword:
            return "Password must be at least 8 characters long"
        case .emailAlreadyUsed:
            return "An account with this email already exists"
        case .userNotFound:
            return "User not found"
        case .wrongPassword:
            return "Incorrect password"
        }
    }
}

protocol AuthServiceProtocol {
    func signup(name: String, email: String, password: String) async throws -> AuthSession
    func login(email: String, password: String) async throws -> AuthSession
    func logout() async
    func restoreSession() async -> AuthSession?
}

final class KeychainAuthService: AuthServiceProtocol {
    private let sessionAccount = "session.current"
    
    private func simulateDelay() async {
        try? await Task.sleep(nanoseconds: 350_000_000)
    }
  
    private func sha256(_ text: String) -> String{
        let data = Data(text.utf8)
        return SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }
    
    private func isValidEmail(_ email: String) -> Bool{
        email.contains("@") && email.contains(".")
    }
    
    private func saveUser(_ user: UserAccount) throws {
        let data = try JSONEncoder().encode(user)
        try KeychainHelper.save(data, account: "user:\(user.email)")
       
    }
  
    private func loadUser(email: String) throws -> UserAccount? {
        guard let data = try KeychainHelper.load(account: "user:\(email)") else { return nil }
        return try JSONDecoder().decode(UserAccount.self, from: data)
    }

    private func saveSession(_ session: AuthSession) throws {
        let data = try JSONEncoder().encode(session)
        try KeychainHelper.save(data, account: sessionAccount)
    }

    private func loadSession() throws -> AuthSession? {
        guard let data = try KeychainHelper.load(account: sessionAccount) else {return nil}
        return try JSONDecoder().decode(AuthSession.self, from: data)

    }
   
    private func deleteSession() { KeychainHelper.delete(account: sessionAccount) }
  
    //MARK: AuthServiceProtocol
    func signup(name: String, email: String, password: String) async throws -> AuthSession {
        await simulateDelay()
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard isValidEmail(email) else { throw AuthValidationError.invalidEmail }
        guard password.count >= 8 else { throw AuthValidationError.weakPassword }

        if let _ = try loadUser(email: email) {
            throw AuthValidationError.emailAlreadyUsed
        }

        let user = UserAccount(name: name, email: email, passwordHash: sha256(password))
        try saveUser(user)

        let session = AuthSession(email: email, token: UUID().uuidString, sessionCreationDate: Date())
        try saveSession(session)
        return session
    }
    
    func login(email: String, password: String) async throws -> AuthSession {
        await simulateDelay()
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard isValidEmail(email) else { throw AuthValidationError.invalidEmail }

        guard let user = try loadUser(email: email) else { throw AuthValidationError.userNotFound }
        guard user.passwordHash == sha256(password) else { throw AuthValidationError.wrongPassword }

        let session = AuthSession(email: email, token: UUID().uuidString, sessionCreationDate: Date())
        try saveSession(session)
        return session
    }
    
    func logout() async {
        await simulateDelay()
        deleteSession()
    }
    
    func restoreSession() async -> AuthSession? {
        await simulateDelay()
        return try? loadSession()
    }
}

