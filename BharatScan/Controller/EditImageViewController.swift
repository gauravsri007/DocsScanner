//
//  EditImageViewController.swift
//  WeScanSampleProject
//
//  Created by Chawatvish Worrapoj on 8/1/2020
//  Copyright © 2020 WeTransfer. All rights reserved.
//

import UIKit
import WeScan

final class EditImageViewController: UIViewController {
    
    var captureImage: UIImage!
    var quad: Quadrilateral?
    var controller: WeScan.EditImageViewController!
    @IBOutlet weak var img_temp: UIImageView!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_bottom: UIView!
    
    @IBOutlet weak var img_capturedPhoto: UIImageView!
    @IBOutlet weak var view_alert: UIView!
    
    @IBOutlet weak var lbl_imgName: UILabel!
    @IBOutlet weak var lbl_imgDate: UILabel!
    var isfromHomeScreen : Bool = false
    var isAlertShow : Bool = false

    var isfromHomeDetailsScreen : Bool = false
    var fileUrl : URL!
    var fileName = String()
    var imgDocs = UIImage()
    var dic : [String: Any] = [:]
    var fourDigitNumber: String {
     var result = ""
     repeat {
         // Create a string with a random number 0...9999
         result = String(format:"%04d", arc4random_uniform(10000) )
     } while Set<Character>(result).count < 4
     return result
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupView()
        
        self.view_bg.isHidden = false
        self.img_capturedPhoto.image = imgDocs
    }
    
    override func viewWillLayoutSubviews() {
         self.setupAlertView()
     }
    
    
    func setupAlertView() {
        self.view_bg.isHidden = true
        self.view_alert.layer.cornerRadius = 10
        self.view_bottom.roundCorners_AtBottom(radius: 10)
        
    }
    


    
    @IBAction func cropTapped(_ sender: UIButton!) {
        controller.cropImage()
    }
    
    @IBAction func close_Alert(_ sender: Any) {
    }
    
    @IBAction func download_clicked(_ sender: Any) {
    }
    
    @IBAction func share_clicked(_ sender: Any) {
    }
    
}

extension EditImageViewController: EditImageViewDelegate {
    func cropped(image: UIImage) {
//        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReviewImageView") as? ReviewImageViewController else { return }
//        controller.modalPresentationStyle = .fullScreen
//        controller.image = image
//        navigationController?.pushViewController(controller, animated: false)
    }
}
