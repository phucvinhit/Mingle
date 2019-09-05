//
//  CitiesViewModel.swift
//  Weather
//
//  Created by Vinh Pham on 9/2/19.
//  Copyright © 2019 Vinh Pham. All rights reserved.
//

import Foundation

class CitiesViewModel: NSObject {
    
    var citiesDataSource: [CityModel] = []
    
    override init(){
        super.init()
        self.citiesDataSource = self.getAllCities()
    }
    
    func getAllCities() -> [CityModel] {
        let bundle: Bundle = Bundle.main
        let resource: String = "countryCodes"
        let jsonPath = bundle.path(forResource: resource, ofType: "json")
        
        assert(jsonPath != nil, "Resource file is not found in the Bundle")
        
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        
        assert(jsonPath != nil, "Resource file is not found")
        
        var cities = [CityModel]()
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                for jsonObject in jsonObjects {
                    guard let countryObj = jsonObject as? NSDictionary else { return cities }
                    guard let code = countryObj["cityCode"] as? String,
                        let background = countryObj["background"] as? String,
                        let name = countryObj["name"] as? String else { return cities }
                    
                    let city = CityModel(code: code, name: name, imageBackground: background)
                    cities.append(city)
                }
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
        return cities.sorted(by: { $0.cityName < $1.cityName })
    }
}
