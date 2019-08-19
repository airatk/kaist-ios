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
    var statusBarBlur: UIView!
    
    public let student = Student()
    
    public static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: - Window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = AppController()
        self.window?.makeKeyAndVisible()
        
        // MARK: - Status Bar
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        
        self.statusBarBlur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        self.statusBarBlur.frame = UIApplication.shared.statusBarFrame
        self.statusBarBlur.isHidden = true
        
        statusBarWindow.addSubview(self.statusBarBlur)
        statusBarWindow.sendSubviewToBack(self.statusBarBlur)
        
        
        return true
    }
    
}
