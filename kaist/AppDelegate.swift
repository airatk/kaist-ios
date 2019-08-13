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
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = AppController()
        self.window?.makeKeyAndVisible()
        
        let loginNavigationController = UINavigationController(rootViewController: LoginScreen())
        
        loginNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        loginNavigationController.navigationBar.shadowImage = UIImage()
        
        self.window?.rootViewController?.present(loginNavigationController, animated: true)
        
        return true
    }
    
}
