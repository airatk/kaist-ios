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
        
        self.viewControllers = [ getScheduleTab(), getSettingsTab() ]
    }
    
    func getScheduleTab() -> ScheduleScreen {
        let schedule = ScheduleScreen()
        let scheduleTabBarItem = UITabBarItem(title: getCurrentDate(), image: getCurrentWeekdayImage(), selectedImage: nil)
        
        schedule.tabBarItem = scheduleTabBarItem
        
        return schedule
    }
    
    func getSettingsTab() -> SettingsScreen {
        let settings = SettingsScreen()
        let settingsTabBarItem = UITabBarItem(title: "Настройки", image: UIImage(named: "settings"), selectedImage: nil)
        
        settings.tabBarItem = settingsTabBarItem
        
        return settings
    }
    
}

extension Main {

    func getCurrentWeekdayImage() -> UIImage {
        let weekday = Calendar(identifier: .gregorian).component(.weekday, from: Date()) - 1  // Array key, so decremented.
        let weekdayImageNames = [ "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saterday" ]
        
        return UIImage(named: weekdayImageNames[weekday])!
    }
    
    func getCurrentDate() -> String {
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
