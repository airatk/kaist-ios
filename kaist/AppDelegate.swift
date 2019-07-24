//
//  AppDelegate.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = Main()
        self.window?.makeKeyAndVisible()
        
        // Status bar
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBarView = statusBarWindow.subviews.first! as UIView
        statusBarView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.825)
        
        return true
    }

}
