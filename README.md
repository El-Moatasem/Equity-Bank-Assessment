# CryptoApp

An iOS application that shows the top 100 coins from the CoinRanking API, demonstrates pagination (20 coins per page), swipe-to-favorite functionality, filtering, a detail screen with chart, and a favorites screen.

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5+

## Building and Running

1. Clone or download the repository.
2. Open the `CryptoApp.xcodeproj` in Xcode.
3. Replace `YOUR_COINRANKING_API_KEY` in `NetworkManager.swift` with your actual CoinRanking API key.
4. Build and run on a simulator or device.

## Assumptions / Decisions

- Used `UserDefaults` to store favorites (by coin UUID).
- Used `UIKit` for the main list views and navigation.
- Embedded a SwiftUI view for the performance chart in `CoinDetailViewController` using `UIHostingController`.
- Filtering done in-memory after the data is fetched.
- Minimal error handling for demonstration purposes.

## Challenges & Solutions

- **Pagination**: Handled by modifying the `offset` query parameter (0, 20, 40...).
- **Performance chart**: Used SwiftUI's `Charts`. If you need to support lower iOS versions, swap to a 3rd party library.
- **API Key management**: For demonstration, the key is in code. For production, use secure storage or environment variables.
- **Testing**: Provided some basic unit tests for networking and model logic.

## Tests

Run the included unit tests by selecting `Product -> Test` within Xcode or pressing `Command + U`.
