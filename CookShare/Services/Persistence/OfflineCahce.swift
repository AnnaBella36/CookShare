//
//  OfflineCache.swift
//  CookShare
//
//  Created by Olga Dragon on 21.10.2025.
//

import Foundation

final class OfflineCahce {
    static let shared = OfflineCahce()
    private let cahceURL: URL
    private let cahceFileName = "recipes_cache.json"
 
    private init() {
        guard let cahcesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("Failed to get cahces directory.")
            cahceURL = URL(fileURLWithPath: "/dev/null")
            return
        }
        cahceURL = cahcesDirectoryURL.appendingPathComponent(cahceFileName)
    }
    
    /// Saves the provided recipes to the cache file, replacing any previously stored data.
    /// This method always rewrites the entire cache.
    /// Intended for storing the latest search results, not the user's search history.
    func save(_ recipes: [Recipe]) {
        do {
            let data = try JSONEncoder().encode(recipes)
            try data.write(to: cahceURL, options: .atomicWrite)
        } catch {
            print(" Failed to cache recipes:", error)
        }
    }
    
    func load() -> [Recipe] {
        guard FileManager.default.fileExists(atPath: cahceURL.path) else { return [] }
        do {
            let data = try Data(contentsOf: cahceURL)
            return try JSONDecoder().decode([Recipe].self, from: data)
        } catch {
            print(" Failed to load cached recipes:", error)
            return []
        }
    }
}
