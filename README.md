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
5. **Check your `.xcdatamodeld` file** to ensure it matches the name used in `PersistenceController`. For example, if the data model is named **`CryptoApp.xcdatamodeld`**, the `NSPersistentContainer(name: "CryptoApp")` call in the code must match.
6. Build and run the app on a simulator or device.

## Assumptions / Decisions

- **Core Data** is used to store favorite coin IDs (replacing the prior `UserDefaults` approach).
- The "detail" screen is a UIKit `UIViewController` that uses a SwiftUI `PerformanceChartView` inside a `UIHostingController`.
- Minimal error handling for demonstration purposes.
- Filtering is done in-memory after data is fetched.
- Basic `XCTest` coverage for networking and favorites logic.

## Challenges & Solutions

- **Pagination**: Achieved by incrementing `offset` in 20-coin increments up to 100 coins total.
- **Hybrid UI**: The main app uses SwiftUI (`@main struct`), but coin lists and detail views use UIKit. We embed these UIKit controllers in SwiftUI using `UIViewControllerRepresentable`.
- **Performance Chart**: Used SwiftUI’s `Charts` framework. For older iOS versions, consider a 3rd-party chart library.
- **Core Data Favorites**:  
  - We created a `FavoriteCoinEntity` (or similar) in the `.xcdatamodeld` file, with an attribute for `uuid`.  
  - A `PersistenceController` sets up the `NSPersistentContainer`.  
  - `FavoritesViewModel` handles adding, removing, and checking favorites in the Core Data context.

## Screenshots

Below are some sample screenshots showcasing the **Top 100 Coins** screen, the **Favorites** screen, and other details:

### Top 100 Coins

<img src="docs/images/highest.png" alt="Top 100 Coins" width="300"/>

### Favorites Screen

<img src="docs/images/favorites.png" alt="Favorites Screen" width="300"/>

### Swipe for favorites in Home Page

<img src="docs/images/swipe_favorite.png" alt="Top 100 Coins" width="300"/>

### Details from Home Page

<img src="docs/images/details_home.png" alt="Details Screen from Home" width="300"/>

### Details from Favorites Page

<img src="docs/images/details_favorite.png" alt="Details Screen from Favorites" width="300"/>

## Tests

- Run the included unit tests (in `CryptoAppTests.swift`) via **Product → Test** or **Cmd + U** in Xcode.
- Some tests validate networking to fetch coins. Others confirm that adding/removing favorites in Core Data functions as expected.

---

### Additional Notes on Core Data Setup

- The `.xcdatamodeld` file (e.g., **`CryptoApp.xcdatamodeld`**) contains a `FavoriteCoinEntity` with an attribute `uuid` (String).
- In the **Data Model Inspector**, make sure **Codegen** is set to **Manual/None** if you are providing a manual NSManagedObject subclass.
- The `PersistenceController` loads the store and provides a shared `NSPersistentContainer`.
- The `FavoritesViewModel` uses the container’s `viewContext` to add or remove `FavoriteCoinEntity` objects, storing the user’s favorite coin UUIDs offline.

