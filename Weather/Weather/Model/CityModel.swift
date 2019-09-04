//
//  CityModel.swift
//  Weather
//
//  Created by Vinh Pham on 9/2/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import Foundation
struct CityModel {
    var cityCode: String
    var cityName: String
    var background: String
    
    init(code: String, name: String, imageBackground: String) {
        cityCode = code
        cityName = name
        background = imageBackground
    }
}
