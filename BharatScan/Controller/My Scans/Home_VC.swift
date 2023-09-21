//
//  Home_VC.swift
//  BharatScan
//
//  Created by apple on 19/09/23.
//  Copyright © 2023 KUMAR GAURAV. All rights reserved.
//

    import UIKit
    import PDFKit
    import IHKeyboardAvoiding
    import Hover

    class Home_VC: UIViewController,CAAnimationDelegate,UITextFieldDelegate{
    //    private let hoverView = HoverView(with: HoverConfiguration(image: .add, color: .gradient(top: .yellow, bottom: .green)),
    //                                      items: [HoverItem(title: "Drop it Anywhere", image: .camera_fab) { os_log("Tapped 'Drop it anywhere'") },
    //                HoverItem(title: "Gesture Driven", image: .gesture) { os_log("Tapped 'Gesture driven'") }])
        
        
        @IBOutlet weak var view_rename: UIView!
        
        @IBOutlet weak var view_drop_menu: UIView!
        @IBOutlet weak var tblView_Actions: UITableView!
        @IBOutlet weak var view_txtField_rename: UIView!{
            didSet{
                self.view_txtField_rename.layer.borderWidth = 1
                self.view_txtField_rename.layer.borderColor = UIColor.gray.cgColor
                self.view_txtField_rename.layer.cornerRadius = 10
            }
        }
        @IBOutlet weak var txtField_rename_folder: UITextField!
        @IBOutlet weak var btn_close_rename: UIButton!{
            didSet{
                self.btn_close_rename.layer.cornerRadius = 10
            }
        }
        @IBOutlet weak var lbl_UserName: UILabel!
        
        @IBOutlet weak var btn_profile_title: UIButton!
        @IBOutlet weak var btn_profile: UIButton!{
            didSet{
                btn_profile.layer.cornerRadius = btn_profile.frame.width / 2
                btn_profile.layer.borderWidth = 6
                btn_profile.layer.borderColor = UIColor.white.cgColor
            }
        }
        @IBOutlet weak var view_topMenu: UIView!
        @IBOutlet weak var btn_downMenu: UIButton!{
            didSet{
                btn_downMenu.layer.cornerRadius = btn_downMenu.frame.width / 2
                btn_downMenu.addSideShadow(color: UIColor.lightGray)
            }
        }
        
        @IBOutlet weak var tblView_menu: UITableView!
        @IBOutlet weak var view_bg: UIView!
        @IBOutlet weak var view_menu: UIView!
        @IBOutlet weak var cons_menu_trailing: NSLayoutConstraint!
        @IBOutlet weak var view_menu_bg: UIView!
        @IBOutlet weak var view_Alert: UIView!
        @IBOutlet weak var colView_Folders: UICollectionView!
        var arr_folder                  : [String] = []
        var arr_folder_keys             : [String] = []
        var arr_dateNTime               : [String] = []
        var clicked_index               : Int!
        var arr_menu_imagaes            : [String] = []
        var arr_menu_values             : [String] = []
        var arr_inner_docs              : [String] = []
        var arr_picker                  : [String] = []
        var toggle_threeDot             : Bool = false
        var shouldAddImage              : Bool = false
        var isAddMoreDocs               : Bool = false
        var isImageEditingScreen        : Bool = false

        var arr_images                  : [ UIImage] = []
        var panGesture       = UIPanGestureRecognizer()
        var arrfileName: [String] = []
        var strDateNTime = String()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            arr_folder = []
            arr_dateNTime = []
            if let myarray = defaults.stringArray(forKey: MY_COLLECTIONS){
                arr_folder_keys = myarray
                //---------------- to store collections -----------------
            }
            if let array_date = defaults.stringArray(forKey: COLLECTIONS_DATE_TIME){
                arr_dateNTime = array_date
                //---------------- to store collections -----------------
            }
            
            if shouldAddImage{
                if isAddMoreDocs{
                    let strKey = arr_folder_keys[clicked_index]
                    if let inner_array = defaults.stringArray(forKey: strKey){
                        var arr_folder = inner_array
                        arr_folder += self.arrfileName
                        defaults.set(arr_folder, forKey: strKey)
                        defaults.synchronize()
                        //---------------- to store collections -----------------
                    }
                }
                else{
                    
                    defaults.set(arrfileName, forKey: arrfileName[0])
                    arr_folder_keys.append(arrfileName[0])
                    defaults.set(arr_folder_keys, forKey: MY_COLLECTIONS)
                    arr_dateNTime.append(strDateNTime)
                    defaults.set(arr_dateNTime, forKey: COLLECTIONS_DATE_TIME)
                    defaults.synchronize()
                    
                }
            }
            
            self.setUIConfiguration()
        }
        
        func setUIConfiguration(){
            
            //------------------- Set Mobile Number -----------------
            if defaults.value(forKey: IS_LOGGED_IN) != nil{
               if let mobile = defaults.value(forKey: MOBILE) as? String{
                    btn_profile.setTitle(mobile, for: .normal)
                }
            }
            
            //---------------- Configure rename view -------------------
            self.view_Alert.layer.cornerRadius = 8
            self.view_rename.layer.cornerRadius = 8
            
            //----------------------------------------------------------

            
            self.view_topMenu.roundCorners_AtTopRight(radius: 60)
            self.cons_menu_trailing.constant = self.view.frame.size.width

            arr_menu_values = ["My Scans","Contact Us","Privacy Policy","Tell Friends about Bharat Scan"]
            arr_menu_imagaes = ["menu_0","menu_1","menu_2","menu_3","menu_4"]
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            self.view_rename.addGestureRecognizer(tap)
    //
            let tap_OnMenu = UITapGestureRecognizer(target: self, action: #selector(self.handleTap_menu(_:)))
            self.view_menu_bg.addGestureRecognizer(tap_OnMenu)
            
            self.view_menu_bg.isHidden = true
            self.view_menu.frame.origin.x = -screenWidth
            
            
            arr_picker = ["Rename Document","Add more scans","Share PDF","Share JPEG","Delete","Download Document"]
            
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(DemoViewController.draggedView(_:)))
            view_drop_menu.isUserInteractionEnabled = true
            view_drop_menu.addGestureRecognizer(panGesture)
            txtField_rename_folder.delegate = self
            
        }
        
        @objc func draggedView(_ sender:UIPanGestureRecognizer){
             self.view.bringSubviewToFront(view_drop_menu)
             let translation = sender.translation(in: self.view)
             view_drop_menu.center = CGPoint(x: view_drop_menu.center.x + translation.x, y: view_drop_menu.center.y + translation.y)
             sender.setTranslation(CGPoint.zero, in: self.view)
         }
         
        
        @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
            self.txtField_rename_folder.resignFirstResponder()
    //        self.view_bg.isHidden = true
            
        }
        
        
        @IBAction func rename_docs(_ sender: Any) {
            
            self.view_bg.isHidden = false
            self.view_Alert.isHidden = true
            self.view_rename.isHidden = false
            self.txtField_rename_folder.text = self.arr_folder_keys[clicked_index]
        }
        
        @IBAction func rename_view_close(_ sender: Any) {
            self.view_bg.isHidden = true

        }
        
        @IBAction func rename_folder_save(_ sender: Any) {
            
            if txtField_rename_folder.text == ""{
                showAlert(title: "Validation error", message: "Cannot empty")
            }
            else{
                let strNewKey = txtField_rename_folder.text
                let alert = UIAlertController(title: "Succes", message: "Document saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    //------ To get old key of array -----------
                    self.txtField_rename_folder.resignFirstResponder()
                    if let myarray = defaults.stringArray(forKey: MY_COLLECTIONS){
                        let strKey = myarray[self.clicked_index]
                        
                        var arr_keys : [String] = myarray
                        arr_keys[self.clicked_index] = strNewKey!
                        
                        //------ To updated key of array -----------
                        defaults.set(arr_keys, forKey: MY_COLLECTIONS)
                        if let inner_array = defaults.stringArray(forKey: strKey){
                            let arr_folder = inner_array
                            //------ To updated array that contain key -----------
                            defaults.set(arr_folder, forKey: strNewKey!)
                            //                        defaults.removeObject(forKey: strKey)
                            defaults.synchronize()
                            
                            let fileManager = FileManager.default
                            let url = (getDirectoryPath() as NSURL)
                            
                            let imagePath_new = url.appendingPathComponent(strNewKey! + ".jpeg") // Here Image Saved With This Name ."MyImage.png"
                            
                            let oldImage = ShareManager.sharedInstance.getImageFromDocumentDirectory(file_name: strKey)
                            
                            let urlString: String = imagePath_new!.absoluteString
                            
                            //        let ImgForSave = UIImage(named: "14") // here i Want To Saved This Image In Document Directory
                            let imageData = UIImage.pngData(oldImage)
                            
                            fileManager.createFile(atPath: urlString as String, contents: imageData(), attributes: nil)
                            
                            //------ To get array from update saved array -----------
                            if let myarray = defaults.stringArray(forKey: MY_COLLECTIONS){
                                self.arr_folder_keys = myarray
                            }
                            self.view_bg.isHidden = true
                            self.colView_Folders.reloadData()
                            
                        }
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
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
        
        func showAlert_with_OK(title:String,message:String)  {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                
            }))

            self.present(alert, animated: true, completion: nil)
        }

        @IBAction func profile_title_clicked(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
            vc.modalPresentationStyle = .fullScreen
            //        vc.isfromHomeScreen = true
            //        vc.clicked_index = clicked_index
            //        vc.isAddMoreDocs = true
            self.present(vc, animated: true, completion: nil)
        }
        
        
        @IBAction func profileClicked(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
            vc.modalPresentationStyle = .fullScreen
            //        vc.isfromHomeScreen = true
    //        vc.clicked_index = clicked_index
    //        vc.isAddMoreDocs = true
            self.present(vc, animated: true, completion: nil)
        }
        
        @IBAction func add_more_docs(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VisionCamera_VC") as! VisionCamera_VC
            vc.modalPresentationStyle = .fullScreen
            //        vc.isfromHomeScreen = true
            vc.clicked_index = clicked_index
            vc.isAddMoreDocs = true
            self.present(vc, animated: true, completion: nil)


        }
        
        
        @IBAction func share_docs(_ sender: Any) {

        }
        @IBAction func delete_docs(_ sender: Any) {
            let alert = UIAlertController(title: "Alert", message: "Are you sure want you delete this document?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
     
                if let myarray = defaults.stringArray(forKey: MY_COLLECTIONS){
                    var newArray = myarray
                    newArray.remove(at: self.clicked_index)
                    defaults.set(newArray, forKey: MY_COLLECTIONS)
                    if let myarray = defaults.stringArray(forKey: MY_COLLECTIONS){
                        self.arr_folder_keys = myarray
                    }
                    self.view_bg.isHidden = true
                    self.colView_Folders.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)

        }
        
        
        @IBAction func downloaad_docs(_ sender: Any) {

        }
      
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func viewWillLayoutSubviews() {
            //        picker.isHidden = true
            self.view_Alert.addShadow(color: UIColor.gray)
            self.view_bg.isHidden = true
            self.view_bg.layer.cornerRadius = 10
        }
        
        @IBAction func close_Action(_ sender: Any) {
            txtField_rename_folder.resignFirstResponder()
            self.view_bg.isHidden = true
            
        }
        @IBAction func close_Alert(_ sender: Any) {
            
            self.view_bg.isHidden = true
        }
        
        @IBAction func downMenuClicked(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Camera_VC") as! Camera_VC
            vc.modalPresentationStyle = .fullScreen
            //        vc.isfromHomeScreen = true
            self.present(vc, animated: true, completion: nil)
            //------------------------------------------------
        }
        

        
        @objc func handleTap_menu(_ sender: UITapGestureRecognizer? = nil) {
            
            self.view_menu_bg.isHidden = true
            
            UIView.animate(withDuration: Double(0.5), animations: {
                self.cons_menu_trailing.constant = self.view.frame.size.width
                self.view.layoutIfNeeded()
            })
            { (completed) in
                
            }

        }
        
        @IBAction func menu_clicked(_ sender: Any) {
            
            UIView.animate(withDuration: Double(0.5), animations: {
                self.cons_menu_trailing.constant = 66
                self.view.layoutIfNeeded()
            })
            { (completed) in
                self.view_menu_bg.isHidden = false
            }
            
        }
        
        override func viewDidAppear(_ animated: Bool) {
            
            super.viewDidAppear(animated)
            KeyboardAvoiding.avoidingView = self.view_rename

        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            //          faceDetector.stopCapture()
        }
    }
    @available(iOS 11.0, *)
    extension DemoViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (collectionView.frame.size.width / 2)-4 , height: screenHeight * 32/100) //add your height here
        }
        
        

        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arr_folder_keys.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home_Card_Cell", for: indexPath as IndexPath) as! Home_Card_Cell
            
            let strKey = arr_folder_keys[indexPath.item]
            self.arr_inner_docs = []
            if let inner_array = defaults.stringArray(forKey: strKey){
                self.arr_inner_docs = inner_array
                if inner_array.count > 1{
                    cell.lbl_folderPageCount.text = String(inner_array.count) + " Pages"
                }
                else{
                    cell.lbl_folderPageCount.text = String(inner_array.count) + " Page"
                }
            }
            
            cell.view_bg.layer.cornerRadius = 10
    //        cell.btn_threeDot.imageView?.contentMode = .scaleAspectFit
            cell.btn_threeDot.tag = indexPath.item
            cell.btn_threeDot.addTarget(self, action: #selector(threeDotClicked), for: .touchUpInside)
            let strFileName = arr_folder_keys[indexPath.item]
            
            cell.img_category.image = ShareManager.sharedInstance.getImageFromDocumentDirectory(file_name: strFileName)
            cell.lbl_folderDate.text = arr_dateNTime[indexPath.item]
            cell.lbl_folderName.text = strFileName

            return cell
            
        }
        
        @objc func threeDotClicked(_ sender : UIButton){
            self.view_rename.isHidden = true
            self.view_Alert.isHidden = false
            clicked_index = sender.tag
            let strKey = arr_folder_keys[sender.tag]
            if let inner_array = defaults.stringArray(forKey: strKey){
                self.arr_inner_docs = inner_array
            }

            toggle_threeDot = !toggle_threeDot
            if toggle_threeDot{
                self.view_bg.isHidden = false
            }
            else{
                self.view_bg.isHidden = true
            }
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let strKey = arr_folder_keys[indexPath.item]
            if let inner_array = defaults.stringArray(forKey: strKey){
                self.goTOCollections_Details(array: inner_array,index: indexPath.item)
            }
        }
        
        func goTOCollections_Details(array : [String],index : Int){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Details_VC") as! Details_VC
            vc.modalPresentationStyle = .fullScreen
            vc.arr_folder = array
            vc.clicked_index = index
            self.present(vc, animated: true, completion: nil)
        }
    }




    extension DemoViewController : UITableViewDataSource,UITableViewDelegate{
        
        func numberOfSections(in tableView: UITableView) -> Int {
            1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == tblView_Actions{
                return self.arr_picker.count
            }
            else{
                
                return self.arr_menu_values.count
            }
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == tblView_Actions{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeDotActionCell") as! ThreeDotActionCell
                cell.lbl_title.text = self.arr_picker[indexPath.row]
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Menu_Cell") as! Menu_Cell
                cell.menu_title.text = arr_menu_values[indexPath.row]
                cell.img_menu.image = UIImage(named: arr_menu_imagaes[indexPath.row])
                return cell
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if tableView == tblView_Actions{
                return 52
            }
            else{
                return 52
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView == tblView_Actions{
                tableView.deselectRow(at: indexPath, animated: true)
                switch indexPath.row {
                case 0:
                    //-------------------- Rename Docs -------------------
                    self.view_Alert.isHidden = true
                    self.view_rename.isHidden = false
                    break
                case 1:
                    //-------------------- Add More Docs -------------------
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VisionCamera_VC") as! VisionCamera_VC
                    vc.modalPresentationStyle = .fullScreen
                    //        vc.isfromHomeScreen = true
                    vc.clicked_index = clicked_index
                    vc.isAddMoreDocs = true
                    self.present(vc, animated: true, completion: nil)
                    break
                case 2:
                    //-------------------- Share PDF Docs -------------------
                    
                    let pdfData =  ShareManager.sharedInstance.generateImageArrayToPDF(arr_img: self.arr_inner_docs)
                    let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    //            // exclude some activity types from the list (optional)
                    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                    // present the view controller
                    self.present(activityViewController, animated: true, completion: nil)
                    break
                case 3:
                    //-------------------- Share JPEG Docs -------------------
                    
                    var sharingItems = [UIImage]()
                    sharingItems = ShareManager.sharedInstance.getAllImagesFromDocumentDirectory(arr_file_name: self.arr_inner_docs)
                    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
                    activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
                    self.present(activityViewController, animated: true, completion: nil)
                    break
                case 4:
                    //-------------------- Delete Docs -------------------
                    let alert = UIAlertController(title: "Alert", message: "Are you sure want you delete this document?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        if let myarray = defaults.stringArray(forKey: MY_COLLECTIONS){
                            var newArray = myarray
                            newArray.remove(at: self.clicked_index)
                            defaults.set(newArray, forKey: MY_COLLECTIONS)
                            if let myarray = defaults.stringArray(forKey: MY_COLLECTIONS){
                                self.arr_folder_keys = myarray
                            }
                            self.view_bg.isHidden = true
                            self.colView_Folders.reloadData()
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    }))
                    self.present(alert, animated: true, completion: nil)
        
                    break
                case 5:
                    //-------------------- DownLoad Docs -------------------
                    for i in 0...self.self.arr_inner_docs.count - 1{
                        let fileName = self.arr_inner_docs[i]
                        let img_docs = ShareManager.sharedInstance.getImageFromDocumentDirectory(file_name: fileName)
                        
                        UIImageWriteToSavedPhotosAlbum(img_docs, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    }
                    
                    break
                default:
                    break
                }
            }
            else{
                tableView.deselectRow(at: indexPath, animated: true)
                switch indexPath.row {
                case 0:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VisionCamera_VC") as! VisionCamera_VC
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    break
                case 1:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUs_VC") as! ContactUs_VC
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    break
                case 2:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicy_VC") as! PrivacyPolicy_VC
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    break
                case 3:
                    shareApp()
                    break
                default:
                    break
                }
            }
        }
        
        func shareApp(){
            // Setting description
            //Set the default sharing message.
            let message = "Bharat Scan : Best Indian Document Scanning App Inspired by Atmnirbhar Bharat"
            //Set the link to share.
            if let link = NSURL(string: "https://www.apple.com/ios/app-store/")
            {
                let objectsToShare = [message,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            }
        }

        
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
            } else {
                self.view_rename.isHidden = true
                self.view_Alert.isHidden = true
            }
        }
        
    }

