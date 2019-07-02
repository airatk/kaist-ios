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
        screen.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
        
        return screen
    }
    
}

// Setup functions of the 1st tab bar item
extension Main {

    private func getCurrentWeekday() -> String {
        let weekday = Calendar(identifier: .gregorian).component(.weekday, from: Date()) - 1  // Array key, so decremented.
        let weekdays = [ "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saterday" ]
        
        return weekdays[weekday]
    }
    
    private func getCurrentDate() -> String {
        let day = Calendar(identifier: .gregorian).component(.day, from: Date())
        let month = Calendar(identifier: .gregorian).component(.month, from: Date()) - 1  // Array key, so decremented.
        
        let months = [
            "января", "февраля",
            "марта", "апреля", "мая",
            "июня", "июля", "августа",
            "сентября", "октября", "ноября",
            "декабря"
        ]
        
        return "\(day) \(months[month])"
    }
    
}
