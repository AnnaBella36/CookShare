//
//  SocialStore.swift
//  CookShare
//
//  Created by Olga Dragon on 08.10.2025.
//

import Foundation
import SwiftUI

@MainActor
final class SocialViewModel: ObservableObject {
    @Published private(set) var myRecipes: [UserRecipe] = []
    @Published private(set) var favorites: Set<String> = []
    @Published private(set) var follows: Set<String> = ["u.alex", "u.marie"]
    
    @Published private(set) var users: [UserSummary] = [
        UserSummary(id: "u.alex",  name: "Alex",  avatarSystemImage: "person.circle"),
        UserSummary(id: "u.marie", name: "Marie", avatarSystemImage: "person.circle"),
        UserSummary(id: "u.luca",  name: "Luca",  avatarSystemImage: "person.circle")
    ]
    
    private let recipeOwners: [String: String] = [
        "52771": "u.alex",
        "52977": "u.marie"
    ]
    
    var feedRecipes: [Recipe] {
        PreviewData.recipes.filter { recipe in
            guard let owner = recipeOwners[recipe.id] else {return false}
            return follows.contains(owner)
        }
    }
    
    func addMyRecipe(_ recipe: UserRecipe) {
        myRecipes.insert(recipe, at: 0)
    }
    
    func removeMyRecipes(at offsets: IndexSet) {
        myRecipes.remove(atOffsets: offsets)
    }
   
    func toggleFavorite(for recipe: Recipe) {
        if favorites.contains(recipe.id) {
            favorites.remove(recipe.id)
        } else {
            favorites.insert(recipe.id)
        }
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        favorites.contains(recipe.id)
    }
    
    
    func follow(_ userId: String) { follows.insert(userId) }
    func unfollow(_ userId: String) { follows.remove(userId) }
    func isFollowing(_ userId: String) -> Bool { follows.contains(userId) }
    
}

