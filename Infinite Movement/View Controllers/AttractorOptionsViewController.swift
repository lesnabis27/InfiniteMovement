//
//  AttractorOptionsViewController.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/29/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

class AttractorOptionsViewController: UIViewController {
    
    // This will be sent the calling attractor to display and manipulate its data
    weak var attractor: Attractor?
    
    @IBOutlet var optionsView: AttractorOptionsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsView!.controller = self
        if let _ = attractor {
            optionsView.massTextField.text = "\(attractor!.mass)"
        }
    }
    
    func reverseAttractor() {
        attractor?.mass *= -1
        attractor?.view.viewWithTag(70)?.removeFromSuperview()
        if attractor!.mass < 0 {
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .light)))
        } else {
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .dark)))
        }
        optionsView.massTextField.text = "\(attractor!.mass)"
    }
    
    func decrementMass() {
        let startedPositive = attractor!.mass >= 0
        attractor!.mass -= 1.0
        if startedPositive && attractor!.mass < 0 {
            attractor?.view.viewWithTag(70)?.removeFromSuperview()
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .light)))
        }
        optionsView.massTextField.text = "\(attractor!.mass)"
    }
    
    func incrementMass() {
        let startedNegative = attractor!.mass < 0
        attractor!.mass += 1.0
        if startedNegative && attractor!.mass < 0 {
            attractor?.view.viewWithTag(70)?.removeFromSuperview()
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .dark)))
        }
        optionsView.massTextField.text = "\(attractor!.mass)"
    }
    
    func removeAttractor() {
        attractor!.remove()
        // Dismiss pop over
        dismiss(animated: true, completion: nil)
    }

}
