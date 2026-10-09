//
//  APIClient.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation


// Singleton to ensure we only have one instance of our API class in the app
final class APIClient {
    
    static let shared = APIClient()
    
    private let session: URLSession
    private let baseURL = "https://api.openweathermap.org"
    private let apiKey: String
    
    private init(apiKey: String = Secrets.openWeatherMapApiKey,
                 session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    // using a generic to avoid code duplication
    func request<T: Decodable>(apiPath: OpenWeatherAPIEndPoints) async throws -> T {
        guard !apiKey.isEmpty else {
            throw APIErrors.missingAPIKey
        }
        
        guard var components = URLComponents(string: baseURL + apiPath.path) else {
            throw APIErrors.invalidURL
        }
        
        components.queryItems = apiPath.queryItems + [URLQueryItem(name: "appid", value: apiKey)]
        
        guard let finalURL = components.url else {
            throw APIErrors.invalidURL
        }
        
        let (data, response) = try await session.data(from: finalURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIErrors.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 404:
            throw APIErrors.noData
        default:
            break
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            return try decoder.decode(T.self, from: data)
        }
        catch {
            throw APIErrors.decodingError
        }
    }
}
