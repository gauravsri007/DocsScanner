//
//  ContactUs_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 09/08/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit

class ContactUs_VC: UIViewController {

    @IBOutlet weak var lbl_writeUs: UILabel!
    @IBOutlet weak var lbl_visitUs: UILabel!
    @IBOutlet weak var lbl_callUs: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.title = "Contact Us"
        self.lbl_writeUs.text = ""
        self.lbl_visitUs.text = "https://policy.surya-app.com"
        self.lbl_callUs.text = "91-8960825007"
    }
    

    @IBAction func back_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
