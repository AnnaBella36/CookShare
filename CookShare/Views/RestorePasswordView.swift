//
//  RestorePasswordView.swift
//  CookShare
//
//  Created by Olga Dragon on 01.10.2025.
//

import SwiftUI

struct RestorePasswordView: View {
    
    var onBackToLogin: () -> Void

    @State private var email: String = ""
    @State private var info: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Restore password")
                .font(.title.bold())

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            if let info {
                Text(info).foregroundStyle(.secondary)
            }

            Button("Send reset link") {
                info = "If this email exists, we sent a reset link."
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            Button("Back to login") {
                onBackToLogin()
            }
            .font(.footnote)
            .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    RestorePasswordView(onBackToLogin: {})
}
