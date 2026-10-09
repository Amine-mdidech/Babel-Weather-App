//
//  WeatherDetailsViewModelTest.swift
//  WeatherApp
//
//  Created by Amine Benchekroun on 9/10/2026.
//

import XCTest
@testable import WeatherApp

@MainActor
final class WeatherDetailsViewModelTest: XCTestCase {
    
    private func makeSUT(service: MockWeatherService = MockWeatherService(shouldFail: false),
                         location: WeatherLocation = .locationMock) -> WeatherDetailsViewModel {
        WeatherDetailsViewModel(
            location: location,
            service: service
        )
    }
    
    func test_Success_LoadForecast() async {
        let sut = makeSUT()
        
        await sut.loadForecast()
        
        XCTAssertNotNil(sut.cityForecast)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_Success_LoadForecast_By_Coordinates() async {
        let sut = makeSUT(location: .locationByCoordinatesMock)
        
        await sut.loadForecast()
        
        XCTAssertNotNil(sut.cityForecast)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_Failure_NoData_Error_LoadForecast() async {
        let sut = makeSUT(service: MockWeatherService(shouldFail: true))
        
        await sut.loadForecast()
        
        XCTAssertEqual(sut.errorMessage, APIErrors.noData.errorDescription)
    }
}
