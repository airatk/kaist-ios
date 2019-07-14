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
            getTab(for: ScheduleScreen(), withTitle: CurrentDay.date, withImage: CurrentDay.weekday),
            getTab(for: ScoreScreen(), withTitle: "Баллы", withImage: "score"),
            getTab(for: MapScreen(), withTitle: "Карта", withImage: "map"),
            getTab(for: SettingsScreen(), withTitle: "Настройки", withImage: "settings")
        ]
    }
    
    private func getTab(for screen: UIViewController, withTitle title: String, withImage image: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: screen)
        
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: image), selectedImage: nil)
        
        return navigationController
    }
    
}
