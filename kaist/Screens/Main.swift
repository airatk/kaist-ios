//
//  Main.swift
//  kaist
//
//  Created by Airat K on 1/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class Main: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false
        
        let currentDate = "\(CurrentDay.date.0), \(CurrentDay.date.1)"
        
        self.viewControllers = [
            self.getTab(for: ScheduleScreen(), withTitle: currentDate, withImageNamed: CurrentDay.weekday),
            self.getTab(for: ScoreScreen(), withTitle: "Баллы", withImageNamed: "score"),
            self.getTab(for: MapScreen(), withTitle: "Карта", withImageNamed: "map"),
            self.getTab(for: SettingsScreen(), withTitle: "Настройки", withImageNamed: "settings")
        ]
    }
    
    private func getTab(for screen: UIViewController, withTitle title: String, withImageNamed imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: screen)
        
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
        
        return navigationController
    }
    
}
