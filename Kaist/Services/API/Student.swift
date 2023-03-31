//
//  StudentApiService.swift
//  Kaist
//
//  Created by Airat K on 12/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


class StudentApiService: BaseKaiApiService {

    static let client: StudentApiService = StudentApiService()

    private let groupNumberKey: String = "groupNumber"
    private let groupScheduleIdKey: String = "groupScheduleId"

    var groupNumber: String? {
        get { return self.userDefaults.string(forKey: self.groupNumberKey) }
        set { self.userDefaults.set(newValue, forKey: self.groupNumberKey) }
    }
    var groupScheduleId: String? {
        get { return self.userDefaults.string(forKey: self.groupScheduleIdKey) }
        set { self.userDefaults.set(newValue, forKey: self.groupScheduleIdKey) }
    }

    var isSetUp: Bool {
        self.userDefaults.string(forKey: self.groupScheduleIdKey) != nil
    }

    func signOut() {
        self.userDefaults.removeObject(forKey: self.groupNumberKey)
        self.userDefaults.removeObject(forKey: self.groupScheduleIdKey)
    }

}

extension StudentApiService {

    typealias StudentSchedule = [String: [StudentClass]]

}

extension StudentApiService {

    func getGroup(onComplete handleCompletion: @escaping ContentResponseHandler<StudentGroup>) {
        let url: URL = self.makeUrlWithQuery(queryItems:
            URLQueryItem(name: "p_p_id", value: "pubStudentSchedule_WAR_publicStudentSchedule10"),
            URLQueryItem(name: "p_p_lifecycle", value: "2"),
            URLQueryItem(name: "p_p_resource_id", value: "getGroupsURL"),
            URLQueryItem(name: "query", value: self.groupNumber)
        )

        self.get(from: url) { (groups: [StudentGroup]?, error: DataFetchErrorType?) in
            if let error = error {
                DispatchQueue.main.async { handleCompletion(nil, error) }
                return
            }

            guard let groups = groups, groups.count == 1, let group = groups.first else {
                DispatchQueue.main.async { handleCompletion(nil, .onServerError) }
                return
            }

            handleCompletion(group, nil)
        }
    }

    func getSchedule(ofType scheduleType: ScheduleType, onComplete handleCompletion: @escaping ContentResponseHandler<StudentSchedule>) {
        let url: URL = self.makeUrlWithQuery(queryItems:
            URLQueryItem(name: "p_p_id", value: "pubStudentSchedule_WAR_publicStudentSchedule10"),
            URLQueryItem(name: "p_p_lifecycle", value: "2"),
            URLQueryItem(name: "p_p_resource_id", value: scheduleType.rawValue),
            URLQueryItem(name: "groupId", value: self.groupScheduleId)
        )

        self.get(from: url) { (schedule: StudentSchedule?, error: DataFetchErrorType?) in
            if let error = error {
                handleCompletion(nil, error)
                return
            }

            guard var schedule = schedule, !schedule.isEmpty else {
                handleCompletion(nil, .onServerError)
                return
            }

            for numberOfDay in CalendarService.Weekdays.allCases where schedule[numberOfDay.rawValue] == nil {
                schedule[numberOfDay.rawValue] = []
            }

            handleCompletion(schedule, nil)
        }
    }

}
