//
//  StudentClass.swift
//  Kaist
//
//  Created by Airat K on 28/3/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import Foundation


struct StudentClass: Decodable {

    let dates: String
    let auditorium: String
    let discipline: String
    let building: String
    let departmentUnit: String
    let startTime: String
    let weekday: String
    let isJoint: Bool
    let lecturer: String
    let type: String

    enum CodingKeys: CodingKey {

        case dayDate
        case audNum
        case disciplName
        case buildNum
        case orgUnitName
        case dayTime
        case dayNum
        case potok
        case prepodName
        case disciplType

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.dates = format(dates: try container.decode(String.self, forKey: .dayDate))
        self.auditorium = format(auditorium: try container.decode(String.self, forKey: .audNum))
        self.discipline = format(discipline: try container.decode(String.self, forKey: .disciplName))
        self.building = format(building: try container.decode(String.self, forKey: .buildNum))
        self.departmentUnit = format(departmentUnit: try container.decode(String.self, forKey: .orgUnitName))
        self.startTime = format(startTime: try container.decode(String.self, forKey: .dayTime))
        self.weekday = format(weekday: try container.decode(String.self, forKey: .dayNum))
        self.isJoint = format(isJoint: try container.decode(String.self, forKey: .potok))
        self.lecturer = format(lecturer: try container.decode(String.self, forKey: .prepodName))
        self.type = format(type: try container.decode(String.self, forKey: .disciplType))
    }

}


fileprivate func format(dates rawDates: String) -> String {
    return rawDates.trimmingCharacters(in: .whitespaces)
}

fileprivate func format(auditorium rawAuditorium: String) -> String {
    let formatted: String = rawAuditorium.trimmingCharacters(in: .whitespaces)

    guard !formatted.contains("----"), formatted != "КСК КАИ ОЛИМП" else { return "" }

    return "в аудитории \(formatted)"
}

fileprivate func format(discipline rawDiscipline: String) -> String {
    return rawDiscipline.trimmingCharacters(in: .whitespaces)
}

fileprivate func format(building rawBuilding: String) -> String {
    let formatted: String = rawBuilding.trimmingCharacters(in: .whitespaces)

    guard !formatted.contains("----") else { return "" }
    guard formatted != "КСК КАИ ОЛИМП" else { return "в КСК «Олимп»" }

    return "в \(formatted)ке"
}

fileprivate func format(departmentUnit rawDepartmentUnit: String) -> String {
    return rawDepartmentUnit.trimmingCharacters(in: .whitespaces)
}

fileprivate func format(startTime rawStartTime: String) -> String {
    let formatted: String = rawStartTime.trimmingCharacters(in: .whitespaces)

    return "с \(formatted)"
}

fileprivate func format(weekday rawWeekday: String) -> String {
    return rawWeekday.trimmingCharacters(in: .whitespaces)
}

fileprivate func format(isJoint rawIsJoint: String) -> Bool {
    return !rawIsJoint.trimmingCharacters(in: .whitespaces).isEmpty
}

fileprivate func format(lecturer rawLecturer: String) -> String {
    return rawLecturer.trimmingCharacters(in: .whitespaces).capitalized
}

fileprivate func format(type rawType: String) -> String {
    let formatted: String = rawType.trimmingCharacters(in: .whitespaces)

    return [
        "лек": "лекция",
        "пр": "практика",
        "л.р.": "лабораторная работа",
        "конс": "консультация",
    ][formatted, default: formatted]
}
