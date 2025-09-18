//
//  PreviewData.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import Foundation

enum PreviewData {
    
    static let recipe = Recipe(
        id: "52771",
        title: "Spicy Arrabiata Penne",
        instructions: "Bring a large pot of water to a boil... Toss with sauce and serve.",
        thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg"),
        area: "Italian",
        category: "Vegetarian"
    )
    
    static let recipes: [Recipe] = [
        recipe,
        Recipe(
            id: "52977",
            title: "Corba",
            instructions: "Heat oil, add onions...",
            thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/58oia61564916529.jpg"),
            area: "Turkish",
            category: "Side"
        )
    ]
}

