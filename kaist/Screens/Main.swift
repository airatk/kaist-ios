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
        
        self.viewControllers = [
            getTab(for: ScheduleScreen(), withTitle: getCurrentDate(), withImageNamed: getCurrentWeekday()),
            getTab(for: ScoreScreen(), withTitle: "Баллы", withImageNamed: "score"),
            getTab(for: MapScreen(), withTitle: "Карта", withImageNamed: "map"),
            getTab(for: SettingsScreen(), withTitle: "Настройки", withImageNamed: "settings")
        ]
    }
    
    private func getTab(for screen: UIViewController, withTitle title: String, withImageNamed imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: screen)
        
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
        
        return navigationController
    }
    
}
