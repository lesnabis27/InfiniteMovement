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
    
    var location = CGPoint()
    var velocity = CGPoint()
    var acceleration = CGPoint()
    var mass: CGFloat = 1
    var color = UIColor.orange
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    init(at point: CGPoint) {
        location = point
        super.init()
    }
    
    init(in view: UIView) {
        location = CGPoint(
            x: CGFloat.random(in: 0...view.bounds.width),
            y: CGFloat.random(in: 0...view.bounds.height)
        )
        super.init()
    }
    
    // MARK: - Movement
    
    // Add acceleration to velocity, reset acceleration for next loop
    func applyAcceleration() {
        velocity += acceleration
        velocity = velocity.limit(10) // TODO: Change velocity limit to a user definable constant
        acceleration.zero()
    }
    
    // Add velocity to location
    func applyVelocity() {
        location += velocity
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
    
    // Accelerate toward an array of movers
    func seek(movers: [Mover]) {
        for mover in movers {
            if mover != self {
                seek(mover)
            }
        }
    }
    
    // Accelerate toward an array of attractors
    func seek(attractors: [Attractor]) {
        for attractor in attractors {
            seek(attractor)
        }
    }
    
    // Accelerate toward a single massive object
    func seek(_ other: Massive) {
        var temp = other.location - location
        temp = temp.normalize()
        temp *= mass * other.mass / location.distanceTo(other.location)
        temp *= 1 // TODO: Change G to a user definable constant
        acceleration += temp
    }
    
    // Divide the acceleration by a number, averaging by number of objects contributing to acceleration
    func averageAcceleration(_ count: Int) {
        if count > 1 {
            acceleration /= count
        }
    }
    
    // MARK: - Drawing
    
    func draw(in view: UIView) {
        let path = UIBezierPath(ovalIn: CGRect(
            origin: location,
            size: CGSize(width: 10, height: 10)
        ))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        view.layer.addSublayer(shapeLayer)
    }

}
