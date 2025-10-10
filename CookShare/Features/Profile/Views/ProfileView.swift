//
//  ProfileView.swift
//  CookShare
//
//  Created by Olga Dragon on 09.10.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var social: SocialViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .foregroundStyle(.background)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(displayName)
                                .font(.headline)
                            Text(displayEmail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
                Section("Stats") {
                    LabeledContent("My Recipe", value: "\(social.myRecipes.count)")
                    LabeledContent("Favorites", value: "\(social.favorites.count)")
                    LabeledContent("Following", value: "\(social.follows.count)")
                }
                Section {
                    Button(role: .destructive) {
                        authViewModel.logout()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
    
    private var displayName: String {
        if let name = authViewModel.session?.email.split(separator: "@").first {
            return authViewModel.name.isEmpty ? String(name) : authViewModel.name
        }
        return authViewModel.name.isEmpty ? "User" : authViewModel.name
    }
    
    private var displayEmail: String {
        authViewModel.session?.email ?? authViewModel.email
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
        .environmentObject(SocialViewModel())
}
