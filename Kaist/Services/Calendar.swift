//
//  Calendar.swift
//  Kaist
//
//  Created by Airat K on 3/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


class CalendarService {

    static let localizedMonths: [String] = [
        "января",
        "февраля",
        "марта",
        "апреля",
        "мая",
        "июня",
        "июля",
        "августа",
        "сентября",
        "октября",
        "ноября",
        "декабря",
    ]
    static let localizedWeekdays: [String] = [
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота",
        "Воскресенье",
    ]
    static let weekdayImageNames: [String] = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
    ]

    private static let calendar: Calendar = Calendar(identifier: .gregorian)

}

extension CalendarService {

    static var currentWeekdayImageName: String {
        return self.weekdayImageNames[self.getWeekdayIndex()]
    }


    static func getWeekdayIndex(ofDate date: Date = Date()) -> Int {
        let weekday = self.calendar.component(.weekday, from: date) - 2

        return (weekday != -1) ? weekday : 6
    }

    static func getDate(shiftedRaltiveToTodayByDays days: Int = 0) -> DateData {
        let date: Date = self.calendar.date(byAdding: .day, value: days, to: Date())!

        let day: Int = self.calendar.component(.day, from: date)
        let monthIndex: Int = self.calendar.component(.month, from: date) - 1
        let weekdayIndex: Int = self.getWeekdayIndex(ofDate: date)

        return DateData(day: day, localizedMonth: self.localizedMonths[monthIndex], localizedWeekday: self.localizedWeekdays[weekdayIndex])
    }

    static func checkIfWeekIsEven(forDate date: Date = Date()) -> Bool {
        let year: Int = self.calendar.component(.year, from: date)
        let firstDayOfYear: Date = self.calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let timeInterval: Int = Int(floor((date.timeIntervalSince1970 - firstDayOfYear.timeIntervalSince1970) / 8.64e7))
        let weekNumber: Int = Int(floor(Double(timeInterval + self.getWeekdayIndex(ofDate: firstDayOfYear)) / 7.0))

        return weekNumber % 2 == 0
    }

}


struct DateData {

    let day: Int
    let localizedMonth: String
    let localizedWeekday: String

}
