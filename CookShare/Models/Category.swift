//
//  Category.swift
//  CookShare
//
//  Created by Olga Dragon on 12.10.2025.
//

import Foundation

struct CategoryResponse: Decodable {
    let meals: [Category]
}

struct Category: Identifiable, Decodable {
    let id = UUID()
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
}

struct AreaResponse: Decodable {
    let meals: [Area]
}

struct Area: Identifiable, Decodable {
    let id = UUID()
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "strArea"
    }
}
