//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

enum WeatherLocation: Hashable {
    case byCoordinates(latitude: Double, longitude: Double)
    case byCityName(String)
    
    var urlParameters: [URLQueryItem] {
        switch self {
        case .byCoordinates(let latitude, let longitude):
            return [URLQueryItem(name: "lat", value: String(latitude)),
                    URLQueryItem(name: "lon", value: String(longitude))]
        case .byCityName(let cityName):
            return [URLQueryItem(name: "q", value: cityName)]
        }
    }
}
