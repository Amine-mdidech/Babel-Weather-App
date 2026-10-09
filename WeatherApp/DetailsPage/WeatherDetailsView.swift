//
//  WeatherDetailsView.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 8/10/2026.
//

import SwiftUI

struct WeatherDetailsView: View {
    
    @StateObject private var viewModel: WeatherDetailsViewModel
    
    init(title: String,
         location: WeatherLocation,
         service: WeatherServiceProtocol) {
        _viewModel = StateObject(wrappedValue: WeatherDetailsViewModel(location: location,
                                                                       service: service))
    }
    
    var body: some View {
        showMultipleDaysForecast()
            .task {
                await viewModel.loadForecast()
            }
    }
    
    @ViewBuilder
    func showMultipleDaysForecast() -> some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
            Text("Error fetching weather data: \(errorMessage)")
        } else {
            List(viewModel.cityForecast) { day in
                HStack {
                    Text(day.date.formatted(.dateTime.weekday()))
                    Spacer()
                    VStack {
                        Text("\(day.state) - min: \(Int(day.minTemperature)) °C - max: \(Int(day.maxTemperature)) °C")
                        Text(" hum: \(day.humidity) % - pres: \(day.pressure) hpa")
                        Text(" wind: \(day.windspeed, specifier: "%.2f") m/s")
                    }
                }
            }
        }
    }
}
