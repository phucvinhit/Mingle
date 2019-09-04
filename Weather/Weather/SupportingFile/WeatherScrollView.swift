//
//  WeatherScrollView.swift
//  Weather
//
//  Created by Vinh Pham on 9/1/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import UIKit

//default blur settings
let DEFAULT_BLUR_RADIUS: CGFloat = 14
let DEFAULT_BLUR_TINT_COLOR = UIColor(white: 0, alpha: 0.3)
let DEFAULT_BLUR_DELTA_FACTOR: CGFloat = 1.4

//how much the background moves when scroll
let DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL: CGFloat = 30
let DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL: CGFloat = 150
let DEFAULT_HEIGHT_CURRENT_WEATHER: CGFloat = 210


//the value of the fading space on the top between the view and navigation bar
let DEFAULT_TOP_FADING_HEIGHT_HALF: CGFloat = 10.0

class WeatherScrollView: UIView {

    let weatherService = WeatherService()
    var backgroundImage: UIImage?
    var blurredBackgroundImage: UIImage?
    
    var backgroundScrollView: UIScrollView!
    var foregroundView: ForceCastView!
    
    private var constraitView: UIView!
    private var backgroundImageView: UIImageView?
    private var blurredBackgroundImageView: UIImageView!
    private var foregroundContainerView: UIView!
    private var foregroundScrollView: UIScrollView!
//    private var topShadowLayer: CALayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, backgroundImage: UIImage, foregroundView: ForceCastView) {
        super.init(frame: frame)
        self.backgroundImage = backgroundImage
        blurredBackgroundImage = backgroundImage.applyBlurWithRadius(DEFAULT_BLUR_RADIUS, tintColor: DEFAULT_BLUR_TINT_COLOR, saturationDeltaFactor: DEFAULT_BLUR_DELTA_FACTOR)
        self.foregroundView = foregroundView
        
        // create subviews
        createBackgroundView()
        createForegroundView()
    }
    
    
    func scrollHorizontalRatio(_ ratio: CGFloat) {
        backgroundScrollView.setContentOffset(CGPoint(x: DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL + ratio * DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, y: backgroundScrollView.contentOffset.y ), animated: false)
    } //from -1 to 1
    
    func scrollVertically(toOffset offsetY: CGFloat) {
    }
    
    // change background image on the go
    func setBackgroundImage(_ backgroundImage: UIImage?, overWriteBlur: Bool, animated: Bool, duration interval: TimeInterval) {
    }
    
    func blurBackground(_ shouldBlur: Bool) {
    }

    
    private func createBackgroundView() {
        backgroundScrollView = UIScrollView(frame: frame)
        backgroundScrollView?.isUserInteractionEnabled = false
        let sizedForContent = CGSize(width: frame.size.width + 2 * DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, height: frame.size.height + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)
        backgroundScrollView?.contentSize = sizedForContent
        backgroundScrollView?.contentOffset = CGPoint(x: DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, y: 0)
        
        let viewConstraitView = UIView(frame: CGRect(origin: CGPoint.zero, size: sizedForContent))
        constraitView = viewConstraitView
        backgroundScrollView.addSubview(constraitView ?? UIView())
        self.addSubview(backgroundScrollView ?? UIScrollView())
        
        createBackGroundImageView()
    }
    
    private func createBackGroundImageView() {
        backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView?.contentMode = .scaleAspectFill
        backgroundImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        constraitView?.addSubview(backgroundImageView ?? UIImageView())

        blurredBackgroundImageView = UIImageView(image: blurredBackgroundImage)
        blurredBackgroundImageView?.contentMode = .scaleAspectFill
        blurredBackgroundImageView?.translatesAutoresizingMaskIntoConstraints = false
        blurredBackgroundImageView?.alpha = 0.0
        
        constraitView?.addSubview(blurredBackgroundImageView ?? UIImageView())

        constraitView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: [], metrics: nil, views: [
            "backgroundImageView" : backgroundImageView as Any ]))
        constraitView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: [], metrics: nil, views: [
            "backgroundImageView" : backgroundImageView as Any
            ]))
        constraitView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[blurredBackgroundImageView]|", options: [], metrics: nil, views: [
            "blurredBackgroundImageView" : blurredBackgroundImageView as Any
            ]))
        constraitView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[blurredBackgroundImageView]|", options: [], metrics: nil, views: [
            "blurredBackgroundImageView" : blurredBackgroundImageView as Any
            ]))

    }
    
    private func createForegroundView() {
        foregroundContainerView = UIView(frame: frame)
        self.addSubview(foregroundContainerView)
        
        foregroundScrollView = UIScrollView(frame: frame)
        foregroundScrollView.delegate = self
        foregroundScrollView.showsVerticalScrollIndicator = false
        foregroundScrollView.showsHorizontalScrollIndicator = false
        
        foregroundContainerView.addSubview(foregroundScrollView)
        
        var frameOffset = foregroundView.frame
        frameOffset.origin.y = frame.size.height - DEFAULT_HEIGHT_CURRENT_WEATHER
        
        
        foregroundView.layoutSubviews()
        foregroundScrollView.addSubview(foregroundView)
        foregroundView.frame = frameOffset
        
        foregroundScrollView.contentSize = CGSize(width: frame.size.width, height: foregroundView.frame.size.height + foregroundView.frame.origin.y)
    }
    
