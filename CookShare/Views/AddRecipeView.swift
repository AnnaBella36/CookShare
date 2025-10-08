//
//  AddRecipeView.swift
//  CookShare
//
//  Created by Olga Dragon on 01.10.2025.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var description: String = ""
    @State private var title: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false

    var onSave: (UserRecipe) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Recipe title")) {
                    TextField("Enter title", text: $title)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.quaternary, lineWidth: 1)
                        )
                }
                Section(header: Text("Photo")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Text("No image selected")
                            .foregroundStyle(.secondary)
                    }

                    Button("Choose photo") {
                        showImagePicker = true
                    }
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .bold()
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func  saveRecipe() {
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let recipe = UserRecipe(title: title,
                                image: selectedImage,
                                description: trimmedDescription.isEmpty ? nil : trimmedDescription)
        onSave(recipe)
        dismiss()
    }
}

#Preview {
    AddRecipeView { _ in }
}
