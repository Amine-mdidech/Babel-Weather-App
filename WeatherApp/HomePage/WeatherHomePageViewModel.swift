//
//  WeatherHPViewModel.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 7/10/2026.
//

import Foundation
import Combine

enum states: Equatable {
    case loading
    case completed(CurrentWeatherModel)
    case failed
}

@MainActor
final class WeatherHomePageViewModel: ObservableObject {
    
    @Published var currentWeatherResult: String?
    @Published var isLoading = false
    @Published var cities: [String] = ["Rabat", "Casablanca", "Marrakech", "Fes", "Tanger"]
    @Published var cityDictionary: [String: states] = [:]
    @Published var searchCity: String = ""
    
    private let service: WeatherServiceProtocol
    
    var searchCityList: [String] {
        if searchCity.isEmpty {
            return cities
        }
        return cities.filter { $0.description.contains(searchCity) }
    }   
    
    init(service: WeatherServiceProtocol) {
        self.service = service
    }
    
    func loadAllCitiesWeather() async {
        startLoadingCities()
        
        for city in cities {
            do {
                let weather: CurrentWeatherModel = try await service.getCurrentWeather(location: .byCityName(city))
                cityDictionary[city] = .completed(weather)
            } catch {
                cityDictionary[city] = .failed
            }
        }
        
    }
    
    func loadCurrentCityWeather() async {
        isLoading = true
        do {
            let weather = try await service.getCurrentWeather(location: .byCoordinates(latitude: 33.5898, longitude: -7.6038))
            currentWeatherResult = "\(weather.cityName): \(weather.temperature) C - \(weather.weatherState)"
        } catch {
            currentWeatherResult = " Error: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func startLoadingCities() {
        for city in cities {
            cityDictionary[city] = .loading
        }
    }
    
    func addCity(name: String) async {
        if !cities.contains(name) {
            cities.append(name)
            await loadAllCitiesWeather()
        }
    }
    
    // very important to map the index to avoid deleting the wrong city when searching
    func deleteCity(at offset: IndexSet) {
        let citiesToBeDeleted = offset.map { searchCityList[$0] }
        for city in citiesToBeDeleted {
            cities.removeAll { $0 == city }
            cityDictionary.removeValue(forKey: city)
        }
    }
}

