//
//  CurrentDay.swift
//  Kaist
//
//  Created by Airat K on 3/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


struct CalendarService {

    private static let calendar = Calendar(identifier: .gregorian)
    private static let today = Date()

    public static var isCurrentSemesterFirst: Bool {
        return self.calendar.component(.month, from: self.today) > 8
    }

    public static var isWeekEven: Bool {
        let firstDayOfSemester = DateComponents(
            calendar: self.calendar,
            year: self.calendar.component(.year, from: self.today),
            month: self.isCurrentSemesterFirst ? 9 : 1,
            day: self.isCurrentSemesterFirst ? 1 : 26
        ).date!

        // Sunday is the 1st weekday by default, so some fixes are needed
        let firstWeekOfSemester = self.calendar.component(.weekOfYear, from: firstDayOfSemester)  // Sunday does not count here
        let currentWeekOfYear = self.calendar.component(.weekOfYear, from: self.today) - (self.currentWeekday == 7 ? 1 : 0)

        // The 1st week of semester cannot be even semantically as its index is equal to 1
        return currentWeekOfYear % 2 != firstWeekOfSemester % 2
    }

    public static var currentWeekday: Int {
        let weekday = self.calendar.component(.weekday, from: self.today) - 1

        // Sunday is the 1st weekday by default, so need to throw it from 0 to 7.
        return weekday == 0 ? 7 : weekday
    }

    public static var imageNameWeekday: String {
        return [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ][self.currentWeekday - 1]
    }

    public static func date(shiftedToDays days: Int = 0) -> (day: Int, month: String, monthIndex: String) {
        let date = self.calendar.date(byAdding: .day, value: days, to: self.today)!

        let day = self.calendar.component(.day, from: date)
        let month = self.calendar.component(.month, from: date)

        return (
            day: day,
            month: [
                "января", "февраля", "марта", "апреля",
                "мая", "июня", "июля", "августа",
                "сентября", "октября", "ноября", "декабря"
            ][month - 1],
            monthIndex: [
                "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"
            ][month - 1]
        )
    }

}

extension CalendarService {

    enum Weekdays: String, Decodable, CaseIterable {

        case monday = "1"
        case tuesday = "2"
        case wednesday = "3"
        case thursday = "4"
        case friday = "5"
        case saterday = "6"

    }

}

extension CalendarService.Weekdays: Comparable {

    static func < (lhs: CalendarService.Weekdays, rhs: CalendarService.Weekdays) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

}
