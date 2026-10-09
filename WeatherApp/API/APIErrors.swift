//
//  APIErrors.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

enum APIErrors: LocalizedError, Equatable {
    case missingAPI
    case invalidAPI
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .missingAPI:
            return "API key is missing"
        case .invalidAPI:
            return "API key is invalid"
        case .unknown:
            return "unknow error"
        }
    }
}
