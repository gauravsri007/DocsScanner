//
//  Filters_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 27/09/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import Accelerate

@available(iOS 14.0, *)
class Filters_VC: UIViewController {
    
    var img_editable = UIImage()
    var img_editable_copy = UIImage()
    var cg_image : CGImage?
    var toggle_original : Bool = false
    var toggle_magic : Bool = false
    var toggle_grayScale : Bool = false
    var toggle_black_white : Bool = false
    var toggle_edit : Bool = false
    var arrfilterChecked : [Bool] = []
    //-------------------------------------
    var imgDocs = UIImage()
    
    var clicked_index : Int!
    var isAddMoreDocs : Bool = false
    var arr_images: [ UIImage] = []
    var arrfileName: [String] = []
    
    @IBOutlet weak var btn_original: UIButton!{
        didSet{
            btn_original.imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var btn_tick: UIButton!{
        didSet{
            btn_tick.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var btn_black_white: UIButton!{
        didSet{
            btn_black_white.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var btn_magic_color: UIButton!{
        didSet{
            btn_magic_color.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var btn_grayScale: UIButton!{
        didSet{
            btn_grayScale.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var btn_edit: UIButton!{
        didSet{
            btn_edit.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    
    
    
    
    @IBOutlet weak var img_filter: UIImageView!{
        didSet{
            cg_image = {
                guard let cgImage = imgDocs.cgImage else {
                    fatalError("Unable to get CGImage")
                }
                
                return cgImage
            }()
        }
    }
    
    
    /*
     The format of the source asset.
     */
    lazy var sourceFormat: vImage_CGImageFormat = {
        guard
            let format = vImage_CGImageFormat(cgImage:cg_image!) else {
            fatalError("Unable to create format.")
        }
        
        return format
    }()
    
    /*
     The buffer containing the source image.
     */
    lazy var sourceBuffer: vImage_Buffer = {
        guard
            var sourceImageBuffer = try? vImage_Buffer(cgImage:cg_image!,
                                                       format: sourceFormat),
            var scaledBuffer = try? vImage_Buffer(width: Int(sourceImageBuffer.width / 3),
                                                  height: Int(sourceImageBuffer.height / 3),
                                                  bitsPerPixel: sourceFormat.bitsPerPixel) else {
            fatalError("Unable to create source buffer.")
        }
        
        vImageScale_ARGB8888(&sourceImageBuffer,
                             &scaledBuffer,
                             nil,
                             vImage_Flags(kvImageNoFlags))
        
        return scaledBuffer
    }()
    
    /*
     The 3-channel RGB format of the destination image.
     */
    lazy var rgbFormat: vImage_CGImageFormat = {
        return vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 8 * 3,
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
            renderingIntent: .defaultIntent)!
    }()
    
    /*
     The buffer containing the image after gamma adjustment.
     */
    lazy var destinationBuffer: vImage_Buffer = {
        
        guard let destinationBuffer = try? vImage_Buffer(width: Int(sourceBuffer.width),
                                                         height: Int(sourceBuffer.height),
                                                         bitsPerPixel: rgbFormat.bitsPerPixel) else {
            fatalError("Unable to create destinastion buffer.")
        }
        
        return destinationBuffer
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.img_filter.image = imgDocs
        img_editable = self.img_filter.image!
        img_editable_copy = img_editable
        
        for _ in 0 ... 4{
            arrfilterChecked.append(false)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.title = "Filters"
        navigationController?.setNavigationBarHidden(false, animated: animated)
        nc.addObserver(self, selector: #selector(CroppedImage), name: Notification.Name("CroppedImage"), object: nil)
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CroppedImage"), object: nil)
    }
    
    
    @objc func CroppedImage(_ notification:Notification){
        // Do something now
        if let data = notification.userInfo as? [String: Any]
        {
            let image = data["cropped_image"] as! UIImage
            self.img_filter.image = image as! UIImage
            img_editable = self.img_filter.image!
            img_editable_copy = img_editable
        }
    }
    
    
    @IBAction func back_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func filter_button_clicked(_ sender: UIButton) {
        let selectedIndex =  sender.tag - 10
        
        for i in 0...arrfilterChecked.count - 1{
            let button = self.view.viewWithTag(10 + i) as? UIButton
            if i == selectedIndex && !arrfilterChecked[selectedIndex]{
                arrfilterChecked [i] = true
                //                sender.setBackgroundImage(UIImage(named: "tab_selected"), for: .normal)
                switch selectedIndex {
                case 0:
                    sender.setImage( UIImage(named:"filter_S_original"), for: .normal)
                    original_image_clicked()
                    break
                case 1:
                    sender.setImage( UIImage(named:"filter_S_magic"), for: .normal)
                    magic_color_clicked()
                    break
                case 2:
                    sender.setImage( UIImage(named:"filter_S_grayScale"), for: .normal)
                    greyScale_clicked()
                    break
                case 3:
                    sender.setImage( UIImage(named:"filter_S_black_white"), for: .normal)
                    black_White_clicked()
                    break
                case 4:
                    sender.setImage( UIImage(named:"filter_S_edit"), for: .normal)
                    edit_clicked()
                    break
                default:
                    break
                }
            }
            else{
                arrfilterChecked [i] = false
                switch i {
                case 0:
                    button!.setImage( UIImage(named:"filter_original"), for: .normal)
                    break
                case 1:
                    button!.setImage( UIImage(named:"filter_magic"), for: .normal)
                    break
                case 2:
                    button!.setImage( UIImage(named:"filter_grayscale"), for: .normal)
                    break
                case 3:
                    button!.setImage( UIImage(named:"filter_black_white"), for: .normal)
                    break
                case 4:
                    button!.setImage( UIImage(named:"filter_edit"), for: .normal)
                    break
                default:
                    break
                }
            }
        }
    }
    
    
    
    
    
    
    
    func original_image_clicked() {
        img_filter.image = img_editable
    }
    
    
    func magic_color_clicked() {
        //        if let result = getGammaCorrectedImage(preset:ResponseCurvePreset(label: "E2",
        //                             boundary: 0,
        //                             linearCoefficients: [2, 0],
        //                             gamma: 2.2)) {
        //             self.img_filter.image = result
        //         }
        img_filter.image = magicColor(image: img_editable_copy)
    }
    
    
    func magicColor(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectChrome") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
    
    func greyScale_clicked() {
        
        img_filter.image = grayscale(image: img_editable_copy)
    }
    
    
    func black_White_clicked() {
        
        img_filter.image = BlackWhite(image: img_editable_copy)
    }
    
    
    func edit_clicked() {
        //        let newImg = cropToBounds(image: self.img_editable_copy, width: 20.0, height: 30.0)
        //        self.img_filter.image = newImg
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Cropper_VC") as! Cropper_VC
        //        vc.modalPresentationStyle = .fullScreen
        vc.croppable_image = self.img_filter.image!
        vc.modalPresentationStyle = .fullScreen
        //        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func doneClicked(_ sender: Any) {
        print("arr_images Count",arr_images.count)
        self.arr_images.append(self.img_filter.image!)
        
        let imageEditing_vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditing_VC") as! ImageEditing_VC
        imageEditing_vc.modalPresentationStyle = .fullScreen
        //        vc.imgDocs = img_filter.image!
        imageEditing_vc.clicked_index = clicked_index
        imageEditing_vc.arr_images = self.arr_images
        imageEditing_vc.isAddMoreDocs = self.isAddMoreDocs
        self.navigationController?.pushViewController(imageEditing_vc, animated: true)
        //        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func ocr_clicked(_ sender: UIButton) {
    }
    
    
    @IBAction func watermark_clicked(_ sender: UIButton) {
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)//CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    func grayscale(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectNoir") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
    
    func convertToGrayScale(image: UIImage) -> UIImage {
        
        // Create image rectangle with current image width/height
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)
        
        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        
        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()
        
        // Create a new UIImage object
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage
    }
    
    
    func BlackWhite(image:UIImage) -> UIImage? {
        let currentCGImage = image.cgImage
        let currentCIImage = CIImage(cgImage: currentCGImage!)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        
        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.2, green: 0.2, blue: 0.2), forKey: "inputColor")
        
        filter?.setValue(1.0, forKey: "inputIntensity")
        let outputImage = filter?.outputImage
        
        let context = CIContext()
        
        if let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
            //print(processedImage.size)
        }
        return nil
    }
    
    func getGammaCorrectedImage(preset: ResponseCurvePreset) -> UIImage? {
        /*
         Declare the adjustment coefficents based on the currently selected preset.
         */
        let boundary: Pixel_8 = preset.boundary
        
        let linearCoefficients: [Float] = preset.linearCoefficients
        
        let exponentialCoefficients: [Float] = [1, 0, 0]
        let gamma: Float = preset.gamma
        
        vImageConvert_RGBA8888toRGB888(&sourceBuffer,
                                       &destinationBuffer,
                                       vImage_Flags(kvImageNoFlags))
        
        /*
         Create a planar representation of the interleaved destination buffer. Becuase `destinationBuffer` is 3-channel, assign the planar destinationBuffer a width of 3x the interleaved width.
         */
        var planarDestination = vImage_Buffer(data: destinationBuffer.data,
                                              height: destinationBuffer.height,
                                              width: destinationBuffer.width * 3,
                                              rowBytes: destinationBuffer.rowBytes)
        
        
        /*
         Perform the adjustment.
         */
        vImagePiecewiseGamma_Planar8(&planarDestination,
                                     &planarDestination,
                                     exponentialCoefficients,
                                     gamma,
                                     linearCoefficients,
                                     boundary,
                                     vImage_Flags(kvImageNoFlags))
        
        /*
         Create a 3-channel `CGImage` instance from the interleaved buffer.
         */
        let result = try? destinationBuffer.createCGImage(format: rgbFormat)
        
        if let result = result {
            return UIImage(cgImage: result)
        } else {
            return nil
        }
    }
    
    /*
     A structure that wraps piecewise gamma parameters.
     */
    struct ResponseCurvePreset {
        let label: String
        let boundary: Pixel_8
        let linearCoefficients: [Float]
        let gamma: Float
    }
    
    
}
