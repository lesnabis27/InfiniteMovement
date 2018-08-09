//
//  ViewController.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/8/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/30.0, repeats: true, block: update)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    @objc func update(_: Timer) {
        // Refresh view
    }

}

