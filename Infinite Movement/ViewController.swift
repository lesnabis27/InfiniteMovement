//
//  ViewController.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/8/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DraggableViewDelegate, TappableViewDelegate {

    var timer: Timer!
    var fps = FPSMonitor()
    var attractors = [Attractor]()
    var movers = [Mover]()
    
    @IBOutlet weak var canvas: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.delegate = self
        initMovers(in: canvas)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/30.0, repeats: true, block: update)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    // Loop each frame
    @objc func update(_: Timer) {
        // Clear all sublayers
        canvas.layer.sublayers = nil
        // Update and draw movers
        updateMovers()
        drawMovers()
        // Calculate frames per second, for debug
        fps.update()
        //print(fps.averageString)
    }
    
    // MARK: - TappableViewDelegate
    
    // Add an attractor to the array and add its view to this view
    func tapGestureDidEnd(_ tapGesture: UITapGestureRecognizer, location: CGPoint) {
        attractors.append(Attractor(location))
        view.addSubview(attractors.last!.view)
        //UIView.transition(with: attractors.last!.view, duration: 0.3, options: .curveEaseOut, animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
    }
    
    // MARK: - Movers
    
    func initMovers(in view: UIView) {
        for _ in (0..<50) {
            movers.append(Mover(in: canvas))
        }
    }
    
    func updateMovers() {
        for mover in movers {
            mover.seek(movers: movers)
            mover.seek(attractors: attractors)
            mover.averageAcceleration(movers.count - attractors.count - 1)
            mover.applyAcceleration()
            mover.wrap(in: canvas)
            mover.applyVelocity()
        }
    }
    
    func drawMovers() {
        for mover in movers {
            mover.draw(in: canvas)
        }
    }
    
}

