//
//  ContentView.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                CoinListWrapper()
                    .navigationTitle("Top 100 Coins")
            }
            .tabItem {
                Label("Coins", systemImage: "bitcoinsign.circle")
            }

            NavigationView {
                FavoriteCoinsWrapper()
                    .navigationTitle("Favorites")
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
