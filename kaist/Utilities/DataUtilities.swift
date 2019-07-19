//
//  DataFetchingError.swift
//  kaist
//
//  Created by Airat K on 18/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


enum DataFetchingError: Error {
    case onURLCreation
    case noServerResponse
    case onResponseParsing
    case badServerResponse
}

enum ScheduleType: String {
    case classes = "schedule"
    case exams = "examSchedule"
}

enum DataType: String {
    case years = "p_kurs"
    case groups = "p_group"
    case names = "p_stud"
}
