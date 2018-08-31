//
//  OptionTextField.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/29/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

class OptionTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Appearance
    
    private func initAppearance() {
        textAlignment = .center
        textColor = UIColor.black
        font = UIFont.systemFont(ofSize: 15, weight: .heavy)
    }

}
