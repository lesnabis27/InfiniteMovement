//
//  DraggableView.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/15/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

class DraggableView: UIView {

    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    weak var delegate: DraggableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGestureRecognition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpGestureRecognition()
    }
    
    // Make the view draggable
    func setUpGestureRecognition() {
        isUserInteractionEnabled = true
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.addGestureRecognizer(panGestureRecognizer!)
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: superview)
        let velocityInView = panGesture.velocity(in: superview)
        
        switch panGesture.state {
        case .began:
            originalPosition = self.center
            delegate?.panGestureDidBegin?(panGesture, originalCener: originalPosition!)
            break
        case .changed:
            self.frame.origin = CGPoint(
                x: originalPosition!.x - self.bounds.midX + translation.x,
                y: originalPosition!.y - self.bounds.midY + translation.y
            )
            delegate?.panGestureDidChange?(panGesture, originalCenter: originalPosition!, translation: translation, velocityInView: velocityInView)
            break
        case .ended:
            delegate?.panGestureDidEnd?(panGesture, originalCenter: originalPosition!, translation: translation, velocityInView: velocityInView)
            break
        default:
            break
        }
    }

}
