# CryptoApp

An iOS application that shows the top 100 coins from the CoinRanking API, demonstrates pagination (20 coins per page), swipe-to-favorite functionality, filtering, a detail screen with a chart, and a favorites screen.

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5+

## Building and Running

1. Create or open a new SwiftUI iOS project in Xcode.
2. Copy all of the provided files into your project structure.
3. Replace `YOUR_COINRANKING_API_KEY` in `NetworkManager.swift` with your CoinRanking API key.
4. Make sure your iOS Deployment Target is 16.0 or higher (required for SwiftUI Charts).
5. Build and run the app on a simulator or device.

## Assumptions / Decisions

- Used `UserDefaults` to store favorite coin IDs.
- The "detail" screen is a UIKit `UIViewController` that uses a SwiftUI `PerformanceChartView` inside a `UIHostingController`.
- Minimal error handling for demonstration purposes.
- Filtering is done in-memory after data is fetched.
- Basic `XCTest` coverage for networking and favorites logic.

## Challenges & Solutions

- **Pagination**: Achieved by incrementing `offset` in 20-coin increments up to 100 coins total.
- **Hybrid UI**: The main app uses SwiftUI (`@main struct`), but coin lists and detail views use UIKit. We embed these UIKit controllers in SwiftUI using `UIViewControllerRepresentable`.
- **Performance Chart**: Used SwiftUI’s `Charts` framework. For older iOS versions, consider a 3rd-party chart library.

## Screenshots

Below are some sample screenshots showcasing the **Top 100 Coins** screen and the **Favorites** screen:

### Top 100 Coins

<img src="docs/images/highest.png" alt="Top 100 Coins" width="300"/>

### Favorites Screen

<img src="docs/images/favorites.png" alt="Favorites Screen" width="300"/>


> **Note**: Place your actual screenshot images under a `screenshots` folder in your repository (e.g., `screenshots/top_coins.png`, `screenshots/favorites_screen.png`) and ensure the file names match the Markdown references above.

## Tests

Run the included unit tests (in `CryptoAppTests.swift`) via **Product → Test** or **Cmd + U** in Xcode.
