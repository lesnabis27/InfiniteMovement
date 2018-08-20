//
//  DraggableViewDelegate.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/15/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

@objc
protocol DraggableViewDelegate: class {
    @objc optional func panGestureDidBegin(_ panGesture: UIPanGestureRecognizer, originalCener: CGPoint, sender: UIView)
    @objc optional func panGestureDidChange(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, sender: UIView)
    @objc optional func panGestureDidEnd(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, sender: UIView)
    @objc optional func panGestureStateToOriginal(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, sender: UIView)
}
