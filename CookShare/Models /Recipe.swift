//
//  Recipe.swift
//  CookShare
//
//  Created by Olga Dragon on 21.08.2025.
//

import Foundation

struct MealSearchResponse: Decodable {
    let meals: [Recipe]?
}


struct Recipe: Identifiable, Decodable, Equatable {
    let id: String
    let title: String
    let instructions: String?
    let thumbnailURL: URL?
    let area: String?
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case instructions = "strInstructions"
        case thumbnailURL = "strMealThumb"
        case area = "strArea"
        case category = "strCategory"
    }
}
