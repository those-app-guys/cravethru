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
    @IBOutlet weak var table_view: UITableView!

    var users = ["Sujang", "Ray", "Joe", "RJ", "Jose", "Raju", "Dalanna", "Erick", "Francel"]
    
    var initial_section: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search_bar.delegate = self // Allows for use of delegate methods
        search_bar.sizeToFit()
        search_bar.placeholder = "Search for restaurants or areas"
        
        // tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
//        table_view.register(UINib(nibName: "BottomSheetTableViewCell", bundle: nil), forCellReuseIdentifier: "BottomSheetTableViewCell")
        setup_component()
        
        // Makes corners of bottom sheet a little more rounded
        view.layer.cornerRadius = 15;
        view.layer.masksToBounds = true;    // Ensures rounded corners
        
        // Gesture for moving Bottom Sheet Up & Down
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.pan_gesture(recognizer:)))
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            let frame = self.view.frame
            let y_component = UIScreen.main.bounds.height - 250
            self.view.frame = CGRect(x: 0, y: y_component, width: frame.width, height: frame.height)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepare_background_view()
    }
    
    func setup_component() {
        table_view.rowHeight = UITableView.automaticDimension
        table_view.estimatedRowHeight = 44
        table_view.register(UINib(nibName: "BottomSheetTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
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
    
    // Controls movement of bottom sheet
    @objc func pan_gesture(recognizer: UIPanGestureRecognizer) {
        let bot = UIScreen.main.bounds.height - 100
        
        // Movement of Bottom Sheet
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY + translation.y
        
        // Ensures bottom sheet does not go below the 'Bottom' section (Off screen below)
        if y <= bot {
            self.view.frame = CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height)
        }
        
        // Keep track of what section we started
        //  - Helps understand what direction we're moving to (CMD + F for "initial_section" to its uses)
        if recognizer.state == .began {
            self.initial_section = y
        }
        
        // Locate which section is belongs to
        // Checks if user let go of pan gesture
        let let_go_gesture = recognizer.state == .ended
        if  let_go_gesture {
            
            // Calculations for 'Top' Section
            let frame = self.view.frame
            let nav_bar_height = UIApplication.shared.statusBarFrame.size.height
            let bottom_sheet_height = frame.height
            let maps_view_height = UIScreen.main.bounds.height
            let move_down_extra: CGFloat = 50
            
            // Ex: iPhone X
            //  - Top    = 94.0
            //  - Mid    = 562.0
            //  - Bottom = 712.0 (Variable declaration found in beginning of function)
            let top = maps_view_height - bottom_sheet_height + nav_bar_height + move_down_extra
            let mid = UIScreen.main.bounds.height - 250
            
            //  - Section 1: Top    = 94 to 562
            //  - Section 2: Mid    = 562 to 712
            //  - Section 3: Bottom = 712
            let above_top = y <= top
            let between_top_mid = y > top && y < mid
            let between_mid_bot = y > mid && y < bot
            
            let mid_to_bottom = initial_section < y && between_mid_bot
            let bottom_to_mid = initial_section > y && between_mid_bot
            let mid_to_top = initial_section > y && between_top_mid
            let top_to_mid = initial_section < y && between_top_mid
            
            // Animating Bottom Sheet movement after letting go
            if mid_to_top || above_top {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: top, width: frame.width, height: frame.height)
                }
            } else if top_to_mid {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: mid, width: frame.width, height: frame.height)
                }
            } else if mid_to_bottom {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: bot, width: frame.width, height: frame.height)
                }
            } else if bottom_to_mid {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: mid, width: frame.width, height: frame.height)
                }
            }
        }
        
        // Shows animation of moving bottom sheet
        //  - (If commented out, it will move through ea. section really fast)
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
            let move_down_extra: CGFloat = 50
            
            let y = maps_view_height - bottom_sheet_height + nav_bar_height + move_down_extra
            self.view.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height)
        }
        
        return true    // True = Display Keyboard, False = Don't display
    }
}

extension BottomSheetViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BottomSheetTableViewCell
        
        cell.name_label.text = users[indexPath.row]
        
        return cell
    }
    
    
}
