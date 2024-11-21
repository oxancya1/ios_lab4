import Foundation
import Combine

class Interactor {
    private let apiKey = "4d12877a1ef9ab64bdada1fa2263b7db"
    80830d2f588cf2c74d3cc684eee7f098

    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?, PollutionResponse?, String?) -> Void) {
        fetchCoordinates(for: city) { coordinates, error in
            guard let coordinates = coordinates, error == nil else {
                completion(nil, nil, error)
                return
            }
            self.fetchPollutionData(lat: coordinates.lat, lon: coordinates.lon) { pollution, error in
                completion(nil, pollution, error)
            }
        }
    }

    private func fetchCoordinates(for city: String, completion: @escaping (Coordinates?, String?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil, "Server error: \(response?.description ?? "Unknown error")")
                return
            }

            guard let data = data else {
                completion(nil, "No data received")
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let coordinates = Coordinates(lat: weatherResponse.coord.lat, lon: weatherResponse.coord.lon)
                completion(coordinates, nil)
            } catch {
                completion(nil, "Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func fetchPollutionData(lat: Double, lon: Double, completion: @escaping (PollutionResponse?, String?) -> Void) {
        let pollutionUrlString = "https://api.openweathermap.org/data/2.5/air-pollution?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"

        https://http://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=\(apiKey)
        
        guard let url = URL(string: pollutionUrlString) else {
            completion(nil, "Invalid URL for pollution data")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil, "Server error: \(response?.description ?? "Unknown error")")
                return
            }

            guard let data = data else {
                completion(nil, "No data received for pollution")
                return
            }

            do {
                let pollutionResponse = try JSONDecoder().decode(PollutionResponse.self, from: data)
                completion(pollutionResponse, nil)
            } catch {
                completion(nil, "Failed to decode pollution JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

