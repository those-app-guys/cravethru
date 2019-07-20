//
//  BottomSheetViewController.swift
//  cravethru
//
//  Created by Raymond Esteybar on 7/17/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var search_bar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.search_bar.delegate = self // Allows for use of delegate methods
        search_bar.sizeToFit()
        search_bar.placeholder = "Search for places"
        
        // Gesture for moving Bottom Sheet Up & Down
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
    
    @IBAction func bottom_sheet_pan_gesture(_ sender: Any) {
        // Dismisses Keyboard
        view.endEditing(true)
    }
    @objc func pan_gesture(recognizer: UIPanGestureRecognizer) {
        // Controls movement of bottom sheet
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        // Dismisses Keyboard
        view.endEditing(true)
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

extension BottomSheetViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText.isEmpty)
//        if searchText == "" {
//            print("Text = Empty | Tapped on Search Bar")
//        } else {
//            print("Nothing happening")
//        }
    }
    
    // Used for displaying "Keyboard" & Moving Bottom Sheet to top (e.g. Apple Maps)
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Animates moving Bottom Sheet to front
        UIView.animate(withDuration: 0.3) {
            let frame = self.view.frame
            let nav_bar_height = UIApplication.shared.statusBarFrame.size.height
            let bottom_sheet_height = frame.height
            let maps_view_height = UIScreen.main.bounds.height
            
            let y = maps_view_height - bottom_sheet_height + nav_bar_height
            self.view.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height)
        }
        
        return true    // True = Display Keyboard, False = Don't display
    }
}
