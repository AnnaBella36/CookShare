//
//  AppDependencies.swift
//  CookShare
//
//  Created by Olga Dragon on 17.09.2025.
//

import Foundation

struct AppContainer {
    let apiClient: APIClientProtocol
    let authService: AuthServiceProtocol
}

