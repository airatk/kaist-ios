//
//  StudentClass.swift
//  Kaist
//
//  Created by Airat K on 28/3/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import Foundation


struct StudentClass: Decodable {

    let discipline: String
    let type: String
    let isJoint: Bool
    let isFullDay: Bool
    let departmentUnit: String
    let lecturer: String
    let auditorium: String
    let building: String
    let weekday: String
    let dates: String
    let startTime: String

    enum CodingKeys: CodingKey {

        case disciplName
        case disciplType
        case potok
        case disciplNum
        case orgUnitName
        case prepodName
        case audNum
        case buildNum
        case dayNum
        case dayDate
        case dayTime

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.discipline = format(discipline: try container.decode(String.self, forKey: .disciplName))
        self.type = format(type: try container.decode(String.self, forKey: .disciplType))
        self.isJoint = format(isJoint: try container.decode(String.self, forKey: .potok))
        self.isFullDay = format(isFullDay: try container.decode(String.self, forKey: .disciplNum))
        self.departmentUnit = format(departmentUnit: try container.decode(String.self, forKey: .orgUnitName))
        self.lecturer = format(lecturer: try container.decode(String.self, forKey: .prepodName))
        self.auditorium = format(auditorium: try container.decode(String.self, forKey: .audNum))
        self.building = format(building: try container.decode(String.self, forKey: .buildNum))
        self.weekday = format(weekday: try container.decode(String.self, forKey: .dayNum))
        self.dates = format(dates: try container.decode(String.self, forKey: .dayDate))
        self.startTime = format(startTime: try container.decode(String.self, forKey: .dayTime))
    }

}
