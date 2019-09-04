//
//  WeatherPageViewCotroller.swift
//  Weather
//
//  Created by Vinh Pham on 9/3/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import UIKit
import Foundation

class WeatherPageViewCotroller: UIPageViewController {
    
    var listController: [FroceCastController] = []
    var listCitiesSelected: [CityModel] = []
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
       

        // Do any additional setup after loading the view.
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FroceCastController") as! FroceCastController
        let HCMCity = CityModel(code: "1566083", name: "Ho Chi Minh", imageBackground: "background_HCM")

        vc.viewModel = ForeCastViewModel(city: HCMCity)
        vc.delegate = self
        
        
        listCitiesSelected.append(HCMCity)
        listController.append(vc)

        setViewControllers(listController, direction: .forward, animated: false, completion: nil)
    
        for subview in self.view.subviews {
            if (subview is UIScrollView) {
                let scrollview = subview as? UIScrollView
                scrollview?.delegate = self
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

extension WeatherPageViewCotroller: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! FroceCastController).index ?? 0
        currentIndex = index
        if index == 0 {
            return nil
        }else{
            return listController[index - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! FroceCastController).index ?? 0
        currentIndex = index
        if index == listController.count - 1 {
            return nil
        }else{
            return listController[index + 1]
        }
    }
}

extension WeatherPageViewCotroller: ForecastDelegate {
    func addCities() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "citiesViewController") as! CitiesControllerViewController
        vc.delegate = self
        vc.viewModel = CitiesViewModel()
        vc.citiesSelected(cites: listCitiesSelected)
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension WeatherPageViewCotroller: CitiesSelectedDelegate {
    func citiesSelected(citiesSelected cities: [CityModel], controller: CitiesControllerViewController?) {
        setupFroceCastUI(cities: cities)
        listCitiesSelected = cities
        controller?.dismiss(animated: true, completion: nil)
    }
    private func setupFroceCastUI(cities: [CityModel]) {
        listController.removeAll()
        for (index, city) in cities.enumerated() {            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FroceCastController") as! FroceCastController
            vc.index = index
            vc.delegate = self
            vc.viewModel = ForeCastViewModel(city: city)
            let frocecastView: ForceCastView = UIView.fromNib()
            vc.weatherScrollView = WeatherScrollView.init(frame: self.view.frame, backgroundImage: UIImage(named: vc.viewModel.backgroundImage) ?? UIImage(), foregroundView: frocecastView)
            listController.append(vc)
        }
        
        let vcForRequire: FroceCastController = listController.first!
        
        setViewControllers([vcForRequire], direction: .forward, animated: false, completion: nil)
    }
}

extension WeatherPageViewCotroller: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ratio: CGFloat = (scrollView.contentOffset.x / scrollView.frame.size.width) - 1;
        
        if (ratio == 0) {
            return;
        }
        
//        if (_currentIndex != 0) {
//            // do the previous scroll
//            [((BTGlassScrollViewController*)(((UINavigationController *)_viewControllerArray[_currentIndex - 1]).viewControllers)[0]).glassScrollView scrollHorizontalRatio:-ratio-1];
//        }
//
//        if (_currentIndex != (_viewControllerArray.count - 1)) {
//            // do the next scroll
//            [((BTGlassScrollViewController*)(((UINavigationController *)_viewControllerArray[_currentIndex + 1]).viewControllers)[0]).glassScrollView scrollHorizontalRatio:-ratio+1];
//        }
        
        if currentIndex != 0 {
            let vc  = listController[currentIndex - 1] as FroceCastController
            vc.weatherScrollView.scrollHorizontalRatio(-ratio-1)
        }
        if currentIndex != (listController.count - 1) {
            
            let vc  = listController[currentIndex + 1] as FroceCastController
            
            vc.weatherScrollView.scrollHorizontalRatio(-ratio+1)
        }
    }
}
