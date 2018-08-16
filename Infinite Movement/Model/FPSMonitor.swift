//
//  FPSMonitor.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/8/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Foundation

// FPSMonitor is a structure to implement easy frequency tracking, especially in animation contexts
// Create an instance and be sure to run update() once every loop

struct FPSMonitor {
    
    fileprivate let timeIntervalsArrayCount = 20
    
    var timeLastFired: TimeInterval
    var timeSinceLastFired: TimeInterval
    var timeIntervals: [TimeInterval]
    
    var average: TimeInterval {
        get {
            return timeIntervals.reduce(0, +)/Double(timeIntervals.count)
        }
    }
    var string: String {
        get {
            return String(format: "%.2f", 1/timeSinceLastFired)
        }
    }
    var averageString: String {
        get {
            return String(format: "%.2f", 1/average)
        }
    }
    
    init() {
        timeLastFired = Date.timeIntervalSinceReferenceDate
        timeSinceLastFired = 0.0
        timeIntervals = [TimeInterval](repeating: timeSinceLastFired, count: timeIntervalsArrayCount)
        
    }
    
    mutating func update() {
        timeSinceLastFired = Date.timeIntervalSinceReferenceDate - timeLastFired
        timeLastFired = Date.timeIntervalSinceReferenceDate
        updateTimeIntervalsArray(with: timeSinceLastFired)
    }
    
    fileprivate mutating func updateTimeIntervalsArray(with newElement: TimeInterval) {
        for i in 0..<timeIntervals.count-1 {
            timeIntervals[i] = timeIntervals[i+1]
        }
        timeIntervals[timeIntervals.count-1] = newElement
    }
    
}
