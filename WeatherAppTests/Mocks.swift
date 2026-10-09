//
//  Mocks.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 9/10/2026.
//

import Foundation
@testable import WeatherApp

extension CurrentWeatherModel {
    static let currentWeatherMock = CurrentWeatherModel(
        cityName: "Rabat",
        weatherState: "Clear",
        temperature: 21.0,
        humidity: 50,
        pressure: 980,
        windSpeed: 3.2)
}

extension WeatherLocation {
    static let locationMock: WeatherLocation = .byCityName("Rabat")
    static let locationByCoordinatesMock: WeatherLocation = .byCoordinates(latitude: 33.5898, longitude: -7.6038)
}

extension WeatherForecastModel {
    static let forecastMock = WeatherForecastModel(date: Date(),
                                                   minTemperature: 19,
                                                   maxTemperature: 28,
                                                   state: "Rain",
                                                   humidity: 75,
                                                   pressure: 1000,
                                                   windspeed: 3.2)
}


