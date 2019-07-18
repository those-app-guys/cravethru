//
//  MapsViewController.swift
//  cravethru
//
//  Created by Raymond Esteybar on 7/17/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        add_bottom_sheet_view()
    }
    
    func add_bottom_sheet_view() {
        // 1. Init Bottom Sheet View Controller
        let bottom_sheet_vc = BottomSheetViewController()
        
        // 2. Add Bottom Sheet View Controller as a child view
        self.addChild(bottom_sheet_vc)
        self.view.addSubview(bottom_sheet_vc.view)
        bottom_sheet_vc.didMove(toParent: self)
        
        // 3. Adjust bottom sheet frame & initial position
        let width = view.frame.width
        let height = view.frame.height
        bottom_sheet_vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }

    @IBAction func hello_button(_ sender: Any) {
        print("Hello")
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
