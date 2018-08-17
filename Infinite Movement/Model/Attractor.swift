//
//  Attractor.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/15/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

// Attractor stores a view to visualize a gravitational point and the model to interact with the physics simulation

class Attractor: DraggableViewDelegate, Massive {
    
    var view: AttractorView
    var location: CGPoint
    var mass: CGFloat
    
    fileprivate let radius: CGFloat = 20.0
    
    init(_ point: CGPoint) {
        view = AttractorView(frame: CGRect(
                                    x: point.x - radius * 0.5,
                                    y: point.y - radius * 0.5,
                                    width: radius,
                                    height: radius)
        )
        self.location = point
        mass = 100
    }
    
}
