//
//  AttractorView.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/15/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

// This is a dot to represent a gravitational attractor on the screen

class AttractorView: DraggableView {
    
    weak var tapDelegate: TappableViewDelegate?
    weak var longPressDelegate: LongPressableViewDelegate?
    var tapGestureRecognizer: UITapGestureRecognizer?
    var longPressGestureRecognizer: UILongPressGestureRecognizer?
    let effectBackground = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initEffect()
        initTapGesture()
        initLongPressGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initEffect()
        initTapGesture()
        initLongPressGesture()
    }
    
    // Graphical stuff, effects and shape and whatever
    
    func initEffect() {
        initLayer()
        initEffectView()
    }
    
    func initLayer() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = frame.width * 0.5
        layer.masksToBounds = false
    }
    
    func initEffectView() {
        effectBackground.frame = bounds
        effectBackground.layer.cornerRadius = frame.width * 0.5
        effectBackground.layer.masksToBounds = true
        addSubview(effectBackground)
        sendSubviewToBack(effectBackground)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.width * 0.5)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4
        layer.shadowPath = shadowPath.cgPath
    }
    
    // MARK: - Lifecycle
    
    // Make the view big and transparent to prepare for intro animation
    override func willMove(toWindow newWindow: UIWindow?) {
        self.alpha = 0.0
        self.transform = CGAffineTransform.init(scaleX: 3, y: 3)
    }
    
    // Animate the view being added to the screen
    override func didMoveToWindow() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Tap Gesture Recognizer
    
    func initTapGesture() {
        isUserInteractionEnabled = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        self.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc func tapGestureAction(_ tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: superview)
        
        switch tapGesture.state {
        case .ended:
            tapDelegate?.tapGestureDidEnd?(tapGesture, location: location)
            break
        default:
            break
        }
    }
    
    // MARK: - Long Press Gesture Recognizer
    
    func initLongPressGesture() {
        isUserInteractionEnabled = true
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(_:)))
        longPressGestureRecognizer!.minimumPressDuration = 1
        self.addGestureRecognizer(longPressGestureRecognizer!)
    }
    
    @objc func longPressGestureAction(_ longPressGesture: UILongPressGestureRecognizer) {
        switch longPressGesture.state {
        case .began:
            break
        case .ended:
            UIView.animateTouchUp(target: self)
            break
        default:
            break
        }
    }
    
    // MARK: - Touches
    
    // This is purely to animate the view when it is touched - be sure to call UIView.animateTouchUp(target:) when any gesture ends to undo this
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animateTouchDown(target: self)
    }
    
}
