//
//  DataFetchingError.swift
//  kaist
//
//  Created by Airat K on 18/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


enum DataFetchingError: String, Error {
    case onURLCreation = "Не удалось отправить запрос на сервера kai.ru"
    case noServerResponse = "Сайт kai.ru не отвечает"
    case onResponseParsing = "Не удалось обработать ответ от серверов kai.ru"
    case badServerResponse = "Нет данных"
    case noAskedGroupReceived = "Такой группы нет. Возможно, она появится позже, когда её внесут в каёвскую базу"
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
