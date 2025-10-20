//
//  ResetButton.swift
//  CookShare
//
//  Created by Olga Dragon on 20.10.2025.
//

import SwiftUI

struct ResetButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Reset", systemImage: "xmark.circle.fill")
                .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.bordered)
        .accessibilityLabel("Reset search and filters")
    }
}
