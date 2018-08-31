//
//  AttractorOptionsView.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/31/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

class AttractorOptionsView: UIView {

    // View controller
    weak var controller: AttractorOptionsViewController?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var massTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func reverseButtonPressed(_ sender: UIButton) {
        controller!.reverseAttractor()
    }
    
    @IBAction func decrementMassButtonPressed(_ sender: UIButton) {
        controller!.decrementMass()
    }
    
    @IBAction func incrementMassButtonPressed(_ sender: UIButton) {
        controller!.incrementMass()
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        controller!.removeAttractor()
    }
    
}
