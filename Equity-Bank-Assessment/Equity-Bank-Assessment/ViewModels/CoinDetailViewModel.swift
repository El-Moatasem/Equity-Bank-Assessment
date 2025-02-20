//
//  CoinDetailViewModel.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import Foundation

class CoinDetailViewModel {
    let coin: Coin
    private let coinService = CoinService()
    
    private(set) var historicalPrices: [Double] = []
    
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    func fetchHistory(timePeriod: String) {
        coinService.fetchCoinHistory(uuid: coin.uuid, timePeriod: timePeriod) { [weak self] result in
            switch result {
            case .success(let prices):
                self?.historicalPrices = prices
                DispatchQueue.main.async {
                    self?.onUpdate?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error)
                }
            }
        }
    }
}
