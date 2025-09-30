//
//  PreviewMocks.swift
//  CookShare
//
//  Created by Olga Dragon on 18.09.2025.
//

import Foundation

struct MockAPIClient: APIClientProtocol {
    func fetch<T>(_ type: T.Type, from endpoint: Endpoint) async throws -> T {
        
        if T.self == MealSearchResponse.self,
           let response = MealSearchResponse(meals: PreviewData.recipes) as? T {
            return response 
        }
        throw APIError.noData
    }
}

