//
//  CryptoAppTests.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 21/02/2025.
//

import XCTest
@testable import Equity_Bank_Assessment 

final class CryptoAppTests: XCTestCase {
    
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
    
    func testFavoritesViewModel() {
        let favoritesVM = FavoritesViewModel()
        
        // Clear existing favorites
        let allFavs = favoritesVM.favoriteUUIDs
        for fav in allFavs {
            favoritesVM.removeFavorite(uuid: fav)
        }
        XCTAssertEqual(favoritesVM.favoriteUUIDs.count, 0)
        
        favoritesVM.addFavorite(uuid: "testCoin")
        XCTAssertTrue(favoritesVM.isFavorite(uuid: "testCoin"))
        
        favoritesVM.removeFavorite(uuid: "testCoin")
        XCTAssertFalse(favoritesVM.isFavorite(uuid: "testCoin"))
    }
    
    // Requires network connectivity. You may want to mock in a real scenario.
    func testFetchCoinsNetworking() {
        let expectation = self.expectation(description: "FetchCoins")
        
        let service = CoinService()
        service.fetchCoins(limit: 20, offset: 0) { result in
            switch result {
            case .success(let coins):
                XCTAssertFalse(coins.isEmpty, "Coins should not be empty.")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error fetching coins: \(error)")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
