//
//  CanvasView.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/8/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

// This is where the art is drawn to, and where user interaction with the simulation is recognized

class CanvasView: UIView {
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    weak var delegate: TappableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initGestureRecognition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initGestureRecognition()
    }
    
    func initGestureRecognition() {
        isUserInteractionEnabled = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        self.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc func tapGestureAction(_ tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: superview)
        
        switch tapGesture.state {
        case .ended:
            delegate?.tapGestureDidEnd?(tapGesture, location: location)
            break
        default:
            break
        }
    }

}
