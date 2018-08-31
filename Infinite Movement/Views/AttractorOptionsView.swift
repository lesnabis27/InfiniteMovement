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
    
    @IBAction func massTextFieldChanged(_ sender: UITextField) {
        guard let value = NumberFormatter().number(from: sender.text ?? "empty") else { return }
        controller!.enterMass(value: CGFloat(truncating: value))
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        controller!.removeAttractor()
    }
    
    // MARK: - Initializers
    
    override func awakeFromNib() {
        configureView()
    }
    
    // MARK: - Private Functions
    
    private func configureView() {
        massTextField.textAlignment = .center
    }
    
}
