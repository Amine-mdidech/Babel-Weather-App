//
//  WeatherForecast.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

struct WeatherForecastModel: Identifiable {
    let date: Date
    let minTemperature: Double
    let maxTemperature: Double
    let state: String
    let humidity: Int
    let pressure: Int
    let windspeed: Double
    var id: Date { date }
}
