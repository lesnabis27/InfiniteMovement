//
//  LongPressableViewDelegate.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/26/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

@objc
protocol LongPressableViewDelegate: class {
    @objc optional func longPressGestureDidBegin(_ tapGesture: UITapGestureRecognizer, location: CGPoint)
    @objc optional func longPressGestureDidEnd(_ tapGesture: UITapGestureRecognizer, location: CGPoint)
}
