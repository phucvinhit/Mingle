//
//  ForeCastViewModel.swift
//  Weather
//
//  Created by Vinh Pham on 9/3/19.
//  Copyright © 2019 Vinh Pham. All rights reserved.
//

import UIKit
import Foundation

class ForeCastViewModel: NSObject {
    private let cityCode: String
    let cityName: String
    let backgroundImage: String
    
    private let weatherService = WeatherService()
    var didFinishFetch: (() -> ())?
    
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    public var dataSource: [List]? {
        didSet {
            guard dataSource != nil else { return }
            self.didFinishFetch?()
        }
    }
    init(city: CityModel) {
        cityCode = city.cityCode
        cityName = city.cityName
        backgroundImage = city.background
    }
    
    func fetchWeather() {
        self.weatherService.getWeatherResults(cityCode: cityCode) { (openWeather, error) in
            self.dataSource = openWeather?.list
        }
    }
}
