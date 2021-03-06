//
//  ViewController.swift
//  Infinite Movement
//
//  Created by Sam Richardson on 8/8/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, DraggableViewDelegate, TappableViewDelegate, AttractorDelegate {

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
        // Set this view controller as the new attractor's delegate
        attractors.last!.delegate = self
    }
    
    // MARK: - AttractorDelegate
    
    // Remove an attractor from the array
    func removeFromArray(_ attractor: Attractor) {
        for index in 0..<attractors.count {
            if attractors[index] == attractor {
                attractors.remove(at: index)
                return
            }
        }
    }
    
    // Present the attractor options view controller
    func presentAttractorOptions(sender: Attractor) {
        // Get the view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AttractorOptions") as! AttractorOptionsViewController
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 250, height: 214)
        controller.attractor = sender
        // Configure the pop over
        let presentationController = controller.popoverPresentationController
        presentationController?.sourceView = sender.view
        presentationController?.sourceRect = sender.view.bounds
        presentationController?.delegate = self
        // Present the pop over
        self.present(controller, animated: true)
        UIView.animateTouchUp(target: sender.view)
    }
    
    // Popover presentation
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Movers
    
    func initMovers(in view: UIView) {
        for _ in (0..<50) {
            movers.append(Mover(in: canvas))
        }
    }
    
    // Apply physics and interactions to the movers
    func updateMovers() {
        for mover in movers {
            mover.seek(movers: movers)
            mover.seek(attractors: attractors)
            mover.averageAcceleration(movers.count - attractors.count - 1)
            mover.applyAcceleration()
            mover.wrap(in: canvas)
            //mover.bounce(in: canvas)
            mover.friction()
            mover.applyVelocity()
        }
    }
    
    func drawMovers() {
        for mover in movers {
            mover.drawLines(in: canvas)
        }
    }
    
}
