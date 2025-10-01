//
//  AddRecipeView.swift
//  CookShare
//
//  Created by Olga Dragon on 01.10.2025.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss

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

                Section {
                    Button("Save recipe") {
                        let recipe = UserRecipe(title: title, image: selectedImage)
                        onSave(recipe)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Add Recipe")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

#Preview {
    AddRecipeView { _ in }
}
