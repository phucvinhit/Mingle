//
//  WeatherPageViewModel.swift
//  Weather
//
//  Created by Vinh Pham on 9/5/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import UIKit

struct WeatherPageData {
    var controller: FroceCastController?
    let model: CityModel!
    var index: Int?
    
    init(city: CityModel, foreCastController: FroceCastController?) {
        controller = foreCastController
        model = city
    }
}

class WeatherPageViewModel: NSObject {
    var dataSource: [WeatherPageData] = []    
    var selectedCities: [CityModel] {
        get {
            var listCity:[CityModel] = []
            for weatherPageData in dataSource {
                listCity.append(weatherPageData.model)
            }
            return listCity
        }
    }

    var listControllerNeedUpdate:[Int] {
        get {
            var listIndex: [Int] = []
            for (index, weatherPageData) in dataSource.enumerated() {
                if weatherPageData.controller == nil {
                    listIndex.append(index)
                }
            }
            
            return listIndex
        }
    }
    var listControler: [FroceCastController] {
        get {
            var listController:[FroceCastController] = []
            for weatherPageData in dataSource {
                if let controller = weatherPageData.controller {
                    listController.append(controller)
                }
            }
            
            return listController
        }
    }
    
    var currentControllerPressented: FroceCastController!

    init(weatherDataSource: WeatherPageData) {
        dataSource.append(weatherDataSource)
    }
    
    func getPresentControllersAtIndex(index: Int) -> [FroceCastController] {
        guard let cotroller = dataSource[index].controller else {
            return []
        }
        
        self.currentControllerPressented = cotroller
        
        return [cotroller]
    }
    
    func receiveSelectedCity(cities: [CityModel]) {
        var listControllerNeedUpdate: [Int] = []
        for (index, weatherData) in dataSource.enumerated() {
            if !cities.contains(where: { $0.cityCode == weatherData.model.cityCode }) {
                dataSource.remove(at: index)
            }
        }
        
        for city in cities {
            dataSource.append(WeatherPageData(city: city, foreCastController: nil))
            listControllerNeedUpdate.append(dataSource.count - 1)
        }
        
        print("Data\(dataSource)")
    }
    
    func updateController(withController controller: FroceCastController, atIndex index: Int) {
        var weatherData = dataSource[index]
        weatherData.controller = controller
        weatherData.index = index
        
        dataSource[index] = weatherData
    }
    
}
