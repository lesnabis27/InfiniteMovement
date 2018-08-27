//
//  Attractor.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/15/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

// Attractor stores a view to visualize a gravitational point and the model to interact with the physics simulation

class Attractor: NSObject, DraggableViewDelegate, UIGestureRecognizerDelegate, TappableViewDelegate, Massive {
    
    var view: AttractorView
    var location: CGPoint
    var mass: CGFloat
    var index: Double
    var delegate: AttractorDelegate?
    
    fileprivate let radius: CGFloat = 20.0
    
    init(_ point: CGPoint) {
        view = AttractorView(frame: CGRect(
                                    x: point.x - radius,
                                    y: point.y - radius,
                                    width: radius * 2,
                                    height: radius * 2)
        )
        location = point
        mass = 1000
        index = Date.timeIntervalSinceReferenceDate
        super.init()
        view.delegate = self
        view.tapDelegate = self
        // If instantiated outside the safe area, move it to the safe area
    }
    
    // MARK: - DraggableViewDelegate
    
    func panGestureDidBegin(_ panGesture: UIPanGestureRecognizer, originalCener: CGPoint, sender: UIView) {
        // Unused right now
    }
    
    func panGestureDidChange(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, sender: UIView) {
        location = originalCenter + translation
    }
    
    func panGestureDidEnd(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, sender: UIView) {
        // Constrain attractor to safe area, not available before iOS 11
        if #available(iOS 11.0, *) {
            if location.y < (sender.superview?.safeAreaInsets.top)! {
                location.y = (sender.superview?.safeAreaInsets.top)! + radius
                sender.center.y = location.y
            } else if location.y > (sender.superview?.frame.height)! - (sender.superview?.safeAreaInsets.bottom)! {
                location.y = (sender.superview?.frame.height)! - (sender.superview?.safeAreaInsets.bottom)! - radius
                sender.center.y = location.y
            }
        }
        // Return view to original scale
        UIView.animateTouchUp(target: sender)
        view.center = location
    }
    
    // MARK: - TappableViewDelegate
    
    func tapGestureDidEnd(_ tapGesture: UITapGestureRecognizer, location: CGPoint) {
        delegate?.removeFromArray(self)
        // Animate view leaving
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        }) {
            (value: Bool) in
            self.view.removeFromSuperview()
        }
    }
    
    // MARK: - Equatable (NSObject)
    
    // Match location and mass -- not 100% foolproof but easy and at this scale nearly impossible that two Attractors will falsly match
    static func == (lhs: Attractor, rhs: Attractor) -> Bool {
        return lhs.location == rhs.location && lhs.mass == rhs.mass
    }
    
}
