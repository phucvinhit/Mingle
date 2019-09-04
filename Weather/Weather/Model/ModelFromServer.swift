//
//  ModelFromServer.swift
//  Weather
//
//  Created by Vinh Pham on 9/3/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//
import Foundation

// MARK: - Welcome
struct OpenWeather: Codable {
    let city: City
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - List
struct List: Codable {
    let dt, sunrise, sunset: Double
    let temp: Temp
    let pressure: Double
    let humidity: Int
    let weather: [Weather]
    let speed: Double
    let deg, clouds: Int
    let rain: Double?
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String
    var iconUrl: URL {
        let stringURL = String("http://openweathermap.org/img/wn/\(self.icon)@2x.png")
        guard let instance = URL(string: stringURL) else {
            fatalError("Unconstructable URL: \(stringURL)")
        }
        return instance
    }
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
