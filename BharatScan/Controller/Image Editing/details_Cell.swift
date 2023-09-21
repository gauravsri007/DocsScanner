//
//  details_Cell.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 08/08/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import WebKit


class details_Cell: UICollectionViewCell {
    
    @IBOutlet weak var webView_pdf: WKWebView!
    
    @IBOutlet weak var lbl_imageName: UILabel!
    @IBOutlet weak var img_docs: UIImageView!{
        didSet{
            img_docs.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var view_bg: UIView!
}
