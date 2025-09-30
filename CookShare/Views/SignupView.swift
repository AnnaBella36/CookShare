//
//  SignupView.swift
//  CookShare
//
//  Created by Olga Dragon on 24.09.2025.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var viewModel: AuthViewModel
    var onSwitchToLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Create account")
                .font(.title.bold())
            
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $viewModel.password)
                .textContentType(.newPassword)
                .textFieldStyle(.roundedBorder)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }
            
            if viewModel.isLoading {
                ProgressView("Creating...")
            } else {
                Button("Sing Up") {
                    Task { await viewModel.signup()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.name.isEmpty || viewModel.email.isEmpty || viewModel.password.isEmpty)
            }
            
            Button("I already have an account") {
                onSwitchToLogin()
            }
            .font(.footnote)
            .padding(.top, 8)
        }
        .padding()
    }
}
