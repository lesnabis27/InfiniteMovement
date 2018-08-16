//
//  TappableViewDelegate.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/15/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

@objc
protocol TappableViewDelegate: class {
    @objc optional func tapGestureDidBegin(_ tapGesture: UITapGestureRecognizer, location: CGPoint)
    @objc optional func tapGestureDidEnd(_ tapGesture: UITapGestureRecognizer, location: CGPoint)
}
