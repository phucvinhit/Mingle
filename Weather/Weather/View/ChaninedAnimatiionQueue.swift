//
//  ChaninedAnimatiionQueue.swift
//  Weather
//
//  Created by Vinh Pham on 9/5/19.
//  Copyright © 2019 MTechDigital. All rights reserved.
//

import Foundation
import UIKit
import Foundation

class ChainedAnimationsQueue {
    
    private var playing = false
    private var animations = [(TimeInterval, () -> Void, () -> Void)]()
    
    init() {
    }
    
    /// Queue the animated changes to one or more views using the specified duration and an initialization block.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - initializations: A block object containing the changes to commit to the views to set their initial state. This block takes no parameters and has no return value. This parameter must not be NULL.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be NULL.
    func queue(withDuration duration: TimeInterval, initializations: @escaping () -> Void, animations: @escaping () -> Void) {
        self.animations.append((duration, initializations, animations))
        if !playing {
            playing = true
            DispatchQueue.main.async {
                self.next()
            }
        }
    }
    
    private func next() {
        if animations.count > 0 {
            let animation = animations.removeFirst()
            animation.1()
            UIView.animate(withDuration: animation.0, animations: animation.2, completion: { finished in
                self.next()
            })
        } else {
            playing = false
        }
    }
}
