//
//  VisionCamera_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 14/09/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import  Vision
import VisionKit

@available(iOS 14.0, *)
class VisionCamera_VC: UIViewController {
    
    var isSave : Bool  = false
    var clicked_index : Int!
    var isAddMoreDocs : Bool = false
    var arr_images_vision: [ UIImage] = []
    var isAddmoreImageFrom_ImageEditing : Bool = false
    var isCameraCancel : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isSave{
            print("image count",self.arr_images_vision.count)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditing_VC") as! ImageEditing_VC
            vc.modalPresentationStyle = .fullScreen
//            vc.imgDocs = results.croppedScan.image
            vc.clicked_index = clicked_index
            vc.arr_images = self.arr_images_vision
            vc.isAddMoreDocs = self.isAddMoreDocs
//            self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else{
            
            if isCameraCancel{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyScans_VC") as! MyScans_VC
                vc.modalPresentationStyle = .fullScreen
                vc.shouldAddImage = false
                //        self.navigationController?.pushViewController(vc, animated: true)
//                self.present(vc, animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)

            }
            else{
                let vc = VNDocumentCameraViewController()
                vc.delegate = self
                present(vc, animated: true)
            }
        }
    }
    
}




@available(iOS 14.0, *)

extension VisionCamera_VC : VNDocumentCameraViewControllerDelegate{
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Found \(scan.pageCount)")
        
        if !isAddMoreDocs && !isAddmoreImageFrom_ImageEditing{
            self.arr_images_vision = []
        }
        for i in 0 ..< scan.pageCount {
            let image = scan.imageOfPage(at: i)
            self.arr_images_vision.append(image)
        }
        isSave = true
        self.dismiss(animated: true, completion: nil)
        
    }
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        print("cancel clicked")
        isCameraCancel = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
