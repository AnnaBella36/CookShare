//
//  ContentView.swift
//  CookShare
//
//  Created by Olga Dragon on 21.08.2025.
//

import SwiftUI

struct RootView: View {
    var body: some View {

        NavigationStack{
            RecipeListView()
                .navigationTitle("CookBook")
        }
    }
}

#Preview {
    RootView()
}
