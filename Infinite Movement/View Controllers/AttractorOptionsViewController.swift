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
            optionsView.massTextField.text = String(format: "%.0f", attractor!.mass)
        }
    }
    
    // Invert the mass, causing the attractor to repel or attract
    func reverseAttractor() {
        attractor?.mass *= -1
        // Change view appearance
        attractor?.view.viewWithTag(70)?.removeFromSuperview()
        if attractor!.mass < 0 {
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .light)))
        } else {
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .dark)))
        }
        // Display the correct mass
        optionsView.massTextField.text = String(format: "%.0f", attractor!.mass)
    }
    
    // Decrease mass by one
    func decrementMass() {
        let startedPositive = attractor!.mass >= 0
        attractor!.mass -= calculateIncrement(value: attractor!.mass)
        // Change view appearance
        if startedPositive && attractor!.mass < 0 {
            attractor?.view.viewWithTag(70)?.removeFromSuperview()
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .light)))
        }
        optionsView.massTextField.text = String(format: "%.0f", attractor!.mass)
    }
    
    // Increase mass by one
    func incrementMass() {
        let startedNegative = attractor!.mass < 0
        attractor!.mass += calculateIncrement(value: attractor!.mass)
        // Change view appearance
        if startedNegative && attractor!.mass < 0 {
            attractor?.view.viewWithTag(70)?.removeFromSuperview()
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .dark)))
        }
        optionsView.massTextField.text = String(format: "%.0f", attractor!.mass)
    }
    
    func enterMass(value: CGFloat) {
        attractor!.mass = value
        optionsView.massTextField.text = String(format: "%.0f", attractor!.mass)
        // Change view appearance
        attractor?.view.viewWithTag(70)?.removeFromSuperview()
        if attractor!.mass < 0 {
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .light)))
        } else {
            attractor?.view.initEffectView(effectBackground: UIVisualEffectView(effect: UIBlurEffect(style: .dark)))
        }
    }
    
    // Get rid of the attractor
    func removeAttractor() {
        attractor!.remove()
        // Dismiss pop over
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    func calculateIncrement(value: CGFloat) -> CGFloat {
        let magnitude = abs(value)
        if magnitude < 100 {
            return 1
        } else if magnitude < 1000 {
            return 10
        } else if magnitude < 10000 {
            return 100
        }
        return 1000
    }

}
