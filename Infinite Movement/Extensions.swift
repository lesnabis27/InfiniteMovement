//
//  Extensions.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/16/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

extension FloatingPoint {
    var degreesToRadians: Self {return self * .pi / 180}
    var radiansToDegrees: Self {return self * 180 / .pi}
}

// Dot product operator

precedencegroup DotProductPrecedence {
    lowerThan: AdditionPrecedence
    associativity: left
}

infix operator •: DotProductPrecedence

// Incorporate vector operations into CGPoint
extension CGPoint {
    
    public static let tau = CGFloat.pi * 2
    
    public init(fromAngle theta: CGFloat, magnitude: CGFloat) {
        self.init(x: magnitude * cos(theta), y: magnitude * sin(theta))
    }
    
    public static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    public static func +=(left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    public static prefix func +(point: CGPoint) -> CGPoint {
        return point
    }
    
    public static prefix func -(point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
 
    public static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    public static func -=(left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    
    public static func *(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    public static func *(left: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x: left * right.x, y: left * right.y)
    }
    
    public static func *=(left: inout CGPoint, right: CGFloat) {
        return left = left * right
    }
    
    public static func *(left: CGPoint, right: CGPoint) -> CGFloat {
        return left.x * right.y - left.y * right.x
    }
    
    public static func •(left: CGPoint, right: CGPoint) -> CGFloat {
        return left.x * right.x + left.y * right.y
    }
    
    public static func /(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    public static func /(left: CGPoint, right: Int) -> CGPoint {
        return left / CGFloat(right)
    }
    
    public static func /=(left: inout CGPoint, right: CGFloat) {
        left = left / right
    }
    
    public static func /=(left: inout CGPoint, right: Int) {
        left = left / right
    }
    
    public mutating func zero() {
        x = 0
        y = 0
    }
    
    public var isZero: Bool {
        return x == 0.0 && y == 0.0
    }
    
    
    public var magnitude: CGFloat {
        get {
            return sqrt(x * x + y * y)
        }
        set(newMagnitude) {
            self = normalize() * newMagnitude
        }
    }
    
    public var magnitudeSquared: CGFloat {
        return x * x + y * y
    }
    
    public var heading: CGFloat {
        get {
            if isZero {
                return 0.0
            }
            return atan(x / y)
        }
        set(newHeading) {
            let theta = heading - newHeading
            self = self.rotate(theta)
        }
    }
    
    public func normalize() -> CGPoint {
        if !isZero {
            return CGPoint(x: x / magnitude, y: y / magnitude)
        }
        return self
    }
    
    public func limit(_ max: CGFloat) -> CGPoint {
        if magnitude > max {
            return normalize() * max
        }
        return self
    }
    
    public func rotate(_ theta: CGFloat) -> CGPoint {
        var result = CGPoint(x: x, y: y)
        result.x = x * cos(theta) - y * sin(theta)
        result.y = x * sin(theta) + y * cos(theta)
        return result
    }
    
    public func angleTo(_ other: CGPoint) -> CGFloat {
        if isZero || other.isZero {
            return 0.0
        }
        return other.heading - heading
    }
    
    public func linearInterpolate(to other: CGPoint, amount: CGFloat) -> CGPoint {
        let x = self.x + (other.x - self.x) * amount
        let y = self.y + (other.y - self.y) * amount
        return CGPoint(x: x, y: y)
    }
    
    public func distanceTo(_ other: CGPoint) -> CGFloat {
        let temp = self - other
        return temp.magnitude
    }
    
    // Returns distance without finding square root, good for performance when real distance isn't necessary
    public func squaredDistanceTo(_ other: CGPoint) -> CGFloat {
        let temp = self - other
        return temp.magnitudeSquared
    }
    
    public static func randomVector() -> CGPoint {
        return CGPoint.init(fromAngle: CGFloat.random(in: 0..<tau), magnitude: CGFloat.random(in: 0...1))
    }
    
}

extension Array {
    
    // Rotate array by a given number of positions
    public mutating func shiftRight(by amount: Int = 1) {
        var shiftAmount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if shiftAmount < 0 {
            shiftAmount += count
        }
        self = Array(self[shiftAmount..<count] + self[0..<shiftAmount])
    }
    
}

extension UIBezierPath {
    
    // Create a curve from an array of CGPoints
    convenience init(curveFrom points: [CGPoint]) {
        self.init()
        
        let controlPoints = Curve.controlPoints(from: points)
        
        self.move(to: points[0])
        for index in 1..<points.count {
            let segment = controlPoints[index - 1]
            self.addCurve(to: points[index], controlPoint1: segment.controlPoint1, controlPoint2: segment.controlPoint2)
        }
    }
    
    // Create a computationally simpler(?) curve from an array of CGPoints
    convenience init(simpleCurveFrom points: [CGPoint]) {
        self.init()
        
        self.move(to: points[0])
        var tangent = points[1] - points[0]
        tangent *= 0.1
        var controlPoint1 = points[0] + tangent
        
        for index in 1..<points.count - 1 {
            tangent = points[index + 1] - points[index - 1]
            tangent = tangent.normalize()
            tangent *= 0.1
            let controlPoint2 = points[index] - tangent
            self.addCurve(to: points[index], controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            controlPoint1 = points[index] + tangent
        }
    }
    
    // Create a series of line segments from an array of CGPoints
    convenience init(linesFrom points: [CGPoint]) {
        self.init()
        
        self.move(to: points[0])
        for index in 1..<points.count {
            self.addLine(to: points[index])
        }
    }
    
}
