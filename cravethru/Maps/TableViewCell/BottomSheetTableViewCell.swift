//
//  BottomSheetTableViewCell.swift
//  cravethru
//
//  Created by Raymond Esteybar on 7/27/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit

class BottomSheetTableViewCell: UITableViewCell {

    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var image_view: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        image_view.layer.cornerRadius = image_view.frame.height/2
        image_view.layer.borderWidth = 1
        image_view.layer.borderColor = UIColor.lightGray.cgColor
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
