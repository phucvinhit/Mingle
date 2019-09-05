//
//  ForceCastView.swift
//  Weather
//
//  Created by Vinh Pham on 9/2/19.
//  Copyright © 2019 Vinh Pham. All rights reserved.
//

import UIKit

class ForceCastView: UIView {
    static let cellIdentifier = "weatherCell"

    @IBOutlet weak var tableWeather: UITableView!
    @IBOutlet weak var imageViewWeatherDescription: ImageLoader!
    @IBOutlet weak var labelWeatherDescription: UILabel!
    @IBOutlet weak var labelTemperatureDay: UILabel!
    @IBOutlet weak var labelMaxTemperature: UILabel!
    @IBOutlet weak var labelMinTemperature: UILabel!
    var animationsQueue = ChainedAnimationsQueue()

    var forceCastDataSource: [List] = []
    
    override func awakeFromNib() {
        tableWeather.register(UINib(nibName: "WeatherCell", bundle: .main), forCellReuseIdentifier: ForceCastView.cellIdentifier)
        
        
    }
    
    public func fillWeather(weatherOfDates weathers: [List]) {
        forceCastDataSource = weathers
        
        loadUICrrentWeather(currentWeather: forceCastDataSource.first)
        tableWeather.reloadData()
    }
    
    public func loadImagewithIndex(imageAtIndex: (UIImage?, Int)?) {
        
        guard let imageAtIndex = imageAtIndex else {
            return
        }
        
        switch imageAtIndex.1 {
        case 0:
            imageViewWeatherDescription.image = imageAtIndex.0
        default:
            let cellWeather = tableWeather.cellForRow(at: IndexPath(row: imageAtIndex.1, section: 0)) as? WeatherCell
            cellWeather?.imageViewWeatherDescription.image = imageAtIndex.0
        }
    }
    
    private func loadUICrrentWeather(currentWeather weather: List?) {
        
        guard let weather = weather,
        let weatherInList = weather.weather.first else {
            return
        }
        labelWeatherDescription.text = (weather.weather.first)?.main
        labelTemperatureDay.text = String(weather.temp.day)
        labelMaxTemperature.text = String(weather.temp.max)
        labelMinTemperature.text = String(weather.temp.min)
        imageViewWeatherDescription.loadImageWithUrl(weatherInList.iconUrl)
    }
}

extension ForceCastView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forceCastDataSource.count > 0 ? forceCastDataSource.count - 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WeatherCell! = tableView.dequeueReusableCell(withIdentifier: ForceCastView.cellIdentifier) as? WeatherCell
        if cell == nil {
            tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: ForceCastView.cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: ForceCastView.cellIdentifier) as? WeatherCell
        }
        
        cell.loadData(weather: forceCastDataSource[indexPath.item + 1])
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.0
        animationsQueue.queue(withDuration: 0.5, initializations: {
            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, cell.frame.size.width, 0, 0)
        }, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        })
    }
}
