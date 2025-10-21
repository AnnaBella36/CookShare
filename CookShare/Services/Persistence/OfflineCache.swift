//
//  OfflineCache.swift
//  CookShare
//
//  Created by Olga Dragon on 21.10.2025.
//

import Foundation

final class OfflineCache {
    static let shared = OfflineCache()
    private let cahceURL: URL
    
    private init() {
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cahceURL = cachesDirectoryURL.appendingPathComponent("recipes_cache.json")
    }
    
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
