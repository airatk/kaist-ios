//
//  DataTypes.swift
//  Kaist
//
//  Created by Airat K on 18/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


enum DataFetchError: LocalizedError {

    case onURLCreation
    case noServerResponse
    case onResponseParsing
    case onServerError

    case noSuchGroup
    case noScheduleData

    var errorDescription: String? {
        switch self {
        case .onURLCreation: return "Нет соединения с интернетом."
        case .noServerResponse: return "Не удалось получить данные."
        case .onResponseParsing: return "Не удалось обработать полученные данные. Обратитесь к разработчику."
        case .onServerError: return "Ошибка обработки запроса. Обратитесь к разработчику."

        case .noSuchGroup: return "Такой группы нет."
        case .noScheduleData: return "На kai.ru данных о твоём расписании нет."
        }
    }

}


enum ScheduleType: String {

    case classes = "schedule"
    case exams = "examSchedule"

}
