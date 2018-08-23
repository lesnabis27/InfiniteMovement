//
//  Curve.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/22/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

// Adapted from code by Ramsundar Shandilya to produce Cubic Curves from a set of points

//  The MIT License (MIT)
//
//  Copyright (c) 2015 Ramsundar Shandilya
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//

import Foundation
import UIKit

struct CurveSegment {
    let controlPoint1: CGPoint
    let controlPoint2: CGPoint
}

class Curve {
    
    static func controlPoints(from points: [CGPoint]) -> [CurveSegment] {
        
        var firstControlPoints = [CGPoint?]()
        var secondControlPoints = [CGPoint?]()
        let numberOfSegments = points.count - 1
        
        if numberOfSegments == 1 {
            // P0 and P3 are the end points, P1 and P2 are the control points
            let P0 = points[0]
            let P3 = points[1]
            // Calculate the first control point
            let P1 = (2 * P0 + P3) / 3
            firstControlPoints.append(P1)
            // Calculate the second control point
            let P2 = 2 * P1 - P0
            secondControlPoints.append(P2)
        } else {
            firstControlPoints = Array(repeating: nil, count: numberOfSegments)
            var rhsArray = [CGPoint]()
            // Array of coefficients
            var a = [CGFloat]()
            var b = [CGFloat]()
            var c = [CGFloat]()
            // Populate the arrays
            for index in 0..<numberOfSegments {
                var rhsPoint = CGPoint()
                let P0 = points[index]
                let P3 = points[index + 1]
                if index == 0 {
                    // First segment
                    a.append(0)
                    b.append(2)
                    c.append(1)
                    rhsPoint = P0 + 2 * P3
                } else if index == numberOfSegments - 1 {
                    // Last segment
                    a.append(2)
                    b.append(7)
                    c.append(0)
                    rhsPoint = 8 * P0 + P3
                } else {
                    // Every other segment
                    a.append(1)
                    b.append(4)
                    c.append(1)
                    rhsPoint = 4 * P0 + 2 * P3
                }
                rhsArray.append(rhsPoint)
            }
            for index in 1..<numberOfSegments {
                let rhsPoint = rhsArray[index]
                let previousRhsPoint = rhsArray[index - 1]
                let m = a[index] / b[index - 1] // What does 'm' stand for?
                let b1 = b[index] - m * c[index - 1]
                b[index] = b1
                let r2 = rhsPoint - m * previousRhsPoint
                rhsArray[index] = r2
            }
            // Last control points
            let lastControlPoint = rhsArray[numberOfSegments - 1] / b[numberOfSegments - 1]
            firstControlPoints[numberOfSegments - 1] = lastControlPoint
            for index in (0..<numberOfSegments - 1).reversed() {
                if let nextControlPoint = firstControlPoints[index + 1] {
                    let controlPoint = (rhsArray[index] - c[index] * nextControlPoint) / b[index]
                    firstControlPoints[index] = controlPoint
                }
            }
            // Second control points
            for index in 0..<numberOfSegments {
                if index == numberOfSegments - 1 {
                    let P3 = points[index + 1]
                    guard let P1 = firstControlPoints[index] else {
                        continue
                    }
                    let controlPoint = (P3 + P1) / 2
                    secondControlPoints.append(controlPoint)
                } else {
                    let P3 = points[index + 1]
                    guard let nextP1 = firstControlPoints[index + 1] else {
                        continue
                    }
                    let controlPoint = 2 * P3 - nextP1
                    secondControlPoints.append(controlPoint)
                }
            }
        }
        
        var controlPoints = [CurveSegment]()
        
        for index in 0..<numberOfSegments {
            if let firstControlPoint = firstControlPoints[index], let secondControlPoint = secondControlPoints[index] {
                let segment = CurveSegment(controlPoint1: firstControlPoint, controlPoint2: secondControlPoint)
                controlPoints.append(segment)
            }
        }
        
        return controlPoints
        
    }
    
}
