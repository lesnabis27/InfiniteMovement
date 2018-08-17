//
//  Massive.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/17/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

@objc
protocol Massive {
    var location: CGPoint { get set }
    var mass: CGFloat { get set }
}
