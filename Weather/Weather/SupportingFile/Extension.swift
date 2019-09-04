//
//  StringExtension.swift
//  Weather
//
//  Created by Vinh Pham on 9/3/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func convertToTemperature() -> String {
        let stringTemperature: String = String(format:"\(self) °")
        
        return stringTemperature
    }
    
    func convertToDate() -> String {
        
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEEE"

        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
    
    //  If there are multiple storyboards in the project, each one must be named here:
    enum Storyboard: String {
        case Main
    }
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle?) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Could not find view controller with name \(T.storyboardIdentifier)")
        }
        
        return viewController
    }
    
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

