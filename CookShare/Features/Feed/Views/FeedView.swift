//
//  FeedView.swift
//  CookShare
//
//  Created by Olga Dragon on 09.10.2025.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var social: SocialStore
    @State private var showUsers = false
    
    var body: some View {
        NavigationStack {
            Group {
                if social.feedRecipes.isEmpty && social.myRecipes.isEmpty {
                    ContentUnavailableView(
                        "No posts yet",
                        systemImage: "text.below.photo",
                        description: Text("Follow people or add your first recipe.")
                    )
                    .padding()
                } else {
                    List {
                        Section("From people you follow") {
                            ForEach(social.feedRecipes) { recipe in
                                HStack(spacing: 12) {
                                    NavigationLink {
                                        RecipeDetailView(recipe: recipe)
                                    } label: {
                                        RecipeRow(recipe: recipe)
                                    }
                                    FavoriteButton(recipe: recipe)
                                }
                            }
                        }
                        if !social.myRecipes.isEmpty {
                            Section("My Recipes") {
                                ForEach(social.myRecipes) { recipe in
                                    userRecipeRow(recipe)
                                }
                                .onDelete(perform: social.removeMyRecipes)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Feed")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showUsers = true
                    } label: {
                        Label("People", systemImage: "person.2.fill")
                    }
                }
        }
            .sheet(isPresented: $showUsers) {
                UsersView()
                    .environmentObject(social)
            }
            .refreshable {
                await social.refreshFeed()
            }
    }
}
   
    private func userRecipeRow(_ recipe: UserRecipe) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.08))
                if let image = recipe.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.body)
                    .lineLimit(1)
                if let description = recipe.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    FeedView()
        .environmentObject(SocialStore())
}
