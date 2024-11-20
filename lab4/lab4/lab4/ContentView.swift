import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""

    
    var body: some View {
        VStack {
            Text("Weather")
                .bold()
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
            
             if let weather = viewModel.weather {
                VStack(spacing: 10) {
                    HStack {
                        Text("\(Int(round(weather.main.temp)))")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        Text("°C")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                  
                    HStack {
                        Text("\(Int(round(weather.main.humidity)))")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                        Text("%")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Description: \(weather.weather.first?.description.capitalized ?? "")")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)
                .padding()

                // Відображення інформації про забруднення
                if let pollution = viewModel.pollution {
                    VStack(spacing: 10) {
                        Text("Air Quality Index (AQI): \(pollution.list.first?.main.aqi ?? 0)")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.yellow)
                        
                        if let mainPollutants = pollution.list.first?.components {
                            Text("PM2.5: \(mainPollutants.pm2_5 ?? 0) µg/m³")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                            Text("PM10: \(mainPollutants.pm10 ?? 0) µg/m³")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                            Text("NO2: \(mainPollutants.no2 ?? 0) µg/m³")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(15)
                    .padding()
                }

            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Spacer()
            TextField("Enter city name", text: $city)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .frame(height: 50)
                .background(RoundedRectangle(cornerRadius: 25).stroke(Color.primary, lineWidth: 2))
                
            Button("Get Weather") {
                viewModel.fetchWeather(for: city)
            }

            .frame(height: 50)
            .frame(width: 200)
            .background(Color(UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .white : .black
            }))
            .foregroundColor(Color(UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .black : .white
            }))
            .cornerRadius(25)
            .padding()
        }
        .padding()
        .background(Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        }))
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

