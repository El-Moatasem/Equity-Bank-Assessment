//
//  CoinListViewModel.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import Foundation

class CoinListViewModel {
    private let coinService = CoinService()
    
    private(set) var coins: [Coin] = []
    private(set) var filteredCoins: [Coin] = []
    
    var currentPage = 0
    let pageSize = 20
    var isLoading = false
    
    // Closures that the view controller can bind to
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchCoins(reset: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        if reset {
            currentPage = 0
            coins.removeAll()
        }
        
        coinService.fetchCoins(limit: pageSize, offset: currentPage * pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let newCoins):
                self.coins.append(contentsOf: newCoins)
                self.filteredCoins = self.coins
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.onUpdate?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.onError?(error)
                }
            }
        }
    }
    
    enum FilterOption {
        case highestPrice
        case best24Hour
    }
    
    func applyFilter(option: FilterOption) {
        switch option {
        case .highestPrice:
            filteredCoins = coins.sorted { $0.priceValue > $1.priceValue }
        case .best24Hour:
            filteredCoins = coins.sorted { $0.changeValue > $1.changeValue }
        }
        onUpdate?()
    }
    
    func removeFilter() {
        filteredCoins = coins
        onUpdate?()
    }
}
