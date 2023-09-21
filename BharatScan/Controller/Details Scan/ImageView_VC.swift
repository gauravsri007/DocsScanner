//
//  ImageView_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 10/08/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit

class ImageView_VC: UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var lbl_folderName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var folderName  = String()
    var strImageUrl = String()
    var selectedImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedImage = ShareManager.sharedInstance.getImageFromDocumentDirectory(file_name: strImageUrl)
        setScrollView()
        
    }
    
    override func viewWillLayoutSubviews() {
        self.lbl_folderName.text = folderName
    }
    
    func setScrollView(){
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        var xPostion: CGFloat = 0
        
        //        for i in 0..<Int(pageCount) {
        //---------* Set Image *--------
        let view = UIView(frame: CGRect(x: xPostion, y: 0, width: screenWidth, height: screenHeight))
        xPostion += screenWidth
        let imageView = ImageViewZoom(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        imageView.setup()
        imageView.imageScrollViewDelegate = self
        imageView.imageContentMode = .aspectFit
        imageView.initialOffset = .center
        imageView.display(image: selectedImage!)
        view.addSubview(imageView)
        scrollView.addSubview(view)
        //        }
        
        self.view.addSubview(scrollView)
    }
    


    @IBAction func back_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:-
extension ImageView_VC: ImageViewZoomDelegate {
    func imageScrollViewDidChangeOrientation(imageViewZoom: ImageViewZoom) {
//        print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
 
}
