//
//  AuthGateView.swift
//  CookShare
//
//  Created by Olga Dragon on 24.09.2025.
//

import SwiftUI

struct AuthGateView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showSignup: Bool = false
    
    var body: some View {
        if showSignup {
            SignupView(viewModel: viewModel) {
                showSignup = false
            }
        } else {
            LoginView(viewModel: viewModel) {
                showSignup = true
            }
        }
    }
}

#Preview {
    AuthGateView(viewModel: AuthViewModel())
}


