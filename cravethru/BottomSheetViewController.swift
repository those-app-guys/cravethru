//
//  BottomSheetViewController.swift
//  cravethru
//
//  Created by Raymond Esteybar on 7/17/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.pan_gesture(recognizer:)))
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            let frame = self.view.frame
            let y_component = UIScreen.main.bounds.height - 200
            self.view.frame = CGRect(x: 0, y: y_component, width: frame.width, height: frame.height)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepare_background_view()
    }

    func prepare_background_view() {
        let blur_effect = UIBlurEffect.init(style: .dark)
        let visual_effect = UIVisualEffectView.init(effect: blur_effect)
        let blurred_view = UIVisualEffectView.init(effect: blur_effect)
        blurred_view.contentView.addSubview(visual_effect)
        
        visual_effect.frame = UIScreen.main.bounds
        blurred_view.frame = UIScreen.main.bounds
        
        view.insertSubview(blurred_view, at: 0)
    }
    
    @objc func pan_gesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
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
