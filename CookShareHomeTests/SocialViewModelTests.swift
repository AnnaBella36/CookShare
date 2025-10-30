//
//  SocialViewModelTests.swift
//  CookShareHomeTests
//
//  Created by Olga Dragon on 30.10.2025.
//

import XCTest
@testable import CookShare
@MainActor
final class SocialViewModelTests: XCTest {

    func testToggleFavorite() {
        let social = SocialViewModel()
        let testRecipe = PreviewData.recipes.first!
        XCTAssertFalse(social.isFavorite(testRecipe))
        social.toggleFavorite(for: testRecipe)
        XCTAssertTrue(social.isFavorite(testRecipe))
        social.toggleFavorite(for: testRecipe)
        XCTAssertFalse(social.isFavorite(testRecipe))
    }

    func testFollowUnfollow() {
        let social = SocialViewModel()
        social.follow("u.test")
        XCTAssertTrue(social.isFollowing("u.test"))
        social.unfollow("u.test")
        XCTAssertFalse(social.isFollowing("u.test"))
    }

    func testAddAndRemoveMyRecipe() {
        let social = SocialViewModel()
        let userRecipe = UserRecipe(title: "Home Pizza", image: nil, description: "Nice")
        social.addMyRecipe(userRecipe)
        XCTAssertEqual(social.myRecipes.first?.title, "Home Pizza")
        social.removeMyRecipes(at: IndexSet(integer: 0))
        XCTAssertTrue(social.myRecipes.isEmpty)
    }

    func testFeedRecipesShowOnlyFollowedAuthors() {
        let social = SocialViewModel()
        let initialFeedRecipeIDs = Set(social.feedRecipes.map { $0.id })
        XCTAssertEqual(initialFeedRecipeIDs, Set(["52771","52977"]))
        social.unfollow("u.marie")
        let updatedFeedRecipeIDs = Set(social.feedRecipes.map { $0.id })
        XCTAssertEqual(updatedFeedRecipeIDs, Set(["52771"]))
    }
}
