//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation

// dependency injection: using a protocol will enable our code to be abstract
// instead of relying on a concrete service in this case.
// This will help us have a testable code, where we can send mocks that leads to expectable results
protocol WeatherServiceProtocol: Sendable {
    func getCurrentWeather(location: WeatherLocation) async throws -> CurrentWeatherModel
    func getWeatherForecast(location: WeatherLocation) async throws -> [WeatherForecastModel]
}

struct WeatherService: WeatherServiceProtocol {
    
    private let client: APIClient
    
    init(client: APIClient = .shared) {
        self.client = client
    }
    
    func getCurrentWeather(location: WeatherLocation) async throws -> CurrentWeatherModel {
        let currentWeather: CurrentWeatherInfoDTO = try await client.request(apiPath: .currentWeather(location))
        
        return CurrentWeatherModel(cityName: currentWeather.name,
                                  weatherState: currentWeather.weather.first?.main ?? "unknown",
                                  temperature: currentWeather.main.temp,
                                  humidity: currentWeather.main.humidity,
                                  pressure: currentWeather.main.pressure,
                                  windSpeed: currentWeather.wind.speed)
    }
    
    func getWeatherForecast(location: WeatherLocation) async throws -> [WeatherForecastModel] {
        let forecast: WeatherForecastDTO = try await client.request(apiPath: .forecast(location))
        
        let itemsByDay = Dictionary(grouping: forecast.list) { item in
            Calendar.current.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(item.dt)))
        }
        
        let daysForecast = itemsByDay.map { day, items in
            let temperatures = items.map { $0.main.temp }
            let states = items.map { $0.weather.first?.main ?? "unknown" }
            let humidity = items.map { $0.main.humidity }
            let pressure = items.map { $0.main.pressure }
            let windspeed = items.map { $0.wind.speed }
            
            return WeatherForecastModel(date: day,
                                        minTemperature: temperatures.min() ?? 0,
                                        maxTemperature: temperatures.max() ?? 0,
                                        state: states.first ?? "unknown",
                                        humidity: humidity.max() ?? 0,
                                        pressure: pressure.max() ?? 0,
                                        windspeed: windspeed.max() ?? 0)
        }
        return daysForecast.sorted { $0.date < $1.date }
    }
}
