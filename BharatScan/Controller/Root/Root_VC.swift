//
//  Root_VC.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 19/07/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 14.0, *)
class Root_VC: UIViewController {
    var player: AVPlayer?
    
    @IBOutlet weak var video_view: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name:
                                                NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        print("video ended")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Camera_VC") as! Camera_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadVideo()
    }
    
    private func loadVideo() {
        
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }
        
        let path = Bundle.main.path(forResource: "Splash", ofType:"m4v")
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        //        playerLayer.zPosition = -1
        self.view.layer.addSublayer(playerLayer)
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
}
