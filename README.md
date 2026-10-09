# WeatherApp

WeatherApp is a small iOS weather application built with SwiftUI that shows live weather data from the OpenWeatherMap API. The home screen displays the weather for your current location and a list of Moroccan cities (Casablanca, Rabat, Marrakech, Tangier and Fes), each with its temperature and weather conditions. You can add new cities, remove them with a swipe, search through your list, and tap any city to see its days forecast with humidity, wind speed and pressure.

The project follows the MVVM architecture: Views only display data, ViewModels handle the screen logic, and a `WeatherService` behind a protocol fetches the data through a singleton `APIClient` and converts the API's raw JSON (DTOs) into the app's own models. This separation keeps the code easy to read and fully testable, and the ViewModels are covered by XCTest unit tests using a mock service, so they run instantly and without an internet connection. 

The app uses no third-party dependencies, only Apple's native frameworks.
