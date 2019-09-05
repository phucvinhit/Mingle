//
//  WeatherService.swift
//  Weather
//
//  Created by Vinh Pham on 9/3/19.
//  Copyright © 2019 Vinh Pham. All rights reserved.
//

import Foundation

class WeatherService {
    typealias WeatherResult = (OpenWeather?, String) -> ()
    static let APIKey = "fcb03c17ab6bb5606920752f712561de"
    var weather: OpenWeather!
    var errorMessage = ""
    
    var defaultSession: DHURLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 300
        if #available(iOS 11, *) {
            config.waitsForConnectivity = true
        }
        return URLSession(configuration: config)
    }()
    var dataTask: URLSessionDataTask?
    let decoder = JSONDecoder()
    let queue = OperationQueue()
    
    func getWeatherResults(cityCode: String, completion: @escaping WeatherResult) {
        dataTask?.cancel()
        
        guard var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast/daily")
            else { return }
        urlComponents.query = "id=\(cityCode)&cnt=6&APPID=\(WeatherService.APIKey)&units=metric"
        guard let url = urlComponents.url else { return }
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.updateWeatherResults(data)
                DispatchQueue.main.async {
                    completion(self.weather, self.errorMessage)
                }
            }
        }
        dataTask?.resume()
    }
    
    fileprivate func updateWeatherResults(_ data: Data) {
        do {
            let waether = try decoder.decode(OpenWeather.self, from: data)
            self.weather = waether
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            return
        }
    }
}
