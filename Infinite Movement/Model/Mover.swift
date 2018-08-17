//
//  Mover.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/16/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

// An object that moves around the canvas in accordance with the physics

class Mover: NSObject, Massive {
    
    // MARK: - Properties
    
    var location: CGPoint
    var velocity: CGPoint
    var acceleration: CGPoint
    var mass: CGFloat
    var color: UIColor
    
    // MARK: - Initializers
    
    override init() {
        location = CGPoint()
        velocity = CGPoint()
        acceleration = CGPoint()
        mass = 1.0
        color = UIColor.orange
        super.init()
    }
    
    init(at point: CGPoint) {
        location = point
        velocity = CGPoint()
        acceleration = CGPoint()
        mass = 1.0
        color = UIColor.orange
        super.init()
    }
    
    init(in view: UIView) {
        location = CGPoint(
            x: CGFloat.random(in: 0...view.bounds.width),
            y: CGFloat.random(in: 0...view.bounds.height)
        )
        velocity = CGPoint()
        acceleration = CGPoint()
        mass = 1.0
        color = UIColor.orange
        super.init()
    }
    
    // MARK: - Movement
    
    func move() {
        velocity = velocity.limit(10) // TODO: Change velocity limit to a user definable constant
        velocity += acceleration
        location += velocity
        acceleration.zero()
    }
    
    // Wrap mover to other side of view when outside bounds
    func wrap(in view: UIView) {
        let maxX = view.bounds.width
        let maxY = view.bounds.height
        if location.x < 0 {
            location.x += maxX
        } else if location.x > maxX {
            location.x -= maxX
        }
        if location.y < 0 {
            location.y += maxY
        } else if location.y > maxY {
            location.y -= maxY
        }
    }
    
    // Bounce mover off of bounds of view
    func bounce(in view: UIView) {
        let maxX = view.bounds.width
        let maxY = view.bounds.height
        if location.x < 0 || location.x > maxX {
            velocity.x *= -1
        }
        if location.y < 0 || location.y > maxY {
            velocity.y *= -1
        }
    }
    
    func seek(movers: [Mover]) {
        for mover in movers {
            if mover != self {
                seek(mover)
            }
        }
    }
    
    func seek(attractors: [Attractor]) {
        for attractor in attractors {
            seek(attractor)
        }
    }
    
    func seek(_ other: Massive) {
        var temp = other.location - location
        temp = temp.normalize()
        temp *= mass * other.mass / location.squaredDistanceTo(other.location)
        temp *= 0.1 // TODO: Change G to a user definable constant
        acceleration += temp
    }
    
    func averageAcceleration(_ count: CGFloat) {
        if count > 1 {
            acceleration /= count
        }
    }

}
