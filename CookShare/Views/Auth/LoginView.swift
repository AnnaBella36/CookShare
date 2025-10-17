//
//  LoginView.swift
//  CookShare
//
//  Created by Olga Dragon on 23.09.2025.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    
    var onSwitchToSignup: () -> Void
    var onRestorePassword: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome back")
                .font(.title.bold())
            
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }
            
            if viewModel.isLoading {
                ProgressView("Singing in...")
            } else {
                Button("Sign In") {
                    Task {
                        await viewModel.login()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
            }
            
            Button("Forgot password?") {
                onRestorePassword()
            }
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            Button("Create account") {
                onSwitchToSignup()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.footnote)
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(), onSwitchToSignup: {})
}

