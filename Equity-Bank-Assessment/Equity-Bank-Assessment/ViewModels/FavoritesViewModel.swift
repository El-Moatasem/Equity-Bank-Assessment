//
//  FavoritesViewModel.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import Foundation
import CoreData

class FavoritesViewModel {

    // Use the shared container's context by default
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    /// Returns all stored favorite coin UUIDs
    var favoriteUUIDs: [String] {
        do {
            let request: NSFetchRequest<FavoriteCoinEntity> = FavoriteCoinEntity.fetchRequest()
            let results = try context.fetch(request)
            return results.compactMap { $0.uuid }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }

    /// Whether a coin is in favorites
    func isFavorite(uuid: String) -> Bool {
        return favoriteUUIDs.contains(uuid)
    }

    /// Add a coin to favorites, if not already present
    func addFavorite(uuid: String) {
        guard !isFavorite(uuid: uuid) else { return }

        let newFav = FavoriteCoinEntity(context: context)
        newFav.uuid = uuid
        saveContext()
    }

    /// Remove a coin from favorites
    func removeFavorite(uuid: String) {
        let request: NSFetchRequest<FavoriteCoinEntity> = FavoriteCoinEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuid == %@", uuid)
        do {
            let results = try context.fetch(request)
            for obj in results {
                context.delete(obj)
            }
            saveContext()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }

    /// Helper to save context changes
    private func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
