//
//  Vector.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/8/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

// TODO: Rewrite this as a CGPoint extension

import Foundation
import CoreGraphics

precedencegroup DotProductPrecedence {
    lowerThan: AdditionPrecedence
    associativity: left
}

infix operator •: DotProductPrecedence

extension FloatingPoint {
    var degreesToRadians: Self {return self * .pi / 180}
    var radiansToDegrees: Self {return self * 180 / .pi}
}

public struct Vector: ExpressibleByArrayLiteral, CustomStringConvertible, Equatable, Codable {
    public var x: CGFloat, y: CGFloat
    
    public var description: String {
        return "(\(x), \(y))"
    }
    
    public init() {
        x = 0.0
        y = 0.0
    }
    
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    public init(arrayLiteral: CGFloat...) {
        let count = arrayLiteral.count
        assert(count == 2, "Must initialize vector with two values")
        x = arrayLiteral[0]
        y = arrayLiteral[1]
    }
    
    public init(fromAngle theta: CGFloat, magnitude: CGFloat) {
        x = magnitude * cos(theta)
        y = magnitude * sin(theta)
    }
    
    public static func +(left: Vector, right: Vector) -> Vector {
        return [left.x + right.x, left.y + right.y]
    }
    
    public static func +=(left: inout Vector, right: Vector) {
        left = left + right
    }
    
    public static prefix func +(vector: Vector) -> Vector {
        return [vector.x, vector.y]
    }
    
    public static prefix func -(vector: Vector) -> Vector {
        return [-vector.x, -vector.y]
    }
    
    public static func -(left: Vector, right: Vector) -> Vector {
        return left + -right
    }
    
    public static func -=(left: inout Vector, right: Vector) {
        left = left - right
    }
    
    public static func *(left: Vector, right: CGFloat) -> Vector {
        return [left.x * right, left.y * right]
    }
    
    public static func *(left: CGFloat, right: Vector) -> Vector {
        return right * left
    }
    
    public static func *=(left: inout Vector, right: CGFloat) {
        left = left * right
    }
    
    public static func *(left: Vector, right: Vector) -> CGFloat {
        return left.x * right.y - left.y * right.x
    }
    
    public static func •(left: Vector, right: Vector) -> CGFloat {
        return left.x * right.x + left.y * right.y
    }
    
    public static func /(left: Vector, right: CGFloat) -> Vector {
        return [left.x/right, left.y/right]
    }
    
    public static func /=(left: inout Vector, right: CGFloat) {
        left = left/right
    }
    
    public static func ==(left: Vector, right: Vector) -> Bool {
        return left.x == right.x && left.y == right.y
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
            return atan(x/y)
        }
        set(newHeading) {
            let theta = heading - newHeading
            self = self.rotate(theta)
        }
    }
    
    public func normalize() -> Vector {
        if !isZero {
            return [x/magnitude, y/magnitude]
        }
        return [x, y]
    }
    
    public func limit(_ max: CGFloat) -> Vector {
        if magnitude > max {
            return normalize() * max
        }
        return self
    }
    
    public func rotate(_ theta: CGFloat) -> Vector {
        var result: Vector = [x, y]
        result.x = x * cos(theta) - y * sin(theta)
        result.y = x * sin(theta) + y * cos(theta)
        return result
    }
    
    public func angleBetween(_ other: Vector) -> CGFloat {
        if isZero || other.isZero {
            return 0.0
        }
        return other.heading - heading
    }
    
    public func linearInterpolate(to other: Vector, amount: CGFloat) -> Vector {
        let x = self.x + (other.x - self.x) * amount
        let y = self.y + (other.y - self.y) * amount
        return [x, y]
    }
    
    public func distanceTo(_ other: Vector) -> CGFloat {
        let temp = self - other
        return temp.magnitude
    }
    
    // Returns distance squared, useful for performance
    public func simpleDistanceTo(_ other: Vector) -> CGFloat {
        let temp = self - other
        return temp.magnitudeSquared
    }
    
    public static func random2D() -> Vector {
        let tau = UInt32(CGFloat.pi * 2)
        return Vector(fromAngle: CGFloat(arc4random_uniform(tau)), magnitude: CGFloat(arc4random_uniform(tau)))
    }
    
    public mutating func zero() {
        x = 0.0
        y = 0.0
    }
    
    public func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
}
