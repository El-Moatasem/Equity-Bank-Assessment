//
//  CoinDetailViewController.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import UIKit
import SwiftUI

class CoinDetailViewController: UIViewController {
    
    private let viewModel: CoinDetailViewModel
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let segmentControl = UISegmentedControl(items: ["24h", "7d", "30d"])
    
    init(coin: Coin) {
        self.viewModel = CoinDetailViewModel(coin: coin)
        super.init(nibName: nil, bundle: nil)
        self.title = coin.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        bindViewModel()
        viewModel.fetchHistory(timePeriod: "24h") // default
    }
    
    private func setupUI() {
        nameLabel.text = viewModel.coin.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        priceLabel.text = String(format: "$%.2f", viewModel.coin.priceValue)
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel, segmentControl])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.updateChart()
        }
        
        viewModel.onError = { error in
            print("Error loading coin history: \(error)")
        }
    }
    
    private func updateChart() {
        // Remove any existing chart hosting controller
        for child in children {
            if child is UIHostingController<PerformanceChartView> {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
        
        // Create SwiftUI chart
        let chartView = PerformanceChartView(prices: viewModel.historicalPrices)
        let hostingController = UIHostingController(rootView: chartView)
        
        // Add as a child VC
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.fetchHistory(timePeriod: "24h")
        case 1:
            viewModel.fetchHistory(timePeriod: "7d")
        case 2:
            viewModel.fetchHistory(timePeriod: "30d")
        default:
            break
        }
    }
}
