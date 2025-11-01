//
//  AuthViewModelTests.swift
//  CookShareHomeTests
//
//  Created by Olga Dragon on 30.10.2025.
//

import XCTest
@testable import CookShare

@MainActor
final class AuthViewModelTests: XCTestCase {

    func testSignupSuccessSetsSession() async {
        //Arrange
        let service = InMemoryAuthService()
        let viewModel = AuthViewModel(authService: service)
        viewModel.name = "Olya"; viewModel.email = "o@a.com"; viewModel.password = "12345678"
        //Act
        await viewModel.signup()
        //Assert
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.session)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoginWrongPasswordShowsError() async {
        //Arrange
        let service = InMemoryAuthService()
        _ = try? await service.signup(name: "O", email: "u@u.com", password: "correctpass")

        let viewModel = AuthViewModel(authService: service)
        viewModel.email = "u@u.com"; viewModel.password = "wrongpass"
        //Act
        await viewModel.login()
        //Assert
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testRestoreAfterSignup() async {
        //Arrange
        let service = InMemoryAuthService()
        _ = try? await service.signup(name: "N", email: "x@x.com", password: "12345678")
        //Act
        let viewModel = AuthViewModel(authService: service)
        await viewModel.restore()
        //Assert
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.session?.email, "x@x.com")
    }
}
