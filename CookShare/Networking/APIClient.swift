//
//  APIClient.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from endpoint: Endpoint) async throws -> T
}

struct APIClient: APIClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else { throw APIError.invalidURL}
        
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadRevalidatingCacheData,
                                 timeoutInterval: 20)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {throw APIError.invalidResponse}
            guard(200..<300).contains(http.statusCode) else {throw APIError.httpStatus(http.statusCode)}
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch {
            throw APIError.requestFailed(underlying: error)
        }
    }
}

