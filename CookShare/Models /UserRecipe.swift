//
//  UserRecipe.swift
//  CookShare
//
//  Created by Olga Dragon on 01.10.2025.
//

import Foundation
import UIKit

struct UserRecipe: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let image: UIImage?
}

