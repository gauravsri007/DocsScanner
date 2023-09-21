//
//  Login_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 19/07/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import MBProgressHUD
import Alamofire
import AVFoundation

@available(iOS 14.0, *)
class Login_VC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var view_mobile: UIView!
    @IBOutlet weak var view_otp: UIView!
    @IBOutlet weak var txtField_mobile: UITextField!
    @IBOutlet weak var txtField_OTP: UITextField!
    @IBOutlet weak var view_bg: UIView!
    
    @IBOutlet weak var view_video: UIView!
    @IBOutlet weak var lbl_login: UILabel!
    @IBOutlet weak var btn_signin: UIButton!
    @IBOutlet weak var btn_checked: UIButton!
    @IBOutlet weak var view_main: UIView!
    
    
    var player: AVPlayer?
    var toggleChecked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KeyboardAvoiding.avoidingView = self.view_main
        self.loadVideo()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillLayoutSubviews() {
        self.setUIConfiguration()
    }
    
    private func loadVideo() {
        
        guard let confettiImageView = UIImageView.fromGif(frame: self.view.frame, resourceName: "login") else { return }
        self.view_video.addSubview(confettiImageView)
        confettiImageView.startAnimating()
    }
    
    func setUIConfiguration(){
        self.btn_signin.layer.cornerRadius = 8
        self.view_mobile.layer.cornerRadius = 8
        self.view_otp.layer.cornerRadius = 8
        self.view_otp.layer.borderColor = UIColor.lightGray.cgColor
        self.view_mobile.layer.borderColor = UIColor.lightGray.cgColor
        self.view_mobile.layer.borderWidth = 2
        self.view_otp.layer.borderWidth = 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        txtField_OTP!.resignFirstResponder()
        txtField_mobile!.resignFirstResponder()
    }
    
    
    @IBAction func get_OTP(_ sender: Any) {
        self.send_OTP_API()
    }
    
    func showAlert(title:String,message:String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func checked_Action(_ sender: Any) {
        toggleChecked = !toggleChecked
        if toggleChecked{
            btn_checked.setImage(UIImage(named: "checked"), for: .normal)
        }
        else{
            btn_checked.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        let mobile : String = txtField_mobile.text!
        if mobile == ""{
            self.showAlert(title: "Error", message: "Mobile number cannot empty")
        }
        else if txtField_OTP.text == ""{
            self.showAlert(title: "Error", message: "OTP cannot empty")
        }
        else if mobile.count != 10{
            self.showAlert(title: "Error", message: "Mobile number should be 10 digits")
        }
        else{
            self.login_API()
        }
    }
    
    @IBAction func skip_Action(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VisionCamera_VC") as! VisionCamera_VC
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)

    }
    
        //MARK:- API
        //MARK:-
        
    func login_API(){
        
        let mobile_num : String = self.txtField_mobile.text!
        let OTP : String = self.txtField_OTP.text!

        // * Chechk Whether Network is Unreachable *
        if !(NetworkManager.sharedInstance.reachability.connection != .unavailable){
            self.view.MyToast()
            return
        }
        //        SVProgressHUD.show()
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let body: NSMutableDictionary? = ["mobile_number":mobile_num,
                                          "otp":OTP]
        let strUrl = kBaseURL + "login" as String
        let url = NSURL(string: strUrl)
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.timeoutInterval = 60 // 10 secs
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject:body as Any , options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.validate(statusCode: 200..<300)
        alamoRequest.responseString { response in
            progressHUD.hide(animated: true)
            //            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
                let resultsArray = response.value//response.value
                if let dic = convertToDictionary(text: resultsArray!) as NSDictionary?{
                    let isSuccess : String = dic.value(forKey: "response_code") as! String
                    //                print(isSuccess)
                    if isSuccess == "200"{
                        if self.toggleChecked{
                            defaults.set(mobile_num, forKey: "mobile")
                            defaults.set(true, forKey: IS_LOGGED_IN)
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyScans_VC") as! MyScans_VC
                        //        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }
            case .failure(let error):
                DispatchQueue.global().async() {
                    // ...Run some task in the background here...
                    DispatchQueue.main.async() {
                        progressHUD.hide(animated: true)
                        
                    }
                }
                break
            }
        }
    }
        // -------- End Of API ---------
    
    func send_OTP_API(){
        
        // * Chechk Whether Network is Unreachable *
        if !(NetworkManager.sharedInstance.reachability.connection != .unavailable){
            self.view.MyToast()
            return
        }
        //        SVProgressHUD.show()
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let body: NSMutableDictionary? = ["mobile_number":txtField_mobile.text]
        let strUrl = kBaseURL + "send-otp" as String
        let url = NSURL(string: strUrl)
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.timeoutInterval = 60 // 10 secs
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject:body as Any , options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.validate(statusCode: 200..<300)
        alamoRequest.responseString { response in
            progressHUD.hide(animated: true)
            //            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
                let resultsArray = response.value//response.value
                if let dic = convertToDictionary(text: resultsArray!) as NSDictionary?{
                    let isSuccess : String = dic.value(forKey: "response_code") as! String
                    //                print(isSuccess)
                    if isSuccess == "200"{
                        let msg : String = dic.value(forKey: "msg") as! String

                    }
                }
            case .failure(let error):
                DispatchQueue.global().async() {
                    // ...Run some task in the background here...
                    DispatchQueue.main.async() {
                        progressHUD.hide(animated: true)
                        
                    }
                }
                break
            }
        }
    }

}
