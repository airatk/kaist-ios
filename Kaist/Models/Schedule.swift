//
//  Schedule.swift
//  Kaist
//
//  Created by Airat K on 31/3/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import Foundation


struct Schedule<Class: Decodable>: Decodable {

    let monday: [Class]
    let tuesday: [Class]
    let wednesday: [Class]
    let thursday: [Class]
    let friday: [Class]
    let saturday: [Class]

    enum CodingKeys: String, CodingKey {

        case monday = "1"
        case tuesday = "2"
        case wednesday = "3"
        case thursday = "4"
        case friday = "5"
        case saturday = "6"

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.monday = (try? container.decode([Class].self, forKey: .monday)) ?? []
        self.tuesday = (try? container.decode([Class].self, forKey: .tuesday)) ?? []
        self.wednesday = (try? container.decode([Class].self, forKey: .wednesday)) ?? []
        self.thursday = (try? container.decode([Class].self, forKey: .thursday)) ?? []
        self.friday = (try? container.decode([Class].self, forKey: .friday)) ?? []
        self.saturday = (try? container.decode([Class].self, forKey: .saturday)) ?? []
    }

}

extension Schedule {

    subscript(index: Int) -> [Class]? {
        switch index {
        case 0: return self.monday
        case 1: return self.tuesday
        case 2: return self.wednesday
        case 3: return self.thursday
        case 4: return self.friday
        case 5: return self.saturday
        
        default: return nil
        }
    }

    var isEmpty: Bool {
        return (
            self.monday.isEmpty &&
            self.tuesday.isEmpty &&
            self.wednesday.isEmpty &&
            self.thursday.isEmpty &&
            self.friday.isEmpty &&
            self.saturday.isEmpty
        )
    }

}
