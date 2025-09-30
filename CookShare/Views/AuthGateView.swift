//
//  AuthGateView.swift
//  CookShare
//
//  Created by Olga Dragon on 24.09.2025.
//

import SwiftUI

enum AuthFlow {
    case login
    case signup
    case restorePassword
}

struct AuthGateView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var flow: AuthFlow = .login
    
    var body: some View {
        switch flow {
        case .login:
            LoginView(
                viewModel: viewModel,
                onSwitchToSignup: { flow = .signup },
                onRestorePassword: { flow = .restorePassword }
            )
        case .signup:
            SignupView(
                viewModel: viewModel,
                onSwitchToLogin: { flow = .login }
            )
        case .restorePassword:
            RestorePasswordView(
                onBackToLogin: { flow = .login }
            )
        }
    }
}

#Preview {
    AuthGateView(viewModel: AuthViewModel())
}


