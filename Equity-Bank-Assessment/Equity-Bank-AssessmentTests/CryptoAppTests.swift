//
//  CryptoAppTests.swift
//  CryptoApp
//
//  Created by El-Moatasem on 21/02/2025.
//

import XCTest
import CoreData
@testable import Equity_Bank_Assessment  // Adjust if your module name is different

final class CryptoAppTests: XCTestCase {

    // MARK: - 1. Model Parsing Test
    func testCoinModelParsing() {
        let json = """
        {
            "data": {
                "coins": [
                    {
                        "uuid": "Qwsogvtv82FCd",
                        "symbol": "BTC",
                        "name": "Bitcoin",
                        "iconUrl": "https://cdn.coinranking.com/bOabBYkcX/btc.svg",
                        "price": "40000",
                        "change": "-2.5",
                        "marketCap": "800000000000"
                    }
                ]
            }
        }
        """.data(using: .utf8)!

        do {
            let decoded = try JSONDecoder().decode(CoinData.self, from: json)
            XCTAssertEqual(decoded.data.coins.count, 1)

            let coin = decoded.data.coins.first!
            XCTAssertEqual(coin.uuid, "Qwsogvtv82FCd")
            XCTAssertEqual(coin.symbol, "BTC")
            XCTAssertEqual(coin.priceValue, 40000.0)
            XCTAssertEqual(coin.changeValue, -2.5)
        } catch {
            XCTFail("Failed to decode CoinData: \(error)")
        }
    }

    // MARK: - 2. FavoritesViewModel Test (Core Data In-Memory)
    func testFavoritesViewModel() {
        // Create an in-memory NSPersistentContainer matching the .xcdatamodeld name "CryptoApp"
        let container = NSPersistentContainer(name: "CryptoApp")

        // Direct it to /dev/null so it won't write to disk
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]

        // Load the persistent store
        container.loadPersistentStores { storeDescription, error in
            XCTAssertNil(error, "Failed to load in-memory store: \(String(describing: error))")
        }

        // Use the in-memory context for testing
        let context = container.viewContext
        let favoritesVM = FavoritesViewModel(context: context)

        // Start with a clean slate
        let existingFavs = favoritesVM.favoriteUUIDs
        for fav in existingFavs {
            favoritesVM.removeFavorite(uuid: fav)
        }
        XCTAssertEqual(favoritesVM.favoriteUUIDs.count, 0,
                       "Should have 0 favorites initially in test.")

        // Test addFavorite
        favoritesVM.addFavorite(uuid: "testCoin")
        XCTAssertTrue(favoritesVM.isFavorite(uuid: "testCoin"),
                      "testCoin should now be a favorite.")

        // Test removeFavorite
        favoritesVM.removeFavorite(uuid: "testCoin")
        XCTAssertFalse(favoritesVM.isFavorite(uuid: "testCoin"),
                       "testCoin should no longer be a favorite.")
    }

    // MARK: - 3. Networking Test (Live)
    func testFetchCoinsNetworking() {
        let expectation = self.expectation(description: "FetchCoins")

        let service = CoinService()
        service.fetchCoins(limit: 20, offset: 0) { result in
            switch result {
            case .success(let coins):
                XCTAssertFalse(coins.isEmpty, "Coins array should not be empty.")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error fetching coins: \(error)")
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}

