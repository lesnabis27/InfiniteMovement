//
//  OptionButton.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/29/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

@IBDesignable class OptionButton: UIButton {
    
    // MARK: - Interface
    
    @IBInspectable public var cornerRadius: CGFloat = 8 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundedRectLayer()
    }
    
    // MARK: - Appearance
    
    private var roundedRectLayer: CAShapeLayer?
    
    private func layoutRoundedRectLayer() {
        if let existingLayer = roundedRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = backgroundColor!.cgColor
        
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.roundedRectLayer = shapeLayer
    }
    
}
