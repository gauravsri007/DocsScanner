//
//  ImagesCell.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 06/09/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

protocol RemoveImageDelegate {
    func removeClicked(cell : ImagesCell)
}

import UIKit

class ImagesCell: UICollectionViewCell {
    
    @IBOutlet weak var img_scannedItem: UIImageView!{
        didSet{
//            img_scannedItem.layer.borderWidth = 5
//            img_scannedItem.layer.borderColor = UIColor.yellow.cgColor
            img_scannedItem.contentMode = .scaleAspectFit
        }
    }
    
    var delegate : RemoveImageDelegate?
    
    @IBAction func close_Action(_ sender: Any) {
        delegate?.removeClicked(cell: self)
    }
}
