//
//  AppDelegate.swift
//  BharatScan
//
//  Created by KUMAR GAURAV on 18/07/20.
//  Copyright © 2020 KUMAR GAURAV. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        defaults.set(false, forKey: "isLoggedIn")
        UIApplication.shared.statusBarStyle = .lightContent
        window?.overrideUserInterfaceStyle = .light
        return true
    }

}

