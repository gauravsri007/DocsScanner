//
//  Constant.swift
//  Music App
//
//  Created by KUMAR GAURAV on 04/04/20.
//  Copyright © 2020 Music. All rights reserved.
//

import UIKit
import Foundation
import BRYXBanner


let DEVICE_TOKEN = "Device_token"

let nc = NotificationCenter.default
let defaults = UserDefaults.standard
let MY_COLLECTIONS = "my_collections_keys"
let COLLECTIONS_DATE_TIME = "collections_date_time"
let kBaseURL = "https://bharatscan.sortstring.com/api/"
let USER_ID_LOGIN = "USERID"
let MOBILE = "mobile"
let IS_LOGGED_IN = "isLoggedIn"



let USER_ID = "id"
let IS_LOGIN = "isLogin"
let FOLDER_NAME = "BharatScan"

let linkColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
let blurColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.25)
let THEME_COLOR_NAVIGATION = UIColor(red: 0.0/255.0, green: 181.0/255.0, blue: 226.0/255.0, alpha: 1.0)
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

var str_UserID : String?
func getUserID()->String{
    if let str_UserID = (UserDefaults.standard.value(forKey: USER_ID_LOGIN) as? String){
    return str_UserID
    }
    else{
        return ""
    }
}


// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

let themeColor = UIColor(red: 87.0/255.0, green: 182.0/255.0, blue: 195.0/255.0, alpha: 1.0)
let themeColor_blue = UIColor(red: 0/255.0, green: 174.0/255.0, blue: 239.0/255.0, alpha: 1.0)

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}



func showAlert_banner(msg:String,bgColor:UIColor,type:String){
    let strMessage = msg
    let banner: Banner
    if type == "success" {
        banner = Banner(title: "Succes", subtitle: strMessage, image: UIImage(named: "approved"), backgroundColor: bgColor)
    }
    else{
        banner = Banner(title: "Alert", subtitle: strMessage, image: UIImage(named: "rejected"), backgroundColor: bgColor)
    }
    banner.dismissesOnTap = true
    banner.show(duration: 3.0)
}


// MARK: - Method to convert JSON String into Dictionary
func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
//            print(error.localizedDescription)
        }
    }
    return nil
}


func get_user_id()-> String{
    return defaults.value(forKey: USER_ID) as! String
}


extension UIImage{
    func resize(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    static var camera_fab: UIImage {
        return UIImage(named: "camera")!
    }
    
    static var gallery_fab: UIImage {
        return UIImage(named: "gallery")!
    }
}



//FUNCTION FOR GET DIRECTORY PATH

func getDirectoryPath() -> NSURL
{
  // path is main document directory path
      
    let documentDirectoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
    let pathWithFolderName = documentDirectoryPath.appendingPathComponent(FOLDER_NAME)
    let url = NSURL(string: pathWithFolderName) // convert path in url
      print(url)
    return url!
}


// Function For Create Folder In Document Directory
  
func CreateFolderInDocumentDirectory()
{
  let fileManager = FileManager.default
  let PathWithFolderName = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(FOLDER_NAME)
  
//  print("Document Directory Folder Path :- ",PathWithFolderName)
      
  if !fileManager.fileExists(atPath: PathWithFolderName)
  {
      try! fileManager.createDirectory(atPath: PathWithFolderName, withIntermediateDirectories: true, attributes: nil)
  }
}


 

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}

