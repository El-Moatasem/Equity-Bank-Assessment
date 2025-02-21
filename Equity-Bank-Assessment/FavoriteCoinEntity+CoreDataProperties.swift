//
//  FavoriteCoinEntity+CoreDataProperties.swift
//  
//
//  Created by El-Moatasem on 21/02/2025.
//
//

import Foundation
import CoreData


extension FavoriteCoinEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCoinEntity> {
        return NSFetchRequest<FavoriteCoinEntity>(entityName: "FavoriteCoinEntity")
    }

    @NSManaged public var uuid: String?

}