//    private func createTopShadow(){
//        topShadowLayer = createTopMask(with: CGSize(width: frame.width, height:DEFAULT_TOP_FADING_HEIGHT_HALF), startFadeAt: 0 - DEFAULT_TOP_FADING_HEIGHT_HALF, endAt: DEFAULT_TOP_FADING_HEIGHT_HALF, topColor: .init(white: 0, alpha: 0.15), botColor: .init(white: 0, alpha: 0))
////        layer.insertSu
//    }
    
    private func createTopMask(with size: CGSize, startFadeAt top: CGFloat, endAt bottom: CGFloat, topColor: UIColor?, botColor: UIColor?) -> CALayer? {
        var top = top
        var bottom = bottom
        top = top / size.height
        bottom = bottom / size.height
        
        let maskLayer = CAGradientLayer()
        maskLayer.anchorPoint = CGPoint.zero
        maskLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        maskLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        //an array of colors that dictatates the gradient(s)
        maskLayer.colors = [
            topColor?.cgColor,
            topColor?.cgColor,
            botColor?.cgColor,
            botColor?.cgColor
            ].compactMap { $0 }
        maskLayer.locations = [NSNumber(value: 0.0), NSNumber(value: Float(top)), NSNumber(value: Float(bottom)), NSNumber(value: 1.0)]
        maskLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return maskLayer
    }

    
    public func loadWeather(listWeather: [List]){
        self.foregroundView.fillWeather(weatherOfDates: listWeather)
    }
    
    public func loadImage(imageAtIndex: (UIImage, Int)) {
        
    }
}

extension WeatherScrollView:  UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var ratio = (scrollView.contentOffset.y + foregroundScrollView.contentInset.top) / (foregroundScrollView.frame.size.height - foregroundScrollView.contentInset.top)
        ratio = ratio < 0 ? 0 : ratio
        ratio = ratio > 1 ? 1: ratio
        
        backgroundScrollView.contentOffset = CGPoint(x: DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, y: ratio * DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)
        
        //set alpha
        blurredBackgroundImageView.alpha = ratio
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pointY =  CGFloat(targetContentOffset.pointee.y)
        var ratio = (pointY + foregroundScrollView.contentInset.top) / (foregroundScrollView.frame.size.height - foregroundScrollView.contentInset.top)
        
        //it cannot be inbetween 0 to 1 so if it is >.5 it is one, otherwise 0
        if ratio > 0 && ratio < 1 {
            if velocity.y == 0 {
                ratio = ratio > 0.5 ? 1 : 0
            } else if velocity.y > 0 {
                ratio = ratio > 0.1 ? 1 : 0
            } else {
                ratio = ratio > 0.9 ? 1 : 0
            }
            targetContentOffset.pointee.y = ratio * foregroundView.frame.origin.y - foregroundScrollView.contentInset.top
        }
    }
}
