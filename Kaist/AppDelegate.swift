//
//  AppDelegate.swift
//  Kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = AppController()
        self.window?.makeKeyAndVisible()

        return true
    }

}
