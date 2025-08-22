//
//  RecipeRow.swift
//  CookShare
//
//  Created by Olga Dragon on 22.08.2025.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: recipe.thumbnailURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.15))
                        ProgressView()
                    }
                case .success(let image):
                    image.resizable().scaledToFill()
                    
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.15))
                        Image(systemName: "photo")
                    }
                @unknown default:
                    Color.secondary
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(2)
                HStack(spacing: 8) {
                    if let category = recipe.category, !category.isEmpty {
                        Label(category, systemImage: "tag")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    if let area = recipe.area, !area.isEmpty {
                        Label(area, systemImage: "globe.europe.africa")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}


#Preview {
    RecipeRow(recipe: PreviewData.recipe)
}
