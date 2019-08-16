//
//  AppController.swift
//  kaist
//
//  Created by Airat K on 1/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class AppController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = CurrentDay.date()
        let dateTitle = "\(currentDate.day) \(currentDate.month)"
        
        self.viewControllers = [
            self.getTab(for: StudentSubjectsScreen(), withTitle: dateTitle, withImageNamed: CurrentDay.imageNameWeekday),
            self.getTab(for: ScoreScreen(), withTitle: "Баллы", withImageNamed: "score"),
            self.getTab(for: MapScreen(), withTitle: "Карта", withImageNamed: "map"),
            self.getTab(for: SettingsScreen(), withTitle: "Настройки", withImageNamed: "settings")
        ]
    }
    
    
    private func getTab(for screen: UIViewController, withTitle title: String, withImageNamed imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: screen)
        
        navigationController.view.backgroundColor = .white
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
        
        return navigationController
    }
    
}
