//
//  WeatherCell.swift
//  Weather
//
//  Created by Vinh Pham on 9/3/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var imageViewWeatherDescription: ImageLoader!
    @IBOutlet weak var labelMaxTemperature: UILabel!
    @IBOutlet weak var labelMinTemperature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func loadData(weather: List) {
        
        guard let weatherInList = weather.weather.first else {
            return
        }
        
        labelDateTime.text = weather.dt.convertToDate()
        labelMaxTemperature.text = weather.temp.max.convertToTemperature()
        labelMinTemperature.text = weather.temp.min.convertToTemperature()
        imageViewWeatherDescription.loadImageWithUrl(weatherInList.iconUrl)
    }
    
}
