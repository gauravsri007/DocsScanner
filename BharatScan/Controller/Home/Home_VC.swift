//
//  Home_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 19/07/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import AVFoundation
//import Floaty


@available(iOS 14.0, *)
class Home_VC: UIViewController{
    
    @IBOutlet weak var colView_Folders: UICollectionView!
    @IBOutlet weak var btn_profileIcon: UIButton!
    @IBOutlet weak var lbl_userContact: UILabel!
    @IBOutlet weak var btn_downMenu: UIButton!
    @IBOutlet weak var view_helping: UIView!
    @IBOutlet weak var view_bg_sideMenu: UIView!
    @IBOutlet weak var view_sideMenu: UIView!
    @IBOutlet weak var lbl_userName: UILabel!
    var arr_folder : [String] = []
    @IBOutlet weak var view_folder_bg: UIView!
    
    @IBOutlet weak var view_folder: UIView!
//    var floaty = Floaty()
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        static let mediaTypes = ["public.image", "public.movie"]
        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
//    func layoutFAB() {
//      let item = FloatyItem()
//      item.hasShadow = false
//      item.buttonColor = UIColor.blue
//      item.circleShadowColor = UIColor.red
//      item.titleShadowColor = UIColor.blue
//      item.titleLabelPosition = .right
//      item.title = "titlePosition right"
//      item.handler = { item in
//
//      }
//      floaty.hasShadow = false
//      floaty.addItem(title: "I got a title")
//      floaty.addItem("I got a icon", icon: UIImage(named: "icShare"))
//      floaty.addItem("I got a handler", icon: UIImage(named: "icMap")) { item in
//        let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//      }
//      floaty.addItem(item: item)
//        print(self.view.frame.width - floaty.frame.width)
//      floaty.paddingX = self.view.frame.width/2 - floaty.frame.width / 2
//      floaty.fabDelegate = self
//
//      self.view.addSubview(floaty)
//
//    }
    
    @IBAction func downMenuClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Camera_VC") as! Camera_VC
        vc.modalPresentationStyle = .fullScreen
//        vc.isfromHomeScreen = true
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        layoutFAB()

        arr_folder = ["1","2"]
    }
 
    
    override func viewWillLayoutSubviews() {
        self.setUI_SideMenu()
        
        self.view_folder_bg.isHidden = true

        view_bg_sideMenu.isHidden = true
        view_sideMenu.isHidden = true
        view_helping.isHidden = true
        
        btn_downMenu.layer.cornerRadius = btn_downMenu.frame.width / 2
        btn_downMenu.addShadow(color: UIColor.lightGray)

        btn_profileIcon.layer.cornerRadius = btn_downMenu.frame.width / 2
        btn_profileIcon.layer.borderWidth = 6
        btn_profileIcon.layer.borderColor = UIColor.white.cgColor


    }
    
    func setUI_SideMenu(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view_helping.addGestureRecognizer(tap)
    }
    
    @IBAction func clickedSideMenu(_ sender: Any) {

        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                
                self.view.layoutIfNeeded()

                self.view_bg_sideMenu.frame.origin.x = 0
                self.view_sideMenu.isHidden = false
                self.view_bg_sideMenu.isHidden = false
                self.view_helping.isHidden = false

                
        }) { (completed) in
        }
        
    }
    
    @IBAction func close_folder_view(_ sender: Any) {
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        view_sideMenu.isHidden = true
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                //                self.view_sideMenu.frame.origin.x = -screenWidth - 80
                self.view_bg_sideMenu.frame.origin.x = -screenWidth
                self.view_helping.isHidden = true
                
        }) { (completed) in
            self.view_bg_sideMenu.isHidden = true
        }
    }
    
    @IBAction func rename_Action(_ sender: Any) {
    }
    
    @IBAction func addMoreScan_Action(_ sender: Any) {
        
       }
    @IBAction func share_Action(_ sender: Any) {
          }
    @IBAction func delete_Action(_ sender: Any) {
        
             }
    @IBAction func download_Action(_ sender: Any) {
        
                }

    
}


@available(iOS 14.0, *)
extension Home_VC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.size.width / 2)
        return CGSize(width: (collectionView.frame.size.width / 2), height: 318) //add your height here
   
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_folder.count
    }
    
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home_Card_Cell", for: indexPath as IndexPath) as! Home_Card_Cell

    cell.view_bg.layer.cornerRadius = 8
    cell.btn_threeDot.imageView?.contentMode = .scaleAspectFit
    cell.btn_threeDot.tag = indexPath.item
    cell.btn_threeDot.addTarget(self, action: #selector(threeDotClicked), for: .touchUpInside)
        //
        //          if indexPath.item == selectedIndexPath
        //          {
        //              category_ImgView.image = categorySelectedArray[selectedIndexPath]
        //
        //          }
        //          else{
//        cell.img_tab.image = arr_folder[indexPath.item]
        //          }
                  return cell
     
  }
    
    @objc func threeDotClicked(_ sender : UIButton){
        print("threeDotClicked",sender.tag)
        
//        toggle_threeDot = !toggle_threeDot
//        if toggle_threeDot{
//            self.view_bg.isHidden = false
//        }
//        else{
//            self.view_bg.isHidden = true
//        }
    }
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.goTOCollections_Details()
    }
    
    func goTOCollections_Details(){
        print("Method called")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Details_VC") as! Details_VC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
                
    }

}



