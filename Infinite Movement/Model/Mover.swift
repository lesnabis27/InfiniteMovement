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
    
    var locations: [CGPoint]?
    var velocity = CGPoint()
    var acceleration = CGPoint()
    var mass: CGFloat = 1
    var color = UIColor.orange
    
    static var maxVelocity: CGFloat = 10.0
    
    // Return the first item in locations, rotate locations and set current location
    var location: CGPoint {
        get {
            return locations!.last!
        }
        set(newLocation) {
            locations!.shiftRight()
            locations![locations!.count - 1] = newLocation
        }
    }
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        initLocations(at: CGPoint())
    }
    
    init(at point: CGPoint) {
        super.init()
        initLocations(at: point)
    }
    
    init(in view: UIView) {
        super.init()
        let startingPoint = CGPoint(
            x: CGFloat.random(in: 0...view.bounds.width),
            y: CGFloat.random(in: 0...view.bounds.height)
        )
        initLocations(at: startingPoint)
    }
    
    // Initialize locations with given CGPoint
    private func initLocations(at point: CGPoint) {
        locations = Array(repeating: point, count: 10)
    }
    
    // MARK: - Movement
    
    // Add acceleration to velocity, reset acceleration for next loop
    func applyAcceleration() {
        velocity += acceleration
        velocity = velocity.limit(Mover.maxVelocity) // TODO: Change velocity limit to a user definable constant
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
    
    // Bounce mover off of bounds of view - reverses velocity until location is back in bounds
    func bounce(in view: UIView) {
        let maxX = view.bounds.width
        let maxY = view.bounds.height
        if location.x < 0 {
            velocity.x = abs(velocity.x)
        } else if location.x > maxX {
            velocity.x = abs(velocity.x) * -1
        }
        if location.y < 0 {
            velocity.y = abs(velocity.y)
        } else if location.y > maxY {
            velocity.y = abs(velocity.y) * -1
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
    
    // Apply friction, lowering the velocity by a percentage
    func friction() {
        velocity *= 1
    }
    
    // MARK: - Drawing
    
    // Draw an ellipse
    func draw(in view: UIView) {
        let path = UIBezierPath(ovalIn: CGRect(
            origin: location,
            size: CGSize(width: 10, height: 10)
        ))
        strokePath(path, in: view)
    }
    
    // Draw a series of lines
    func drawLines(in view: UIView) {
        splitBezierPathAndDrawLines(from: locations!, in: view)
    }
    
    // Draw a curve - not in use, just here for reference
    func drawCurve(in view: UIView) {
        let path = UIBezierPath(curveFrom: locations!)
        strokePath(path, in: view)
    }
    
    // Draw a simple curve - not in use just here for reference
    func drawSimpleCurve(in view: UIView) {
        let path = UIBezierPath(simpleCurveFrom: locations!)
        strokePath(path, in: view)
    }
    
    // Set up and stroke a path
    func strokePath(_ path: UIBezierPath, in view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        view.layer.addSublayer(shapeLayer)
    }

    // Splits an array of points by gaps of a distance and strokes paths from the arrays
    private func splitBezierPathAndDrawLines(from points: [CGPoint], in view: UIView) {
        var paths = [[CGPoint]]()
        var startNewPath = true
        for index in 0..<points.count {
            if startNewPath {
                paths.append([CGPoint]())
                startNewPath = false
            }
            paths[paths.count - 1].append(points[index])
            if index < points.count - 1 && points[index].distanceTo(points[index + 1]) > Mover.maxVelocity + 1 {
                startNewPath = true
            }
        }
        for path in paths {
            if path.count > 1 {
                let bezierPath = UIBezierPath(linesFrom: path)
                strokePath(bezierPath, in: view)
            }
        }
    }
    
}
