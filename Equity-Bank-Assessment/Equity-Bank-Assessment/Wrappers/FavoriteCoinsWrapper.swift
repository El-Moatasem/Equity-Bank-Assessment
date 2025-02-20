//
//  FavoriteCoinsWrapper.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import SwiftUI

struct FavoriteCoinsWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let favoritesVC = FavoriteCoinsViewController()
        let navController = UINavigationController(rootViewController: favoritesVC)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No-op
    }
}
