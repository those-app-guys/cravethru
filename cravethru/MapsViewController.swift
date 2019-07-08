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
    let card_handle_area_height: CGFloat = 65
    
    var card_visible = false
    var next_state: CardState {
        return card_visible ? .collapsed : .expanded
    }
    
    // Array of animations
    var running_animations = [UIViewPropertyAnimator]()
    // Store progress of animations when it's interrupted
    var animation_progress_when_interrupted: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup_card()
    }
    
    func setup_card() {
        visual_effect_view = UIVisualEffectView()
        visual_effect_view.frame = self.view.frame
        self.view.addSubview(visual_effect_view)
        
        // Load Card View Controller
        card_view_controller = MapsCardViewController(nibName: "MapsCard", bundle: nil)
        self.addChild(card_view_controller)
        self.view.addSubview(card_view_controller.view)
        
        card_view_controller.view.frame = CGRect(x: 0, y: self.view.frame.height - card_handle_area_height, width: self.view.bounds.width, height: card_height)
        
        card_view_controller.view.clipsToBounds = true
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
