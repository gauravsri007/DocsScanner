//
//  Menu_Cell.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 06/08/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit

class Menu_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var menu_title: UILabel!
    
    @IBOutlet weak var img_menu: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
