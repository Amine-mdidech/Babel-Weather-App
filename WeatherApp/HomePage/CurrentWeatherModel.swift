//
//  Weather.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

struct CurrentWeatherModel: Equatable {
    let cityName: String
    let weatherState: String
    let temperature: Double
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
}
