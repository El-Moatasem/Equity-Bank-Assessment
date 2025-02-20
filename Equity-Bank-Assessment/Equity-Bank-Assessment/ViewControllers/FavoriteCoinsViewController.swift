//
//  FavoriteCoinsViewController.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import UIKit

class FavoriteCoinsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let favoritesVM = FavoritesViewModel()
    private var favoriteCoins: [Coin] = []
    
    private let coinService = CoinService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        loadFavoriteCoins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteCoins()
    }
    
    private func setupTableView() {
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadFavoriteCoins() {
        // Re-fetch top 100 coins, then filter by favorites
        coinService.fetchCoins(limit: 100, offset: 0) { [weak self] result in
            switch result {
            case .success(let coins):
                let favUUIDs = self?.favoritesVM.favoriteUUIDs ?? []
                self?.favoriteCoins = coins.filter { favUUIDs.contains($0.uuid) }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error loading favorite coins: \(error)")
            }
        }
    }
}

extension FavoriteCoinsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return favoriteCoins.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        
        let coin = favoriteCoins[indexPath.row]
        cell.configure(coin: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let coin = favoriteCoins[indexPath.row]
        let detailVC = CoinDetailViewController(coin: coin)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // Swipe left to unfavorite
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let coin = favoriteCoins[indexPath.row]
        
        let unfavAction = UIContextualAction(style: .destructive, title: "Unfavorite") { [weak self] _, _, completionHandler in
            self?.favoritesVM.removeFavorite(uuid: coin.uuid)
            self?.loadFavoriteCoins()
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [unfavAction])
    }
}
