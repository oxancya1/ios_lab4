struct Coordinates {
    let lat: Double
    let lon: Double
}

struct WeatherResponse: Codable {
    let coord: CoordinatesResponse
    let main: MainWeather
    let weather: [WeatherDescription]
}

struct CoordinatesResponse: Codable {
    let lat: Double
    let lon: Double
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Double
}

struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct PollutionResponse: Codable {
    let list: [PollutionData]
}

struct PollutionData: Codable {
    let main: PollutionMain
    let components: PollutionComponents
}

struct PollutionMain: Codable {
    let aqi: Int // Індекс якості повітря
}

struct PollutionComponents: Codable {
    let co: Double? // Моноксид вуглецю
    let no: Double? // Оксид азоту
    let no2: Double? // Двоокис азоту
    let o3: Double? // Озон
    let so2: Double? // Двоокис сірки
    let pm2_5: Double? // PM2.5
    let pm10: Double? // PM10
    let nh3: Double? // Амміак
}
