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
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                HStack(spacing: 8) {
                    if let category = recipe.category, !category.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "tag")
                            Text(category)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    if let area = recipe.area, !area.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "globe.europe.africa")
                            Text(area)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
        }
    }
}


#Preview {
    RecipeRow(recipe: PreviewData.recipe)
}

