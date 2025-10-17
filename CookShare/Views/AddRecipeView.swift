//
//  AddRecipeView.swift
//  CookShare
//
//  Created by Olga Dragon on 01.10.2025.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = AddRecipeViewModel()
    @State private var showImagePicker = false

    var onSave: (UserRecipe) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Recipe title")) {
                    TextField("Enter title", text: $viewModel.title)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.quaternary, lineWidth: 1)
                        )
                }
                Section(header: Text("Photo")) {
                    if let image = viewModel.selectedImage {
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
                        let recipe = viewModel.makeUserRecipe()
                        onSave(recipe)
                        dismiss()
                        viewModel.reset()
                    }
                    .bold()
                    .disabled(viewModel.canSave)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
        }
    }
    
    private func  saveRecipe() {
        let recipe = viewModel.makeUserRecipe()
        onSave(recipe)
        dismiss()
        viewModel.reset()
    }
}

#Preview {
    AddRecipeView { _ in }
}
