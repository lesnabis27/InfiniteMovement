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
    let effectBackground = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
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
    
}
