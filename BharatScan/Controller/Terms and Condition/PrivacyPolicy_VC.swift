//
//  PrivacyPolicy_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 09/08/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicy_VC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    let PRIVACY_POLICY = "https://policy.surya-app.com/privacy.html"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        let url = URL(string: PRIVACY_POLICY)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func setNavigationBar(){
        let navigationbarapperarance = UINavigationBarAppearance()
        navigationbarapperarance.configureWithOpaqueBackground()
        navigationbarapperarance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationbarapperarance.backgroundColor = THEME_COLOR_NAVIGATION
        navigationbarapperarance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = navigationbarapperarance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationbarapperarance
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setNavigationBar()
        self.title = "Privacy Policy"
    }
    

    @IBAction func back_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension PrivacyPolicy_VC : WKNavigationDelegate{
    
}
