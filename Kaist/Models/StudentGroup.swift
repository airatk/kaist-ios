//
//  EducationalGroup.swift
//  Kaist
//
//  Created by Airat K on 28/3/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import Foundation


struct StudentGroup: Decodable {

    let scheduleId: String
    let groupNumber: String

    enum CodingKeys: String, CodingKey {

        case id
        case group

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.scheduleId = String(try container.decode(Int.self, forKey: .id))
        self.groupNumber = try container.decode(String.self, forKey: .group)
    }

}
