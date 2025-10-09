//
//  FavoriteButton.swift
//  CookShare
//
//  Created by Olga Dragon on 09.10.2025.
//

import SwiftUI

struct FavoriteButton: View {
    
    @EnvironmentObject private var social: SocialStore
    let recipe: Recipe
    
    var body: some View {
        Button {
            social.toggleFavorite(for: recipe)
        } label: {
            Image(systemName: social.isFavorite(recipe) ? "heart.fill" : "heartt")
                .imageScale(.large)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(social.isFavorite(recipe) ? .red : .secondary)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Favorite")
    }
}

#Preview {
    FavoriteButton(recipe: PreviewData.recipe)
        .environmentObject(SocialStore())
}
