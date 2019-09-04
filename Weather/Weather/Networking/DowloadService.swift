//
//  DowloadService.swift
//  Weather
//
//  Created by Vinh Pham on 9/4/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import Foundation

class DowloadService {
    var downloadsSession: URLSession!
    
    func startDownload(_ weather: Weather) {
        
        let url: URL = weather.iconUrl
        let imageDownload = ImageDownload(url: url)
        imageDownload.task = downloadsSession.downloadTask(with: url)
        imageDownload.task!.resume()
    }
}
