//
//  ContentView.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 6/10/2026.
//

import SwiftUI

struct WeatherHomePageView: View {
    @StateObject private var viewModel = WeatherHomePageViewModel(service: WeatherService())
    @State private var newCity: String = ""
    @State private var showSearchBar: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack() {
                searchCitySection()
                citiesSection()
                addCitySection()
                refreshCitiesSection()
                showCurrentLocationSection()
            }
        }
        .task {
            await viewModel.loadAllCitiesWeather()
        }
        .task {
            await viewModel.loadCurrentCityWeather()
        }
    }
    
    @ViewBuilder
    func citiesSection() -> some View {
        List() {
            ForEach(viewModel.searchCityList, id: \.self) { city in
                NavigationLink {
                    WeatherDetailsView(title: city,
                                       location: .byCityName(city),
                                       service: WeatherService())
                } label: {
                    HStack {
                        Text("\(city.description)")
                        Spacer()
                        switch viewModel.cityDictionary[city] {
                        case .loading:
                            ProgressView()
                        case .completed(let weather):
                            Text("\(weather.weatherState) - \(Int(weather.temperature)) °C")
                        case .failed:
                            Text("Error: loading")
                        case .none:
                            EmptyView()
                        }
                    }
                }
            }
            .onDelete { offset in
                viewModel.deleteCity(at: offset)
            }
        }
    }
    
    @ViewBuilder
    func showCurrentLocationSection() -> some View {
        if let result = viewModel.currentWeatherResult {
            Text("Current Location")
            Text(result)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    func addCitySection() -> some View {
        if showSearchBar {
            HStack(spacing: 12) {
                TextField("Add a city", text: $newCity)
                    .submitLabel(.done)
                    .onSubmit{
                        Task {
                            showSearchBar = false
                            await viewModel.addCity(name: newCity)
                            newCity = ""
                        }
                    }
                Spacer()
                Button("Cancel") {
                    showSearchBar = false
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        } else {
            Button("Add a city") {
                showSearchBar = true
            }
        }
        Spacer()
    }
    
    @ViewBuilder
    func refreshCitiesSection() -> some View {
        Button("Refresh weather values") {
            Task {
                await viewModel.loadAllCitiesWeather()
            }
        }
        Spacer()
    }
    
    func searchCitySection() -> some View {
        TextField("Search a city in your list", text: $viewModel.searchCity)
            .padding(.horizontal, 15)
    }
}

