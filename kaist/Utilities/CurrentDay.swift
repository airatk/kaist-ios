//
//  CurrentDay.swift
//  kaist
//
//  Created by Airat K on 3/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


struct CurrentDay {
    
    private static let months = [ "января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря" ]
    private static let weekdays = [ "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" ]
    
    
    public static var isWeekEven: Bool {
        var calendar = Calendar(identifier: .gregorian)
        let date = Date()
        
        // Setting Monday to be the 1st day of a week
        calendar.firstWeekday = 2
        
        let isCurrentSemesterFirst = calendar.component(.month, from: date) > 8
        
        let day = isCurrentSemesterFirst ? 1 : 26
        let month = isCurrentSemesterFirst ? 9 : 1
        
        let currentYear = calendar.component(.year, from: date)
        let currentWeekOfYear = calendar.component(.weekOfYear, from: date)
        
        // Cannot be even semantically as its index is equal to 1
        let firstWeekOfSemester = calendar.component(.weekOfYear, from: DateComponents(calendar: calendar, year: currentYear, month: month, day: day).date!)
        
        return currentWeekOfYear % 2 != firstWeekOfSemester % 2
    }
    
    public static var imageNameWeekday: String {
        return self.weekdays[Calendar(identifier: .gregorian).component(.weekday, from: Date()) - 1]  // Array key, so decremented
    }

    public static func date(shiftedToDays days: Int = 0) -> (Int, String) {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(byAdding: .day, value: days, to: Date())!
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date) - 1  // Array key, so decremented
        
        return (day, self.months[month])
    }

}
