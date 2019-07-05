//
//  LecturerData.swift
//  kaist
//
//  Created by Airat K on 4/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


// Getting Lecturer Name ID
//def get_lecturers_names(name_part):
//    try:
//        return get(LECTURERS_SCHEDULE_URL, params={
//            "p_p_id": "pubLecturerSchedule_WAR_publicLecturerSchedule10",
//            "p_p_lifecycle": "2",
//            "p_p_resource_id": "getLecturersURL",
//            "query": name_part
//        }).json()
//    except ConnectionError:
//        return None


// Getting classes & exams of lecturer
//def get_lecturers_schedule(prepod_login, type, weekday=None, next=False):
//    try:
//        response = post(url=LECTURERS_SCHEDULE_URL, params={
//            "p_p_id": "pubLecturerSchedule_WAR_publicLecturerSchedule10",
//            "p_p_lifecycle": "2",
//            "p_p_resource_id": "schedule" if type == "l-classes" else "examSchedule"
//        }, data={
//            "prepodLogin": prepod_login
//        }).json()
//    except ConnectionError:
//        return [ "Сайт kai.ru не отвечает🤷🏼‍♀️" ]
//
//    if not response: return [ "Нет данных." ]
//
//    return beautify_lecturers_classes(response, next) if type == "l-classes" else beautify_lecturers_exams(response)
