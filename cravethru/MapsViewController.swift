//
//  MapsViewController.swift
//  cravethru
//
//  Created by Raymond Esteybar on 7/7/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController {

    enum CardState {
        case expanded
        case collapsed
    }
    
    var card_view_controller: MapsCardViewController!   // Reference
    var visual_effect_view: UIVisualEffectView!         // Blur Effect, animate intensity of blur
    
    let card_height: CGFloat = 600
    let card_handle_area_height: CGFloat = 200          // How much bottom sheet shows @ start
    
    var card_visible = false                            // true = Expanded, false = collapsed
    var next_state: CardState {
        return card_visible ? .collapsed : .expanded
    }
    
    var running_animations = [UIViewPropertyAnimator]()     // Array of animations
    var animation_progress_when_interrupted: CGFloat = 0    // Store progress of animations when it's interrupted
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup_card()
    }
    
    func setup_card() {
        // Blur Effect
        visual_effect_view = UIVisualEffectView()   // Init blur effect
        visual_effect_view.frame = self.view.frame  // Have effect be the same size as the view's frame
        self.view.addSubview(visual_effect_view)
        
        // Load Maps Card View Controller
        card_view_controller = MapsCardViewController(nibName: "MapsCard", bundle: nil) // Initalizing; Refers to: MapsCard.xib
        self.addChild(card_view_controller)                                             // Allows it to be in the same screen as the Maps View; Child to Main View
        self.view.addSubview(card_view_controller.view)                                 // Shows the Maps Card View
        
        let y = self.view.frame.height - card_handle_area_height    // Takes the Maps View Height (Entire Screen)
        card_view_controller.view.frame = CGRect(x: 0, y: y, width: self.view.bounds.width, height: card_height)
        
        card_view_controller.view.clipsToBounds = true // Getting correct display of corner radius
        
        // Gestures of Card
        let tap_gesture_recognizer = UITapGestureRecognizer(target: self, action: #selector(MapsViewController.handle_card_tap(recognizer:)))
        let pan_gesture_recognizer = UIPanGestureRecognizer(target: self, action: #selector(MapsViewController.handle_card_pan(recognizer:)))
        
        card_view_controller.handle_view.addGestureRecognizer(tap_gesture_recognizer)
        card_view_controller.handle_view.addGestureRecognizer(pan_gesture_recognizer)
    }
    
    @objc
    func handle_card_tap(recognizer: UITapGestureRecognizer) {
        
    }

    @objc
    func handle_card_pan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start Transition
            break
        case.changed:
            // Update Transition
            break
        case .ended:
            // Continue Transition
            break
        default:
            break
        }
    }
    
    func start_interactive_transition(state: CardState, duration: TimeInterval) {
        
    }
    
    func update_interactive_transition(fraction_completed: CGFloat) {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
