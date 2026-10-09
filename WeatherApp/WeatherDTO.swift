//
//  WeatherDTO.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

// OpenWeatherAPI returns the current weather JSON as following
//
//{
//  "name": "Rabat",
//  "weather": [ { "main": "Clear" } ],
//  "main": { "temp": 21.4, "humidity": 50, "pressure": 1013 },
//  "wind": { "speed": 3.2 }
//}
//
// Thus we need to transfer the json into readable data
//
// Forecast Json is as following
//
//{
//   "list": [
//     { "dt": 1759834800, "main": { "temp": 22.1, ... }, "weather": [ { "main": "Clouds" } ] },
//     ...
//   ]
// }

struct WeatherForecastDTO: Decodable {
    let list: [WeatherForecastElementDTO]
}

struct WeatherForecastElementDTO: Decodable {
    let dt: Int
    let weather: [WeatherStateDTO]
    let main: MainDTO
    let wind: WindDTO
}

struct CurrentWeatherInfoDTO: Decodable {
    let name: String
    let weather: [WeatherStateDTO]
    let main: MainDTO
    let wind: WindDTO
}

struct WeatherStateDTO: Decodable {
    let main: String
}

struct MainDTO: Decodable {
    let temp: Double
    let humidity: Int
    let pressure: Int
}

struct WindDTO: Decodable {
    let speed: Double
}
