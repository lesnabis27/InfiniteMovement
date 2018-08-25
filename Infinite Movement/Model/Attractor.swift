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
    
    fileprivate let diameter: CGFloat = 40.0
    
    init(_ point: CGPoint) {
        view = AttractorView(frame: CGRect(
                                    x: point.x - diameter * 0.5,
                                    y: point.y - diameter * 0.5,
                                    width: diameter,
                                    height: diameter)
        )
        location = point
        mass = 1000
        index = Date.timeIntervalSinceReferenceDate
        view.delegate = self
        view.tapDelegate = self
    }
    
    // MARK: - DraggableViewDelegate
    
    func panGestureDidBegin(_ panGesture: UIPanGestureRecognizer, originalCener: CGPoint, sender: UIView) {
        // Animation
    }
    
    func panGestureDidChange(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, sender: UIView) {
        location = originalCenter + translation
    }
    
    func panGestureDidEnd(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, sender: UIView) {
        if location.y < (sender.superview?.safeAreaInsets.top)! {
            location.y = (sender.superview?.safeAreaInsets.top)! + diameter * 0.5
            sender.center.y = location.y
        } else if location.y > (sender.superview?.frame.height)! - (sender.superview?.safeAreaInsets.bottom)! {
            location.y = (sender.superview?.frame.height)! - (sender.superview?.safeAreaInsets.bottom)! - diameter * 0.5
            sender.center.y = location.y
        }
        // Animation
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
