//
//  AddRecipeViewModel.swift
//  CookShare
//
//  Created by Olga Dragon on 17.10.2025.
//

import UIKit

@MainActor
final class AddRecipeViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedImage: UIImage? = nil
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func makeUserRecipe() -> UserRecipe {
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        return UserRecipe(title: title.trimmingCharacters(in: .whitespacesAndNewlines),                     image: selectedImage,
                          description: trimmedDescription.isEmpty ? nil : trimmedDescription)
    }
    
    func reset() {
        title = ""
        description = ""
        selectedImage = nil
    }
}
