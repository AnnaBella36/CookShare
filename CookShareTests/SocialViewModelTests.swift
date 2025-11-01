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
        //Arrange
        let social = SocialViewModel()
        let testRecipe = PreviewData.recipes.first!
        //Assert
        XCTAssertFalse(social.isFavorite(testRecipe))
        //Act
        social.toggleFavorite(for: testRecipe)
        //Assert
        XCTAssertTrue(social.isFavorite(testRecipe))
        //Act
        social.toggleFavorite(for: testRecipe)
        //Assert
        XCTAssertFalse(social.isFavorite(testRecipe))
    }

    func testFollowUnfollow() {
        //Arrange
        let social = SocialViewModel()
        //Act
        social.follow("u.test")
        //Assert
        XCTAssertTrue(social.isFollowing("u.test"))
        //Act
        social.unfollow("u.test")
        //Assert
        XCTAssertFalse(social.isFollowing("u.test"))
    }

    func testAddAndRemoveMyRecipe() {
        //Arrange
        let social = SocialViewModel()
        let userRecipe = UserRecipe(title: "Home Pizza", image: nil, description: "Nice")
        //Act
        social.addMyRecipe(userRecipe)
        //Assert
        XCTAssertEqual(social.myRecipes.first?.title, "Home Pizza")
        //Act
        social.removeMyRecipes(at: IndexSet(integer: 0))
        //Assert
        XCTAssertTrue(social.myRecipes.isEmpty)
    }

    func testFeedRecipesShowOnlyFollowedAuthors() {
        //Arrange
        let social = SocialViewModel()
        //Act
        let initialFeedRecipeIDs = Set(social.feedRecipes.map { $0.id })
        //Assert
        XCTAssertEqual(initialFeedRecipeIDs, Set(["52771","52977"]))
        //Act
        social.unfollow("u.marie")
        let updatedFeedRecipeIDs = Set(social.feedRecipes.map { $0.id })
        //Assert
        XCTAssertEqual(updatedFeedRecipeIDs, Set(["52771"]))
    }
}
