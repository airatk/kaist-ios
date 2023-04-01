//
//  Student.swift
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

    var isSignedIn: Bool {
        self.userDefaults.string(forKey: self.groupNumberKey) != nil && self.userDefaults.string(forKey: self.groupScheduleIdKey) != nil
    }

    func signOut() {
        self.userDefaults.removeObject(forKey: self.groupNumberKey)
        self.userDefaults.removeObject(forKey: self.groupScheduleIdKey)
    }

}

extension StudentApiService {

    func saveGroup(withNumber groupNumber: String, onComplete handleCompletion: @escaping NoContentResponseHandler) {
        let url: URL = self.makeUrlWithQuery(queryItems:
            URLQueryItem(name: "p_p_id", value: "pubStudentSchedule_WAR_publicStudentSchedule10"),
            URLQueryItem(name: "p_p_lifecycle", value: "2"),
            URLQueryItem(name: "p_p_resource_id", value: "getGroupsURL"),
            URLQueryItem(name: "query", value: groupNumber)
        )

        self.get(from: url) { (groups: [EducationalGroup]?, error: DataFetchError?) in
            if let error = error {
                handleCompletion(error)
                return
            }

            guard let groups = groups, groups.count == 1, let group = groups.first else {
                handleCompletion(.onServerError)
                return
            }

            self.groupNumber = group.number
            self.groupScheduleId = group.scheduleId

            handleCompletion(nil)
        }
    }

    func getSchedule(ofType scheduleType: ScheduleType, onComplete handleCompletion: @escaping ContentResponseHandler<Schedule<StudentClass>>) {
        let url: URL = self.makeUrlWithQuery(queryItems:
            URLQueryItem(name: "p_p_id", value: "pubStudentSchedule_WAR_publicStudentSchedule10"),
            URLQueryItem(name: "p_p_lifecycle", value: "2"),
            URLQueryItem(name: "p_p_resource_id", value: scheduleType.rawValue),
            URLQueryItem(name: "groupId", value: self.groupScheduleId)
        )

        self.get(from: url) { (schedule: Schedule<StudentClass>?, error: DataFetchError?) in
            if let error = error {
                handleCompletion(nil, error)
                return
            }

            guard let schedule = schedule, !schedule.isEmpty else {
                handleCompletion(nil, .onServerError)
                return
            }

            handleCompletion(schedule, nil)
        }
    }

}
