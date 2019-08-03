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
    
    var users = ["First Cell", "Ray", "Joe", "RJ", "Jose", "Raju", "Dalanna", "Erick", "Francel",
                 "Jose", "Raju", "Dalanna", "Erick", "Francel",
                 "Jose", "Raju", "Dalanna", "Erick", "Francel",
                 "Jose", "Raju", "Dalanna", "Erick", "Francel",
                 "Jose", "Raju", "Dalanna", "Erick", "Last Cell"
    ]
    
    let animation_duration = 0.3
    
    // we set a variable to hold the contentOffSet before scroll view scrolls
    var lastContentOffset: CGFloat = 0
    var is_at_top = false
    
    var recognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search_bar.delegate = self // Allows for use of delegate methods
        search_bar.sizeToFit()
        search_bar.placeholder = "Search for restaurants or areas"
        
        setup_table_view()
        
        // Makes corners of bottom sheet a little more rounded
        view.layer.cornerRadius = 15;
        view.layer.masksToBounds = true;    // Ensures rounded corners
        
        // Gesture for moving Bottom Sheet Up & Down
        recognizer = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.pan_gesture(recognizer:)))
        view.addGestureRecognizer(recognizer)
        
        // Blur Effect
        // 1
        view.backgroundColor = .clear
        // 2
        let blurEffect = UIBlurEffect(style: .light)
        // 3
        let blurView = UIVisualEffectView(effect: blurEffect)
        // 4
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
        
        
        //        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        //        // 2
        //        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        //        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        //        // 3
        //        vibrancyView.contentView.addSubview(bottom_sheet_view)
        //        // 4
        //        blurView.contentView.addSubview(vibrancyView)
        //
        //        NSLayoutConstraint.activate([
        //            vibrancyView.heightAnchor.constraint(equalTo: blurView.contentView.heightAnchor),
        //            vibrancyView.widthAnchor.constraint(equalTo: blurView.contentView.widthAnchor),
        //            vibrancyView.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
        //            vibrancyView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor)
        //            ])
        //
        //        NSLayoutConstraint.activate([
        //            view.centerXAnchor.constraint(equalTo: vibrancyView.contentView.centerXAnchor),
        //            view.centerYAnchor.constraint(equalTo: vibrancyView.contentView.centerYAnchor),
        //            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: animation_duration) {
            let frame = self.view.frame
            let y_component = frame.height - (frame.height * 0.3)
            self.view.frame = CGRect(x: 0, y: y_component, width: frame.width, height: frame.height)
            
            print("UIScreen.main.bounds.height = \(frame.height - frame.height/3) | frame.height = \(self.view.frame.height)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepare_background_view()
    }
    
    func setup_table_view() {
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
    
    func animate_to_section(section: CGFloat) {
        UIView.animate(withDuration: animation_duration) {
            self.view.frame = CGRect(x: 0, y: section, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    
    // Controls movement of bottom sheet
    @objc func pan_gesture(recognizer: UIPanGestureRecognizer) {
        // Calculations for 'Top' Section
        let frame = self.view.frame
        let nav_bar_height = UIApplication.shared.statusBarFrame.size.height
        let bottom_sheet_height = frame.height
        let move_down_extra: CGFloat = 50
        
        // Ex: iPhone X
        //  - Top    = 94.0
        //  - Mid    = 562.0
        //  - Bottom = 712.0 (Variable declaration found in beginning of function)
        let top = nav_bar_height + move_down_extra
        let mid = frame.height - (frame.height * 0.3)
        
        let calc = (bottom_sheet_height * 0.13)
        let bot = bottom_sheet_height - calc
        
        print("\(bottom_sheet_height) - \(calc) = \(bot)")
        
        // Movement of Bottom Sheet
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY + translation.y
        
        // Ensures bottom sheet does not go below the 'Bottom' & above 'Top' section (Off screen below & Blocks the Maps View on top)
        if y <= bot && y >= top - (top/3) {
            self.view.frame = CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height)
        }
        
        //  - Section 1: Top    = 94 to 562
        //  - Section 2: Mid    = 562 to 712
        //  - Section 3: Bottom = 712
        let above_top = y <= top
        let between_top_mid = y > top && y < mid
        let between_mid_bot = y > mid && y < bot
        
        // See what direction user is moving the Bottom Sheet
        let velocity = recognizer.velocity(in: self.view)
        
        let is_going_up = velocity.y < 0 ? true : false
        let mid_to_bottom = !is_going_up && between_mid_bot
        let bottom_to_mid = is_going_up && between_mid_bot
        let mid_to_top = is_going_up && between_top_mid
        let top_to_mid = !is_going_up && between_top_mid
        
        // Ensures when Bottom Sheet moves from "bottom" section
        // to display table view
        if y < bot {
            self.table_view.isHidden = false
        } else {
            self.table_view.isHidden = true
        }
        
        // Animates dim effect in Maps View
        if mid_to_top || above_top {
            NotificationCenter.default.post(name: Notification.Name("dim_on"), object: nil, userInfo: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name("dim_off"), object: nil, userInfo: nil)
        }
        
        // Locate which section is belongs to
        // Checks if user let go of pan gesture
        let let_go_gesture = recognizer.state == .ended
        if  let_go_gesture {
            is_at_top = false
            
            // Animating Bottom Sheet movement after letting go
            if mid_to_top || above_top {
                animate_to_section(section: top)
                is_at_top = true
            } else if top_to_mid || bottom_to_mid {
                animate_to_section(section: mid)
            } else if mid_to_bottom {
                UIView.animate(withDuration: animation_duration) {
                    self.view.frame = CGRect(x: 0, y: bot, width: frame.width, height: frame.height)
                    self.table_view.isHidden = true
                }
            } else {
                self.table_view.isHidden = true
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
        UIView.animate(withDuration: animation_duration) {
            let frame = self.view.frame
            let nav_bar_height = UIApplication.shared.statusBarFrame.size.height
            let bottom_sheet_height = frame.height
            let maps_view_height = UIScreen.main.bounds.height
            let move_down_extra: CGFloat = 50
            
            let y = maps_view_height - bottom_sheet_height + nav_bar_height + move_down_extra
            self.view.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height)
        }
        self.table_view.isHidden = false
        
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
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}
