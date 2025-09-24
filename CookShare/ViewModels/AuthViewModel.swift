//
//  AuthViewModel.swift
//  CookShare
//
//  Created by Olga Dragon on 23.09.2025.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func login() async {
        errorMessage = nil
        if email.trimmingCharacters(in: .whitespaces).isEmpty ||
            password.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Enter email and password"
             return
        }
        
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        isLoading = true
        
        isAuthenticated = true
    }
    
    func signup() async {
        errorMessage = nil
        if name.trimmingCharacters(in: .whitespaces).isEmpty ||
            email.trimmingCharacters(in: .whitespaces).isEmpty ||
            password.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Fill in all the fields"
            return
        }
        
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_00)
        isLoading = false
        
        isAuthenticated = true
    }
    
    func logout() {
        isAuthenticated = false
        name = ""
        email = ""
        password = ""
        errorMessage = nil
        isLoading = false 
    }
}
