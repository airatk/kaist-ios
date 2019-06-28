//
//  ScheduleScreen.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit

class ScheduleScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentWeekdayTabBarItemImage()
    }
    
    func setCurrentWeekdayTabBarItemImage() {
        let weekday = Calendar(identifier: .gregorian).component(.weekday, from: Date()) - 1
        let weekdayName: String
        
        switch weekday {
            case 1: weekdayName = "monday"
            case 2: weekdayName = "tuesday"
            case 3: weekdayName = "wednesday"
            case 4: weekdayName = "thursday"
            case 5: weekdayName = "friday"
            case 6: weekdayName = "saterday"
            
            // If weekday == 0 or > 6, say today's Sunday.
            // The 1st comparsion is normal, the 2nd one is to make switch exhaustive.
            // Gregorian Calendar starts with Sunday.
            default: weekdayName = "sunday"
        }
        
        tabBarItem.image = UIImage(named: weekdayName)
    }

}
