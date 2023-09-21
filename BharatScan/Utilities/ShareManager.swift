//
//  ShareManager.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 12/08/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import PDFKit

class ShareManager: NSObject {
    static let sharedInstance = ShareManager()
    override init() {
        super.init()
    }
    
    
    var docURL : URL!
    
    func generateJPG(image : UIImage , filename : String)->URL{
        let image_jpg = image.jpegData(compressionQuality: 100)
        if let data = image.jpegData(compressionQuality: 0.8) {
            
            docURL = documentDirectory.appendingPathComponent(filename + ".jpeg")
            do{
                try data.write(to: docURL)
            }catch(let error)
            {
                print("error is \(error.localizedDescription)")
            }
            
        }
        return docURL
    }
    
    //GET IMAGE FROM DOCUMENT DIRECTORY
    
    func getImageFromDocumentDirectory(file_name : String)->UIImage
    {
        let fileManager = FileManager.default
        var tempImage = UIImage()
        
        let imagePath = (getDirectoryPath() as NSURL).appendingPathComponent(file_name + ".jpeg") // here assigned img name who assigned to img when saved in document directory. Here I Assigned Image Name "MyImage.png"
        
        let urlString: String = imagePath!.absoluteString
        
        if fileManager.fileExists(atPath: urlString)
        {
            let GetImageFromDirectory = UIImage(contentsOfFile: urlString) // get this image from Document Directory And Use This Image In Show In Imageview
            tempImage = GetImageFromDirectory!
        }
        //        else
        //        {
        //            print("No Image Found")
        //        }
        return tempImage
    }
    
    
    func getAllImagesFromDocumentDirectory(arr_file_name: [String])->[UIImage]
    {
        var imagesArray : [UIImage] = []
        let fileManager = FileManager.default
        for file_name in arr_file_name{
            
            var tempImage = UIImage()
            
            
            let imagePath = (getDirectoryPath() as NSURL).appendingPathComponent(file_name + ".jpeg") // here assigned img name who assigned to img when saved in document directory. Here I Assigned Image Name "MyImage.png"
            
            let urlString: String = imagePath!.absoluteString
            
            if fileManager.fileExists(atPath: urlString)
            {
                let GetImageFromDirectory = UIImage(contentsOfFile: urlString) // get this image from Document Directory And Use This Image In Show In Imageview
                tempImage = GetImageFromDirectory!
            }
            imagesArray.append(tempImage)
        }
        return imagesArray
    }
    
    
    
    func generateImageArrayToPDF(arr_img : [String])->Data{
        
        let pdfDocument = PDFDocument()
        for i in 0 ..< arr_img.count {
            let strFileName = arr_img[i]
            let image_from_Storage = getImageFromDocumentDirectory(file_name: strFileName)
            if let image = image_from_Storage.resize(toWidth: 250){
                // Create a PDF page instance from your image
                let pdfPage = PDFPage(image: image)
                // Insert the PDF page into your document
                pdfDocument.insert(pdfPage!, at: 0)
            }
        }
        
        
        // Get the raw data of your PDF document
        let data = pdfDocument.dataRepresentation()
        //
        //        let docURL = documentDirectory.appendingPathComponent(filename + ".pdf")
        //        do{
        //            try data?.write(to: docURL)
        //        }catch(let error)
        //        {
        //            print("error is \(error.localizedDescription)")
        //        }
        
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
    
    func saveImageDocumentDirectory(ImgForSave : UIImage , filename : String)
    {
        let fileManager = FileManager.default
        let url = (getDirectoryPath() as NSURL)
        
        let imagePath = url.appendingPathComponent(filename + ".jpeg") // Here Image Saved With This Name ."MyImage.png"
        let urlString: String = imagePath!.absoluteString
        
        //        let ImgForSave = UIImage(named: "14") // here i Want To Saved This Image In Document Directory
        let imageData = UIImage.pngData(ImgForSave)
        
        fileManager.createFile(atPath: urlString as String, contents: imageData(), attributes: nil)
    }
    
}
