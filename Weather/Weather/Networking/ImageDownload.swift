//
//  ImageDownload.swift
//  Weather
//
//  Created by Vinh Pham on 9/4/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import Foundation

class ImageDownload: NSObject {
    var url: URL
    var task: URLSessionDownloadTask?
    
    init(url: URL) {
        self.url = url
    }
}
