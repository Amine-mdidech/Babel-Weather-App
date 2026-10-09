//
//  WeatherHomePageViewModelTest.swift
//  WeatherAppTests
//
//  Created by Amine Benchekroun on 9/10/2026.
//

import XCTest
@testable import WeatherApp

@MainActor
final class WeatherHomePageViewModelTest: XCTestCase {
    
    private func makeSUT(service: MockWeatherService = MockWeatherService(shouldFail: false),
                         cities: [String] = ["Casablanca", "Rabat", "Agadir"]) -> WeatherHomePageViewModel {
        let sut = WeatherHomePageViewModel(service: service)
        sut.cities = cities
        return sut
    }
    
    func test_Success_LoadAllCities() async {
        let sut = makeSUT()
        
        await sut.loadAllCitiesWeather()
        
        for city in sut.cities {
            XCTAssertTrue(sut.cityDictionary[city] != .failed)
        }
    }
    
    func test_Failure_LoadAllCities() async {
        let sut = makeSUT(service: MockWeatherService(shouldFail: true))
        
        await sut.loadAllCitiesWeather()
        
        for city in sut.cities {
            XCTAssertTrue(sut.cityDictionary[city] == .failed)
        }
    }
    
    func test_Success_AddCity() async {
        let sut = makeSUT()
        
        await sut.addCity(name: "Marrakech")
        
        XCTAssertTrue(sut.cityDictionary[sut.cities.last!] != .failed)
        
        for city in sut.cities {
            XCTAssertTrue(sut.cityDictionary[city] != .failed)
        }
    }
    
    func test_DeleteCity() async {
        let sut = makeSUT()
        await sut.loadAllCitiesWeather()
        
        sut.deleteCity(at: IndexSet(integer: 1))
        
        XCTAssertNil(sut.cityDictionary["Rabat"])
    }
    
    func test_DeleteCity_While_Searching() async {
        let sut = makeSUT()
        sut.searchCity = "Aga"
        
        sut.deleteCity(at: IndexSet(integer: 0))
        
        XCTAssertNil(sut.cityDictionary["Agadir"])
        for city in sut.cities {
            XCTAssertTrue(sut.cityDictionary[city] != .failed)
        }
    }
}
