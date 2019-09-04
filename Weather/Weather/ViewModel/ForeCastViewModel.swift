//
//  ForeCastViewModel.swift
//  Weather
//
//  Created by Vinh Pham on 9/3/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import UIKit
import Foundation

class ForeCastViewModel: NSObject {
    var city: CityModel
    let cityName: String
    let backgroundImage: String
    let weatherService = WeatherService()
    let downloadService = DowloadService()
    var didFinishFetch: (() -> ())?
//    var isFinishLoadWeatherList: Bool = false
    
    var didFinishImage: (() -> ())?
    var image: (UIImage?, Int)? {
        didSet {
//            guard image != nil else { return }
            didFinishImage?()
        }
    }
    
    var didFinishFetchImage: ((UIImage?, Int) -> (UIImage?, Int))?
    
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    lazy var downloadsSession: URLSession = {
//        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    public var dataSource: [List]? {
        didSet {
            guard dataSource != nil else { return }
            self.didFinishFetch?()
        }
    }
    init(city: CityModel) {
        self.city = city
        cityName = city.cityName
        backgroundImage = city.background
    }
    
    func fetchWeather() {
        self.weatherService.getWeatherResults(cityCode: city.cityCode) { (openWeather, error) in
            self.dataSource = openWeather?.list
        }
    }
    
    func fetchImage() {
        for weather in dataSource ?? [] {
            downloadService.downloadsSession = downloadsSession
            downloadService.startDownload(weather.weather.first!)
        }
    }
}

extension ForeCastViewModel: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let destinationURL = localFilePath(for: sourceURL)
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        
        if let index = trackIndex(for: downloadTask) {
            if fileManager.fileExists(atPath: destinationURL.path){
                if let dataImage = NSData(contentsOfFile: destinationURL.path) {
                    let image = UIImage(data: Data(referencing: dataImage))
                    self.image = (image, index)
                }
            }
        }
        
    }
    
    fileprivate func trackIndex(for task: URLSessionDownloadTask) -> Int? {
        guard let url = task.originalRequest?.url else { return nil }
        
        let indexedTracks = dataSource?.enumerated().filter({ $0.element.weather.first?.iconUrl == url })
        
        //        let indexedTracks = searchResults.enumerated().filter() { $0.1.url == url }
        return indexedTracks?.first?.0
    }
}
