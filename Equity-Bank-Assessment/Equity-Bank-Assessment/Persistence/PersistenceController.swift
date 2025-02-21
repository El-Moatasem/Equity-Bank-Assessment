//
//  PersistenceController.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 21/02/2025.
//

import CoreData
import Foundation

class PersistenceController {
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        // "CryptoApp" should match the name of your .xcdatamodeld
        container = NSPersistentContainer(name: "CryptoApp")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error loading store: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// Call this to save changes if needed
    func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}
