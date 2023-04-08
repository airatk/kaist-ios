//
//  Formaters.swift
//  Kaist
//
//  Created by Airat K on 8/4/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

func format(discipline rawDiscipline: String) -> String {
    return rawDiscipline.trimmingCharacters(in: .whitespaces)
}

func format(type rawType: String) -> String {
    let formatted: String = rawType.trimmingCharacters(in: .whitespaces)

    return [
        "лек": "лекция",
        "пр": "практика",
        "л.р.": "лабораторная работа",
        "конс": "консультация",
    ][formatted, default: formatted]
}

func format(isJoint rawIsJoint: String) -> Bool {
    return !rawIsJoint.trimmingCharacters(in: .whitespaces).isEmpty
}

func format(isFullDay rawIsFullDay: String) -> Bool {
    return rawIsFullDay.trimmingCharacters(in: .whitespaces) != "0"
}

func format(departmentUnit rawDepartmentUnit: String) -> String {
    return rawDepartmentUnit.trimmingCharacters(in: .whitespaces)
}

func format(lecturer rawLecturer: String) -> String {
    return rawLecturer.trimmingCharacters(in: .whitespaces).capitalized
}

func format(lecturerUsername rawLecturerUsername: String) -> String {
    return rawLecturerUsername.trimmingCharacters(in: .whitespaces)
}

func format(auditorium rawAuditorium: String) -> String {
    let formatted: String = rawAuditorium.trimmingCharacters(in: .whitespaces)

    guard !formatted.contains("----"), formatted != "КСК КАИ ОЛИМП" else { return "" }
    guard formatted != "актовый зал" else { return "в актовом зале" }
    guard !formatted.contains("лекционный зал") else { return formatted.replacingOccurrences(of: "лекционный зал", with: "в лекционном зале") }

    return "в аудитории \(formatted)"
}

func format(building rawBuilding: String) -> String {
    let formatted: String = rawBuilding.trimmingCharacters(in: .whitespaces)

    guard !formatted.contains("----") else { return "" }
    guard formatted != "КСК КАИ ОЛИМП" else { return "в КСК «Олимп»" }

    return "в \(formatted)ке"
}

func format(weekday rawWeekday: String) -> String {
    return rawWeekday.trimmingCharacters(in: .whitespaces)
}

func format(date rawDate: String) -> String {
    return rawDate.trimmingCharacters(in: .whitespaces)
}

func format(dates rawDates: String) -> String {
    var formatted: String = rawDates.trimmingCharacters(in: .whitespaces)
    
    formatted = formatted.replacingOccurrences(of: "/", with: " / ")
    formatted = formatted.split(separator: " ").filter { !$0.isEmpty } .joined(separator: " ")

    formatted = formatted.replacingOccurrences(of: "чет", with: "чётная")
    formatted = formatted.replacingOccurrences(of: "неч", with: "нечётная")

    return formatted
}

func format(startTime rawStartTime: String) -> String {
    let formatted: String = rawStartTime.trimmingCharacters(in: .whitespaces)

    return "с \(formatted)"
}
