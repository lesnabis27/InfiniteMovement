//
//  Attractor.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/15/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

// Attractor stores a view to visualize a gravitational point and the model to interact with the physics simulation

class Attractor: DraggableViewDelegate, TappableViewDelegate, Massive, Equatable {
    
    var view: AttractorView
    var location: CGPoint
    var mass: CGFloat
    var index: Double
    var delegate: AttractorDelegate?
    
    fileprivate let radius: CGFloat = 40.0
    
    init(_ point: CGPoint) {
        view = AttractorView(frame: CGRect(
                                    x: point.x - radius * 0.5,
                                    y: point.y - radius * 0.5,
                                    width: radius,
                                    height: radius)
        )
        location = point
        mass = 1000
        index = Date.timeIntervalSinceReferenceDate
        view.delegate = self
        view.tapDelegate = self
    }
    
    // MARK: - DraggableViewDelegate
    
    func panGestureDidBegin(_ panGesture: UIPanGestureRecognizer, originalCener: CGPoint, sender: UIView) {
        
    }
    
    func panGestureDidChange(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, sender: UIView) {
        location = originalCenter + translation
    }
    
    // MARK: - TappableViewDelegate
    
    func tapGestureDidEnd(_ tapGesture: UITapGestureRecognizer, location: CGPoint) {
        // Send identifier to ViewController to remove this object from the array
        delegate?.removeFromArray(self)
        view.removeFromSuperview()
    }
    
    // MARK: - Equatable
    
    // Match location and mass -- not 100% foolproof but easy and at this scale nearly impossible that two Attractors will falsly match
    static func == (lhs: Attractor, rhs: Attractor) -> Bool {
        return lhs.location == rhs.location && lhs.mass == rhs.mass
    }
    
}
