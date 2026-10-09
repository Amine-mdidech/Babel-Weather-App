//
//  WeatherDetialsViewModel.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 8/10/2026.
//

import Foundation
import Combine

@MainActor
final class WeatherDetailsViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var cityForecast: [WeatherForecastModel] = []
    
    private let location: WeatherLocation
    private let service: WeatherServiceProtocol
    
    init(location: WeatherLocation,
         service: WeatherServiceProtocol) {
        self.location = location
        self.service = service
    }
    
    func loadForecast() async {
        isLoading = true
        
        do {
            cityForecast = try await service.getWeatherForecast(location: location)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
