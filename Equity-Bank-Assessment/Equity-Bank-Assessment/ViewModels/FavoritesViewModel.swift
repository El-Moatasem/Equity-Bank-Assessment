//
//  FavoritesViewModel.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import Foundation

class FavoritesViewModel {
    
    private let favoritesKey = "FAVORITES_KEY"
    
    var favoriteUUIDs: Set<String> {
        get {
            let saved = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
            return Set(saved)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: favoritesKey)
        }
    }
    
    func addFavorite(uuid: String) {
        var favs = favoriteUUIDs
        favs.insert(uuid)
        favoriteUUIDs = favs
    }
    
    func removeFavorite(uuid: String) {
        var favs = favoriteUUIDs
        favs.remove(uuid)
        favoriteUUIDs = favs
    }
    
    func isFavorite(uuid: String) -> Bool {
        favoriteUUIDs.contains(uuid)
    }
}
