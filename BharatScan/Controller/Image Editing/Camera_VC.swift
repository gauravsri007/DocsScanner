//
//  Camera_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 23/07/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import AVFoundation
import VisionKit
import Vision
import PDFKit
import WeScan

@available(iOS 14.0, *)

class Camera_VC: UIViewController, AVCaptureMetadataOutputObjectsDelegate,AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var btn_CapturePhoto: UIButton!
    @IBOutlet weak var img_demo: UIImageView!
    @IBOutlet weak var view_camera: UIView!
    @IBOutlet weak var btn_Gallery: UIButton!
    @IBOutlet weak var btn_Flash: UIButton!
    @IBOutlet weak var btn_Collections: UIButton!
    var imagePicker = UIImagePickerController()
    var clicked_index : Int!
    var isAddMoreDocs : Bool = false
    var arr_images: [ UIImage]!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }

    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        view_camera.layer.addSublayer(videoPreviewLayer)
        let metadataOutput = AVCaptureMetadataOutput()
        if self.captureSession.canAddOutput(metadataOutput) {
            self.captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.ean13]
        } else {
            print("Could not add metadata output")
        }
        //Step12
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
             self.captureSession.startRunning()
             //Step 13
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.view_camera.bounds
            }
         }
    }
    
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.setUIConfiguration()
    }
    
    func setUIConfiguration(){
        self.btn_CapturePhoto.layer.cornerRadius = self.btn_CapturePhoto.frame.width / 2
        self.btn_CapturePhoto.layer.borderWidth = 6
        self.btn_CapturePhoto.layer.borderColor = UIColor.white.cgColor
        self.btn_Flash.imageView?.contentMode = .scaleAspectFit
        self.btn_Gallery.imageView?.contentMode = .scaleAspectFit
        self.btn_Collections.imageView?.contentMode = .scaleAspectFit

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }

        let image = UIImage(data: imageData)
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
        scannerViewController.navigationBar.backgroundColor = UIColor.lightGray
//        scannerViewController.toolbar.backgroundColor = .yellow
//        scannerViewController.popoverPresentationController?.backgroundColor = .red
        present(scannerViewController, animated: true)
//                captureImageView.image = image
    }
    
    
    @IBAction func click_photo(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    
    @IBAction func go_to_Collections(_ sender: Any) {
        self.goTOCollections()
    }
    
    
    func goTOCollections(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyScans_VC") as! MyScans_VC
        vc.modalPresentationStyle = .fullScreen
        vc.shouldAddImage = false
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func clicked_Flash(_ sender: Any) {
        self.toggleFlash()
    }
    
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                self.btn_Flash.setImage(UIImage(named: "flash_off"), for: .normal)
                device.torchMode = AVCaptureDevice.TorchMode.off
                
            } else {
                do {
                    self.btn_Flash.setImage(UIImage(named: "flash_on"), for: .normal)
                    try device.setTorchModeOn(level: 1.0)
                    
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }

    func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func open_Gallery(_ sender: Any) {
        selectImage()
    }
}

@available(iOS 14.0, *)

extension Camera_VC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else { return }
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
               scannerViewController.navigationBar.backgroundColor = UIColor.lightGray
        present(scannerViewController, animated: true)
    }
}
    
    

@available(iOS 14.0, *)
extension Camera_VC: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        assertionFailure("Error occurred: \(error)")
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true, completion: nil)
        if self.arr_images == nil{
            self.arr_images = []
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Filters_VC") as! Filters_VC
        vc.modalPresentationStyle = .fullScreen
        vc.imgDocs = results.croppedScan.image
        vc.clicked_index = clicked_index
        vc.arr_images = self.arr_images
        vc.isAddMoreDocs = self.isAddMoreDocs
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
        
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
}


