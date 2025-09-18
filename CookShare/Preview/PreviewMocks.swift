//
//  PreviewMocks.swift
//  CookShare
//
//  Created by Olga Dragon on 18.09.2025.
//

import Foundation

struct MockAPI: APIClientProtocol {
    func fetch<T>(_ type: T.Type, from endpoint: Endpoint) async throws -> T {
        
        if T.self == MealSearchResponse.self {
            return MealSearchResponse(meals: PreviewData.recipes) as! T
        }
        throw APIError.noData
    }
}

