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

        self.dates = try container.decode(String.self, forKey: .dayDate).trimmingCharacters(in: .whitespaces)

        let auditorium = try container.decode(String.self, forKey: .audNum).trimmingCharacters(in: .whitespaces)
        self.auditorium = auditorium.contains("----") ? "" : auditorium

        self.discipline = try container.decode(String.self, forKey: .disciplName).trimmingCharacters(in: .whitespacesAndNewlines)

        let building = try container.decode(String.self, forKey: .buildNum).trimmingCharacters(in: .whitespaces)
        self.building = building.contains("----") ? "" : building

        self.departmentUnit = try container.decode(String.self, forKey: .orgUnitName).trimmingCharacters(in: .whitespacesAndNewlines)
        self.startTime = try container.decode(String.self, forKey: .dayTime).trimmingCharacters(in: .whitespaces)
        self.weekday = try container.decode(String.self, forKey: .dayNum).trimmingCharacters(in: .whitespaces)
        self.isJoint = !(try container.decode(String.self, forKey: .potok).isEmpty)
        self.lecturer = try container.decode(String.self, forKey: .prepodName).trimmingCharacters(in: .whitespaces).capitalized

        let rawClassType = try container.decode(String.self, forKey: .disciplType).trimmingCharacters(in: .whitespaces)
        self.type = classTypeMapping[rawClassType, default: rawClassType]
    }

}


let classTypeMapping: [String: String] = [
    "лек": "лекция",
    "пр": "практика",
    "л.р.": "лабораторная работа",
    "конс": "консультация",
]