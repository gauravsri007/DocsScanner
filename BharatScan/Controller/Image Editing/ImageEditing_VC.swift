//
//  ImageEditing_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 05/08/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
//import WeScan
import PDFKit

@available(iOS 14.0, *)
class ImageEditing_VC: UIViewController {
    
    var captureImage: UIImage!
//    var quad: Quadrilateral?
//    var controller: WeScan.EditImageViewController!
    var filename = String()
    
    @IBOutlet weak var colView_images: UICollectionView!
    @IBOutlet weak var img_temp: UIImageView!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_bottom: UIView!
    
    @IBOutlet weak var img_captured: UIImageView!
    @IBOutlet weak var img_capturedPhoto: UIImageView!
    @IBOutlet weak var view_alert: UIView!
    
    @IBOutlet weak var lbl_imgName: UILabel!
    @IBOutlet weak var lbl_imgDate: UILabel!
    var isfromHomeScreen : Bool = false
    var isAlertShow : Bool = false
    var isfromHomeDetailsScreen : Bool = false
    var fileUrl : URL!
    var currentDateNTime = String()
    var dic : [String: Any] = [:]
    var imgDocs = UIImage()

    var clicked_index : Int!
    var isAddMoreDocs : Bool = false
    var arr_images: [ UIImage] = []
    var arrfileName: [String] = []

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
        CreateFolderInDocumentDirectory()
        self.view_bg.isHidden = false
        self.img_capturedPhoto.image = self.arr_images[self.arr_images.count - 1]
        self.imgDocs = self.arr_images[self.arr_images.count - 1]
        self.img_captured.image = imgDocs
        
//        self.arr_images.appendsd(imgDocs)
        self.arrfileName = []
        for _ in self.arr_images{
           let filename = "Docs" + fourDigitNumber
            self.arrfileName.append(filename)
        }
        self.filename = arrfileName[0]
        self.colView_images.reloadData()

    }
    
    override func viewWillLayoutSubviews() {
        self.setupAlertView()
        self.view_bottom.backgroundColor = THEME_COLOR_NAVIGATION
    }
    
    
    func setNavigationBar(){
        let navigationbarapperarance = UINavigationBarAppearance()
        navigationbarapperarance.configureWithOpaqueBackground()
        navigationbarapperarance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationbarapperarance.backgroundColor = UIColor(red: 0.0/255.0, green: 181.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        navigationbarapperarance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = navigationbarapperarance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationbarapperarance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.title = "Scanned Documents"
    }
    
    
    func setupAlertView() {
        self.view_bg.isHidden = true
        self.view_alert.layer.cornerRadius = 10
        self.view_bottom.roundCorners_AtBottom(radius: 10)
//        let imageURL = generatePDF(image: imgDocs)
        var i : Int = 0
        for image in self.arr_images{
            _ = generateJPG(image: image,filename: self.arrfileName[i])
            i += 1
        }
            
    }
    
    var docURL : URL!

    func generateJPG(image : UIImage, filename : String)->URL{
        _ = image.jpegData(compressionQuality: 100)
        if let data = image.jpegData(compressionQuality: 0.8) {
            
            docURL = documentDirectory.appendingPathComponent(filename + ".jpeg")
            do{
                try data.write(to: docURL)
            }catch(_)
            {
            }
            
        }
        return docURL
    }
    
    func generatePDF(image : UIImage)->Data{
        
        let pdfDocument = PDFDocument()
        
//        for i in 0 ..< image.pageCount {
            if let image = image.resize(toWidth: 250){
                // Create a PDF page instance from your image
                let pdfPage = PDFPage(image: image)
                // Insert the PDF page into your document
                pdfDocument.insert(pdfPage!, at: 0)
            }
        // Get the raw data of your PDF document
        let data = pdfDocument.dataRepresentation()

        return data!
    }
    
    func createPDF(image: UIImage) -> NSData? {
        
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        
        var mediaBox = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPage(mediaBox: &mediaBox)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        pdfContext.endPage()
        
        return pdfData
    }
    
    //SAVE IMAGE IN DOCUMENT DIRECTORY
      
    func saveImageDocumentDirectory(ImgForSave : UIImage,filename : String)
    {
        let fileManager = FileManager.default
        let url = (getDirectoryPath() as NSURL)
          
        let imagePath = url.appendingPathComponent(filename + ".jpeg") // Here Image Saved With This Name ."MyImage.png"
        let urlString: String = imagePath!.absoluteString
          
//        let ImgForSave = UIImage(named: "14") // here i Want To Saved This Image In Document Directory
        let imageData = UIImage.pngData(ImgForSave)
       
        fileManager.createFile(atPath: urlString as String, contents: imageData(), attributes: nil)
     }

    
    
    @IBAction func cropTapped(_ sender: UIButton!) {
//        controller.cropImage()
    }
    
    @IBAction func close_Alert(_ sender: Any) {
        self.view_bg.isHidden = true
        // function for save image in documnet directory
   
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyScans_VC") as! MyScans_VC
        vc.modalPresentationStyle = .fullScreen
//        vc.imgDocs = results.originalScan.image
        vc.shouldAddImage = true
        vc.strDateNTime = currentDateNTime
        vc.isImageEditingScreen = true
        vc.isAddMoreDocs = self.isAddMoreDocs
        vc.clicked_index = self.clicked_index
        vc.arrfileName = self.arrfileName
        
        self.navigationController?.pushViewController(vc, animated: true)

//        self.present(vc, animated: true, completion: nil)

    }
    
    
    func closeAndSave() {
        self.view_bg.isHidden = true
        // function for save image in documnet directory
   
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyScans_VC") as! MyScans_VC
        vc.modalPresentationStyle = .fullScreen
//        vc.imgDocs = results.originalScan.image
        vc.shouldAddImage = true
        vc.strDateNTime = currentDateNTime
        vc.isImageEditingScreen = true
        vc.isAddMoreDocs = self.isAddMoreDocs
        vc.clicked_index = self.clicked_index
        vc.arrfileName = self.arrfileName
        
        self.navigationController?.pushViewController(vc, animated: true)

//        self.present(vc, animated: true, completion: nil)
    }
    
    
    func shareImage(image : UIImage){
        // image to share
        //           let image = UIImage(named: "Image")
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
//        self.navigationController?.pushViewController(vc, animated: true)

//        self.present(activityViewController, animated: true, completion: nil)
    }

    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Document has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func showAlert(title:String,message:String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func download_clicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Save As", message: "Are you want to download your document as ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "JPEG", style: .default, handler: { (action) in
            
            UIImageWriteToSavedPhotosAlbum(self.imgDocs, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            self.closeAndSave()
        }))
        alert.addAction(UIAlertAction(title: "PDF", style: .default, handler: { (action) in
            
            let pdfDocument = PDFDocument()
            
            //        for i in 0 ..< image.pageCount {
            if let image = self.imgDocs.resize(toWidth: 250){
                // Create a PDF page instance from your image
                let pdfPage = PDFPage(image: image)
                // Insert the PDF page into your document
                pdfDocument.insert(pdfPage!, at: 0)
            }
            //        }
            
            // Get the raw data of your PDF document
            let data = pdfDocument.dataRepresentation()
            
            let docURL = documentDirectory.appendingPathComponent(self.filename + ".pdf")
            do{
                try data?.write(to: docURL)
                self.closeAndSave()
            }catch(_)
            {
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func share_clicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Share image", message: "Are you want to share your document as ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "JPEG", style: .default, handler: { (action) in
            
//            self.present(alert, animated: true, completion: nil)
            self.shareImage(image: self.imgDocs)
        }))
        alert.addAction(UIAlertAction(title: "PDF", style: .default, handler: { (action) in
            
            let pdfData = self.generatePDF(image: self.imgDocs)
            let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
//
//            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)

        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func retake_image(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Camera_VC") as! Camera_VC
        vc.modalPresentationStyle = .fullScreen
        vc.clicked_index = self.clicked_index
        vc.arr_images = self.arr_images
        vc.isAddMoreDocs = self.isAddMoreDocs
//        vc.isAddmoreImageFrom_ImageEditing = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func back_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getCurrentDateTime() -> String{
        var strDateTime = String()
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        strDateTime = formatter.string(from: date as Date)
        return strDateTime
    }
    
    @IBAction func sendImage_Action(_ sender: Any) {
        
        var i : Int = 0
        for file in self.arrfileName{
            saveImageDocumentDirectory(ImgForSave: self.arr_images[i],filename: file)
            i += 1
        }
        currentDateNTime = getCurrentDateTime()
        self.lbl_imgName.text = filename
        self.lbl_imgDate.text = currentDateNTime
        self.view_bg.isHidden = false
        
    }
}

import MobileCoreServices

class MyItemProvider: UIActivityItemProvider {

   func item() -> AnyObject {
    self.placeholderItem as AnyObject
  }

   func activityViewController(activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: String?) -> String {
    return kUTTypePDF as String
  }

  func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
    return self.placeholderItem as AnyObject
  }
}



@available(iOS 14.0, *)
extension ImageEditing_VC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90) //add your height here
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath as IndexPath) as! ImagesCell
        cell.delegate = self
        let img = self.arr_images[indexPath.item]
        cell.img_scannedItem.image = img
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.img_captured.image = self.arr_images[indexPath.item]
        self.img_capturedPhoto.image = self.arr_images[indexPath.item]
        self.imgDocs = self.arr_images[indexPath.item]

    }
    
}

@available(iOS 14.0, *)
extension ImageEditing_VC : RemoveImageDelegate{
    func removeClicked(cell: ImagesCell) {
        let indexPath = self.colView_images.indexPath(for: cell)
        self.arr_images.remove(at: indexPath!.item)
        self.colView_images.reloadData()
    }
}
