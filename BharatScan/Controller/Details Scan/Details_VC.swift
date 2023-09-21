//
//  Details_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 01/08/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import WebKit
//import Floaty

@available(iOS 14.0, *)
class Details_VC: UIViewController {

    @IBOutlet weak var btn_Sharing: UIButton!
    @IBOutlet weak var lbl_FilderName: UILabel!
    @IBOutlet weak var colView_details: UICollectionView!
    var arr_folder : [String] = []
    var clicked_index : Int!
//    var floaty = Floaty()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lbl_FilderName.text = arr_folder[0]
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillLayoutSubviews() {
//        layoutFAB()
    }
    
    @IBAction func sharing_Action(_ sender: Any) {
        
        
    }
    
    
    @IBAction func scan_docs(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VisionCamera_VC") as! VisionCamera_VC
        vc.modalPresentationStyle = .fullScreen
        //        vc.isfromHomeScreen = true
        vc.clicked_index = clicked_index
        vc.isAddMoreDocs = true
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func back_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goTOCollections_Details(){
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Camera_VC") as! Camera_VC
//        vc.modalPresentationStyle = .fullScreen
//        vc.isfromHomeDetailsScreen = true
//        self.present(vc, animated: true, completion: nil)

    }
}


@available(iOS 14.0, *)
extension Details_VC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.size.width / 2)
        return CGSize(width: ((collectionView.frame.size.width / 2)-2), height: screenHeight * 30/100) //add your height here
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_folder.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "details_Cell", for: indexPath as IndexPath) as! details_Cell
        
        let filename = arr_folder[indexPath.item]
        var str = String()
        if indexPath.item < 9{
            str = "0\(indexPath.item + 1)"
        }
        else{
            str = "\(indexPath.item + 1)"
        }
        cell.lbl_imageName.text = str
        cell.img_docs.image = ShareManager.sharedInstance.getImageFromDocumentDirectory(file_name: filename)
        cell.view_bg.layer.cornerRadius = 10
//        print("docURL",docURL)
//
//        let urlRequest = URLRequest(url: docURL)
//        cell.webView_pdf.load(urlRequest)
        //        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let strImageUrl = arr_folder[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageView_VC") as! ImageView_VC
        vc.strImageUrl = strImageUrl
        vc.folderName = self.arr_folder[indexPath.item]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}


