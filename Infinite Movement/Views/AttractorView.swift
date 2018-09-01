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
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initEffect()
        initTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initEffect()
        initTapGesture()
    }
    
    // Graphical stuff, effects and shape and whatever
    
    func initEffect() {
        initLayer()
        initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .dark)))
    }
    
    func initLayer() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = frame.width * 0.5
        layer.masksToBounds = false
    }
    
    // Blur effect view - can be called to change to a different effect, like when the mass changes
    func initEffectView(effectBackground: UIVisualEffectView) {
        effectBackground.frame = bounds
        effectBackground.layer.cornerRadius = frame.width * 0.5
        effectBackground.layer.masksToBounds = true
        effectBackground.tag = 70
        addSubview(effectBackground)
        sendSubviewToBack(effectBackground)
        self.setNeedsLayout()
    }
    
    // Shadow
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
    
    // MARK: - Touches
    
    // This is purely to animate the view when it is touched - be sure to call UIView.animateTouchUp(target:) when any gesture ends to undo this
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animateTouchDown(target: self)
    }
    
}
