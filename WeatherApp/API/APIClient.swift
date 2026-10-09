//
//  APIClient.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

// final so that we ensure no one inherits the class
// it also helps ensure we only have one instance of our singelton in the app

// we can add sendable to protect from concurrency issues that may arise
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
    
    func request<T: Decodable>(apiPath: OpenWeatherAPIPaths) async throws -> T {
        guard !apiKey.isEmpty else {
            throw APIErrors.missingAPI
        }
        
        guard var components = URLComponents(string: baseURL + apiPath) else {
            throw APIErrors.invalidURL
        }
        
        
    }
    
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
     
            // 1. Make sure a real key was added.
            guard !apiKey.isEmpty, apiKey != "PASTE_YOUR_KEY_HERE" else {
                return throwError(APIError.invalidAPIKey)
            }
     
            // 2. Build the full address: base URL + path + parameters + API key.
            guard var components = URLComponents(string: baseURL + endpoint.path) else {
                throw APIError.invalidURL
            }
            components.queryItems = endpoint.queryItems + [URLQueryItem(name: "appid", value: apiKey)]
     
            guard let url = components.url else {
                throw APIError.invalidURL
            }
     
            // 3. Send the request and wait for the answer (without freezing the app).
            let (data, response) = try await session.data(from: url)
     
            // 4. Check the status code.
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
     
            switch httpResponse.statusCode {
            case 200..<300: break
            case 401:       throw APIError.unauthorized
            case 404:       throw APIError.notFound
            case 429:       throw APIError.tooManyRequests
            default:        throw APIError.server(statusCode: httpResponse.statusCode)
            }
     
            // 5. Turn the JSON into Swift data.
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase   // "feels_like" -> feelsLike
     
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding
            }
        }
    }
     
}
