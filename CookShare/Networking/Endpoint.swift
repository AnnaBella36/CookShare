//
//  Endpoint.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
    
    private var baseURL: URL{ URL(string: "https://www.themealdb.com")! }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL.host
        components.path = "/api/json/v1/1/" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }
    
    static func searchMeals(query: String) -> Endpoint {
        Endpoint(path: "search.php",  queryItems: [URLQueryItem(name: "s", value: query)])
    }
    
    static func lookupMeal(id: String) -> Endpoint {
        Endpoint(path: "lookup.php", queryItems: [URLQueryItem(name: "i", value: id)])
    }
}

