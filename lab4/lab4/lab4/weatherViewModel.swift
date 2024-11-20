import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var pollution: PollutionResponse?
    @Published var errorMessage: String?

    private let interactor = Interactor()

    func fetchWeather(for city: String) {
        interactor.fetchWeather(for: city) { [weak self] weatherResponse, pollutionResponse, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error
                    return
                }
                self?.weather = weatherResponse
                self?.pollution = pollutionResponse
            }
        }
    }
}
