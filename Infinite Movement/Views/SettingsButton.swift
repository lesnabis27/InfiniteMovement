//
//  SettingsButton.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 9/2/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

@IBDesignable class SettingsButton: UIButton {
    
    // MARK: - IBInspectable Properties
    
    @IBInspectable var iconDiameter: CGFloat = 0.5
    @IBInspectable var strokeWeight: CGFloat = 3.0
    @IBInspectable var strokeColor: UIColor = UIColor.lightGray
    @IBInspectable var cogLength: CGFloat = 0.1
    @IBInspectable var numberOfCogs: Int = 8
    @IBInspectable var rotation: CGFloat = 0
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initButton()
    }
    
    // MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        let realDiameterX = iconDiameter * rect.width
        let realDiameterY = iconDiameter * rect.height
        let centerRect = CGRect(x: (rect.width - realDiameterX) * 0.5,
                                y: (rect.height - realDiameterY) * 0.5,
                                width: realDiameterX,
                                height: realDiameterY)
        // Create path
        let path = UIBezierPath(ovalIn: centerRect)

        // Make cogs
        if numberOfCogs > 0 {
            var angle: CGFloat = rotation.degreesToRadians
            while angle < CGPoint.tau + rotation.degreesToRadians {
                let start = CGPoint(fromAngle: angle, magnitude: realDiameterX * 0.5)
                let end = CGPoint(fromAngle: angle, magnitude: realDiameterX * 0.5 + rect.width * cogLength)
                path.move(to: start + rect.center)
                path.addLine(to: end + rect.center)
                angle += CGPoint.tau / CGFloat(numberOfCogs)
            }
        }
        
        // Stroke path
        strokeColor.setStroke()
        path.lineWidth = strokeWeight
        path.lineCapStyle = .round
        path.stroke()
    }
    
    // MARK: - Private Functions
    
    private func initButton() {
        layer.cornerRadius = bounds.size.width.half
        clipsToBounds = true
        backgroundColor = UIColor.clear
        initEffectView()
        setNeedsDisplay()
    }
    
    private func initEffectView() {
        let effectBackground = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectBackground.frame = bounds
        effectBackground.layer.cornerRadius = frame.width.half
        effectBackground.layer.masksToBounds = true
        effectBackground.tag = 70
        addSubview(effectBackground)
        sendSubviewToBack(effectBackground)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.width.half)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4
        layer.shadowPath = shadowPath.cgPath
    }
    
}
