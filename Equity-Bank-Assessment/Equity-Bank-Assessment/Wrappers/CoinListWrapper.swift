//
//  CoinListWrapper.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import SwiftUI

struct CoinListWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        // Create a UINavigationController to handle internal pushes
        let coinListVC = CoinListViewController()
        let navController = UINavigationController(rootViewController: coinListVC)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No-op
    }
}
