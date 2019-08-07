//
//  CurrentDay.swift
//  kaist
//
//  Created by Airat K on 3/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


struct CurrentDay {
    
    private static let calendar = Calendar(identifier: .gregorian)
    private static let today = Date()
    
    
    public static var isWeekEven: Bool {
        let isCurrentSemesterFirst = self.calendar.component(.month, from: self.today) > 8
        
        let day = isCurrentSemesterFirst ? 1 : 26
        let month = isCurrentSemesterFirst ? 9 : 1
        
        let currentYear = self.calendar.component(.year, from: self.today)
        let currentWeekOfYear = self.calendar.component(.weekOfYear, from: self.today)
        
        // Cannot be even semantically as its index is equal to 1
        let firstWeekOfSemester = self.calendar.component(.weekOfYear, from: DateComponents(calendar: self.calendar, year: currentYear, month: month, day: day).date!)
        
        return currentWeekOfYear % 2 != firstWeekOfSemester % 2
    }
    
    public static var weekday: Int {
        return self.calendar.component(.weekday, from: Date()) - 1  // Sunday is the 1st one
    }
    
    public static var imageNameWeekday: String {
        return [ "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" ][self.weekday]
    }

    public static func date(shiftedToDays days: Int = 0) -> (Int, String) {
        let date = self.calendar.date(byAdding: .day, value: days, to: self.today)!
        let day = self.calendar.component(.day, from: date)
        let month = self.calendar.component(.month, from: date) - 1  // Array key, so decremented
        
        return (
            day, [
                "января", "февраля",
                "марта", "апреля", "мая",
                "июня", "июля", "августа",
                "сентября", "октября", "ноября",
                "декабря"
            ][month]
        )
    }

}
