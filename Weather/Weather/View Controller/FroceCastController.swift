//
//  FroceCastController.swift
//  Weather
//
//  Created by Vinh Pham on 9/3/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import UIKit

protocol ForecastDelegate: NSObject {
    func addCities()
}

class FroceCastController: UIViewController {

    var weatherScrollView: WeatherScrollView!
    var viewModel: ForeCastViewModel!
    weak var delegate: ForecastDelegate?
    var index: Int!
    
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lableCity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let frocecastView: ForceCastView = UIView.fromNib()
        
        let backgroundImage = viewModel.backgroundImage
        weatherScrollView = WeatherScrollView(frame: view.frame, backgroundImage: UIImage(named: backgroundImage) ?? UIImage(), foregroundView: frocecastView)
        
        self.view.addSubview(weatherScrollView)
        self.view.bringSubviewToFront(viewHeader)
    
        viewModel.fetchWeather()
        
        lableCity.text = viewModel.cityName
        
        viewModel.didFinishFetch = {
            self.weatherScrollView.loadWeather(listWeather: self.viewModel.dataSource ?? [])
//            self.viewModel.didFinishDownloadImage(image: <#T##UIImage?#>, index: <#T##Int#>, completion: <#T##ForeCastViewModel.ImageResult##ForeCastViewModel.ImageResult##(UIImage?, Int) -> ()#>)
//            viewModel.Ima
            self.viewModel.fetchImage()
        }
    
//        viewModel.didFinishFetchImage.
//       viewModel.didFinishFetchImage?(idne)
//        viewModel.didFinishFetchImage.
        
        
        
        viewModel.didFinishImage = {
            let image = self.viewModel.image
            
            DispatchQueue.main.async {
                self.weatherScrollView.foregroundView.loadImagewithIndex(imageAtIndex: image)
            }
            
        }
    }
    @IBAction func buttonAddCitiesPressed(_ sender: Any) {
        delegate?.addCities()
    }
}


