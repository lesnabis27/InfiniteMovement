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
    
    @IBOutlet weak var canvas: CanvasView!
    @IBOutlet weak var fpsOverlayView: OverlayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fpsOverlayView.delegate = self
        canvas.delegate = self
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
        // Clear all sublayers
        canvas.layer.sublayers = nil
        // Create path
        let path = UIBezierPath()
        let randomInWidth = CGFloat.random(in: 0..<canvas.bounds.width)
        let randomInHeight = CGFloat.random(in: 0..<canvas.bounds.height)
        path.move(to: CGPoint(x: canvas.bounds.width * 0.5, y: canvas.bounds.height * 0.5))
        path.addLine(to: CGPoint(x: randomInWidth, y: randomInHeight))
        // Create shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        // Add shape layer to canvas
        canvas.layer.addSublayer(shapeLayer)
        // Calculate frames per second, for debug
        fps.update()
    }
    
    // MARK: - TappableViewDelegate
    
    func tapGestureDidEnd(_ tapGesture: UITapGestureRecognizer, location: CGPoint) {
        attractors.append(Attractor(location))
        view.addSubview(attractors.last!.view)
    }
    
}

