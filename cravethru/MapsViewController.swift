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
        switch recognizer.state {
        case .ended:
            animate_transition_if_needed(state: next_state, duration: 0.9)
        default:
            break
        }
    }

    @objc
    func handle_card_pan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start Transition
            start_interactive_transition(state: next_state, duration: 0.9)
            break
        case.changed:
            // Update Transition
            let translation = recognizer.translation(in: self.card_view_controller.handle_view)
            var fraction_complete = translation.y / card_height
            fraction_complete = card_visible ? fraction_complete : -fraction_complete
            
            update_interactive_transition(fraction_completed: fraction_complete) // Changing 0 to something else later
            break
        case .ended:
            // Continue Transition
            continue_interactive_transition()
            break
        default:
            break
        }
    }
    
    func animate_transition_if_needed(state: CardState, duration: TimeInterval) {
        if running_animations.isEmpty {
            // Animate transition
            let frame_animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.card_view_controller.view.frame.origin.y = self.view.frame.height - self.card_height
                case .collapsed:
                    self.card_view_controller.view.frame.origin.y = self.view.frame.height - self.card_handle_area_height
                }
            }
            
            // Card Visible flag when animation completed
            frame_animator.addCompletion { (_) in
                self.card_visible = !self.card_visible
                self.running_animations.removeAll()
            }
            
            frame_animator.startAnimation()
            running_animations.append(frame_animator)
            
            let corner_radius_animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case.expanded:
                    self.card_view_controller.view.layer.cornerRadius = 12
                case .collapsed:
                    self.card_view_controller.view.layer.cornerRadius = 0
                }
            }
            
            corner_radius_animator.startAnimation()
            running_animations.append(corner_radius_animator)
            
            let blur_animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visual_effect_view.effect = UIBlurEffect(style: .dark) // There's also a .light
                case .collapsed:
                    self.visual_effect_view.effect = nil
                }
            }
            
            blur_animator.startAnimation()
            running_animations.append(blur_animator)
        }
    }
    
    func start_interactive_transition(state: CardState, duration: TimeInterval) {
        if running_animations.isEmpty {
            // Run Animations
            animate_transition_if_needed(state: state, duration: duration)
        }
        
        for animator in running_animations {
            animator.pauseAnimation()           // Set speed to 0, makes it interactive
            animation_progress_when_interrupted = animator.fractionComplete
        }
    }
    
    func update_interactive_transition(fraction_completed: CGFloat) {
        for animator in running_animations {
            animator.fractionComplete = fraction_completed + animation_progress_when_interrupted
        }
    }
    
    func continue_interactive_transition() {
        for animator in running_animations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)    // Uses remaining time in animation (Which is 0.9 up above in 'duration' from start_interactive_transition()
        }
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
