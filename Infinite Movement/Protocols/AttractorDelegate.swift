//
//  AttractorDelegate.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/20/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Foundation

protocol AttractorDelegate {
    func removeFromArray(_ attractor: Attractor)
    func presentAttractorOptions(sender: Attractor)
}
