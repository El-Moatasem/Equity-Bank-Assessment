//
//  Coin.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import Foundation

struct CoinData: Decodable {
    let data: CoinsList
}

struct CoinsList: Decodable {
    let coins: [Coin]
}

struct Coin: Decodable, Equatable, Hashable {
    let uuid: String
    let symbol: String
    let name: String
    let iconUrl: String
    let price: String
    let change: String
    let marketCap: String?
    
    var priceValue: Double {
        Double(price) ?? 0.0
    }
    
    var changeValue: Double {
        Double(change) ?? 0.0
    }
}
