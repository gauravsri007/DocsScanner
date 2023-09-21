//
//  Cropper_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 29/09/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit

class Cropper_VC: UIViewController {
    @IBOutlet weak var view_container: UIView!
    var imageCropView: ImageCropView?
    var croppable_image = UIImage()
    
    @IBOutlet weak var img_result: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setNavigationBar(){
        let navigationbarapperarance = UINavigationBarAppearance()
        navigationbarapperarance.configureWithOpaqueBackground()
        navigationbarapperarance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationbarapperarance.backgroundColor = THEME_COLOR_NAVIGATION
        navigationbarapperarance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = navigationbarapperarance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationbarapperarance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setNavigationBar()
        self.title = "Crop Image"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initialiseCropView()
    }
    
    func initialiseCropView() {
        guard let image = UIImage(named: "natureNew") else {return}
        deInitialiseCropView()
        imageCropView = ImageCropView(frame: CGRect(x: 0, y: 0, width:
                                    self.view_container.frame.size.width,
                                    height: self.view_container.frame.size.height))
        view_container.addSubview(imageCropView!)
        imageCropView?.image = croppable_image
//        self.img_result!.image = croppable_image
    }
    
    func deInitialiseCropView() {
        imageCropView?.removeFromSuperview()
        imageCropView = nil
    }
    
    
    @IBAction func image_ratoation(_ sender: Any) {
        self.imageCropView!.transform = CGAffineTransform(rotationAngle: (90.0))
    }
    
    
    @IBAction func back_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func croppedAction(_ sender: Any) {
        imageCropView?.crop { (error, image) in
            if (error as NSError?) != nil {
                print("Handle error here")
            }
            self.imageCropView!.image = image
            let nc = NotificationCenter.default
            //* Post Notification for Featured List
            var dic_image : [String: Any] = [:]
            dic_image["cropped_image"] = image
            let name = Notification.Name("CroppedImage")
            nc.post(name: name, object: self, userInfo: dic_image)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}



