//
//  AppDelegate.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = Main()
        self.window?.makeKeyAndVisible()
        
        
        // Status bar
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurEffectView.frame = UIApplication.shared.statusBarFrame
        
        statusBarWindow.addSubview(blurEffectView)
        statusBarWindow.sendSubviewToBack(blurEffectView)
        
        
        return true
    }
    
}
