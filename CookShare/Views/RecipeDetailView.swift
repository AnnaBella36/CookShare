//
//  RecipeDetailView.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: recipe.thumbnailURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Rectangle().fill(.gray.opacity(0.15))
                            ProgressView()
                        }
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure(let error):
                        ZStack {
                            Rectangle().fill(.gray.opacity(0.15))
                            Image(systemName: "photo")
                        }
                    @unknown default:
                        Color.secondary
                    }
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(recipe.title)
                    .font(.title)
                    .bold()
                
                if let instructions = recipe.instructions, !instructions.isEmpty {
                    Text(instructions).font(.body).foregroundStyle(.primary)
                } else {
                    Text("No instructions provided.").foregroundStyle(.secondary)
                }
                
                HStack{
                    if let category = recipe.category, !category.isEmpty {
                        Label(category, systemImage: "tag")
                    }
                    if let area = recipe.area, !area.isEmpty {
                        Label(area, systemImage:  "globe.europe.africa")
                    }
                }
                .foregroundStyle(.secondary)
                .font(.subheadline)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{RecipeDetailView(recipe: PreviewData.recipe)}
}
