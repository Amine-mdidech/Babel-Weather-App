//
//  APIErrors.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

enum APIErrors: LocalizedError, Equatable {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case decodingError
    case noData
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key is missing"
        case .invalidURL:
            return "API key is invalid"
        case .invalidResponse:
            return "API response is invalid"
        case .decodingError:
            return "Error decoding response"
        case .noData:
            return "No Data returned"
        case .unknown:
            return "unknow error"
        }
    }
}
