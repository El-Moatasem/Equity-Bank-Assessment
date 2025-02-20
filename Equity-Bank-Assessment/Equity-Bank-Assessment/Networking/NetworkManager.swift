//
//  NetworkManager.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}
    
    let baseURL = "https://api.coinranking.com/v2"
    
    // Replace with your real API key:
    let apiKey = "coinrankingc3ee16bb1b9f8c3c6fa29c69ce315e725e571a87375c5062"
    
    func request<T: Decodable>(endpoint: String,
                               queryItems: [URLQueryItem] = [],
                               completion: @escaping (Result<T, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: baseURL + endpoint)!
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Add any required headers for CoinRanking
        request.setValue(apiKey, forHTTPHeaderField: "x-access-token")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data
            else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}
