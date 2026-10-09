//
//  MockWeatherService.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 9/10/2026.
//

import Foundation
@testable import WeatherApp

struct MockWeatherService: WeatherServiceProtocol {
    var shouldFail: Bool = false
    
    func getCurrentWeather(location: WeatherLocation) async throws -> CurrentWeatherModel {
        if shouldFail {
            throw APIErrors.noData
        }
        return .currentWeatherMock
    }
    
    func getWeatherForecast(location: WeatherLocation) async throws -> [WeatherForecastModel] {
        if shouldFail {
            throw APIErrors.noData
        }
        return [.forecastMock]
    }
}
