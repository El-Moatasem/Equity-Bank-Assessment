//
//  CoinListViewController.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import UIKit

class CoinListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = CoinListViewModel()
    private let favoritesVM = FavoritesViewModel()
    
    private let filterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["All", "Highest Price", "Best 24H"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top 100 Coins"
        view.backgroundColor = .systemBackground
        
        setupSegmentedControl()
        setupTableView()
        bindViewModel()
        
        viewModel.fetchCoins(reset: true)
    }
    
    private func setupSegmentedControl() {
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
        navigationItem.titleView = filterSegmentedControl
    }
    
    @objc private func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: // Highest Price
            viewModel.applyFilter(option: .highestPrice)
        case 2: // Best 24H
            viewModel.applyFilter(option: .best24Hour)
        default:
            viewModel.removeFilter()
        }
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
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { error in
            print("Error fetching coins: \(error)")
        }
    }
}

extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        
        let coin = viewModel.filteredCoins[indexPath.row]
        cell.configure(coin: coin)
        
        return cell
    }
    
    // Pagination
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.filteredCoins.count - 1 {
            // If we have not yet reached 100 coins, fetch more
            if viewModel.coins.count < 100 {
                viewModel.fetchCoins()
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.filteredCoins[indexPath.row]
        let detailVC = CoinDetailViewController(coin: coin)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // Swipe to favorite
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let coin = viewModel.filteredCoins[indexPath.row]
        
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] _, _, completionHandler in
            self?.favoritesVM.addFavorite(uuid: coin.uuid)
            completionHandler(true)
        }
        favoriteAction.backgroundColor = .systemYellow
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}
