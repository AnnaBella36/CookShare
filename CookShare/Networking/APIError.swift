//
//  APIError.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(underlying: Error)
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let underlying):
            return "Request failed: \(underlying.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        case .httpStatus(let code):
            return "HTTP error \(code)"
        case .decoding(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .noData:
            return "No data"
        }
    }
}

