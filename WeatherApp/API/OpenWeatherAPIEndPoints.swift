//
//  OpenWeatherAPIPaths.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

enum OpenWeatherEndPoints {
    case currentWeather(WeatherLocation)
    case forecast(WeatherLocation)
    
    // URL
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .forecast:
            return "/data/2.5/forecast"
        }
    }
    
    // URL parameters: location, weather units
    var queryItems: [URLQueryItem] {
        switch self {
        case .currentWeather(let location):
            return location.urlParameters + [URLQueryItem(name: "units", value: "metric")]
        case .forecast(let location):
            return location.urlParameters + [URLQueryItem(name: "units", value: "metric")]
        }
    }
}
    
