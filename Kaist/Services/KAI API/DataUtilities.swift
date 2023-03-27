//
//  DataFetchingError.swift
//  Kaist
//
//  Created by Airat K on 18/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


enum DataFetchingError: String, Error {
    case onURLCreation = "Не удалось отправить запрос на сервера КАИ"
    case noServerResponse = "Сайт КАИ не отвечает"
    case onResponseParsing = "Не удалось обработать ответ от серверов КАИ"
    case badServerResponse = "В каёвской базе нет соответсвующих данных"
    case noAskedGroupReceived = "Такой группы нет. Возможно, она появится позже, когда её внесут в каёвскую базу"
}

enum ScheduleType: String {
    case classes = "schedule"
    case exams = "examSchedule"
}
