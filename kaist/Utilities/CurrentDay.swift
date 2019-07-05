//
//  CurrentDay.swift
//  kaist
//
//  Created by Airat K on 3/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


func getCurrentWeekday() -> String {
    let weekday = Calendar(identifier: .gregorian).component(.weekday, from: Date()) - 1  // Array key, so decremented.
    
    let weekdays = [ "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" ]

    return weekdays[weekday]
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

func isCurrentWeekEven() -> Bool {
    let calendar = Calendar(identifier: .gregorian)
    let date = Date()
    
    let isCurrentSemesterFirst = calendar.component(.month, from: date) > 8
    
    let day = isCurrentSemesterFirst ? 1 : 26
    let month = isCurrentSemesterFirst ? 9 : 1
    let currentYear = calendar.component(.year, from: date)
    
    let firstWeekOfSemester = calendar.component(.weekOfYear, from: DateComponents(calendar: calendar, year: currentYear, month: month, day: day).date!)  // Cannot be even (the index == 1)
    
    return calendar.component(.weekOfYear, from: date) % 2 != firstWeekOfSemester % 2
}
