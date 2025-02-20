//
//  CoinService.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import Foundation

class CoinService {
    
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        let endpoint = "/coins"
        
        let queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        NetworkManager.shared.request(endpoint: endpoint, queryItems: queryItems) { (result: Result<CoinData, Error>) in
            switch result {
            case .success(let coinData):
                completion(.success(coinData.data.coins))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch historical data for a specific coin (example).
    /// For a real app, parse the actual JSON structure from CoinRanking.
    func fetchCoinHistory(uuid: String, timePeriod: String, completion: @escaping (Result<[Double], Error>) -> Void) {
        let endpoint = "/coin/\(uuid)/history"
        let queryItems = [
            URLQueryItem(name: "timePeriod", value: timePeriod)
        ]
        
        NetworkManager.shared.request(endpoint: endpoint, queryItems: queryItems) { (result: Result<HistoricalResponse, Error>) in
            switch result {
            case .success(let historicalData):
                // Convert to [Double]
                let prices = historicalData.data.history.compactMap { Double($0.price) }
                completion(.success(prices))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Historical Data Models (Example)
struct HistoricalResponse: Decodable {
    let data: HistoryData
}

struct HistoryData: Decodable {
    let history: [HistoricalPoint]
}

struct HistoricalPoint: Decodable {
    let price: String
    let timestamp: Int
}
