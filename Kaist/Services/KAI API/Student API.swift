//
//  Student.swift
//  Kaist
//
//  Created by Airat K on 12/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


class Student {

    public var groupNumber: String? {
        get { return UserDefaults.standard.string(forKey: "groupNumber") }
        set { UserDefaults.standard.set(newValue, forKey: "groupNumber") }
    }
    public var groupScheduleID: String? {
        get { return UserDefaults.standard.string(forKey: "groupScheduleID") }
        set { UserDefaults.standard.set(newValue, forKey: "groupScheduleID") }
    }
    public var isSetUp: Bool {
        UserDefaults.standard.string(forKey: "groupScheduleID") != nil
    }
    
    public func reset() {
        UserDefaults.standard.removeObject(forKey: "groupNumber")
        UserDefaults.standard.removeObject(forKey: "groupScheduleID")
    }

    private let scheduleURLString = "https://kai.ru/raspisanie"
    
    public typealias Schedule = [String: [[String: String]]]
    
    
    public func getGroupScheduleID(_ completion: @escaping (String?, DataFetchingError?) -> Void) {
        let parameters = "?" + [
            "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
            "p_p_lifecycle": "2",
            "p_p_resource_id": "getGroupsURL",
            "query": self.groupNumber ?? ""
        ].map {
            "\($0.key)=\($0.value)"
        } .joined(separator: "&")
        
        guard let url = URL(string: self.scheduleURLString + parameters) else {
            completion(nil, .onURLCreation)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                DispatchQueue.main.async { completion(nil, .noServerResponse) }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                DispatchQueue.main.async { completion(nil, .onResponseParsing) }
                return
            }
            
            guard json.count == 1 else {
                DispatchQueue.main.async { completion(nil, .noAskedGroupReceived) }
                return
            }
            
            guard let groupScheduleID = json.first?["id"] as? Int else {
                DispatchQueue.main.async { completion(nil, .badServerResponse) }
                return
            }
            
            DispatchQueue.main.async { completion(String(groupScheduleID), nil) }
        } .resume()
    }
    
    public func getSchedule(ofType type: ScheduleType,
      _ completion: @escaping (Student.Schedule?, DataFetchingError?) -> Void) {
        let parameters = "?" + [
            "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
            "p_p_lifecycle": "2",
            "p_p_resource_id": type.rawValue,
            "p_p_col_count": "1",
            "groupId": self.groupScheduleID ?? ""
        ].map {
            "\($0.key)=\($0.value)"
        } .joined(separator: "&")
        
        guard let url = URL(string: self.scheduleURLString + parameters) else {
            completion(nil, .onURLCreation)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                DispatchQueue.main.async { completion(nil, .noServerResponse) }
                return
            }
            
            guard var schedule = try? JSONSerialization.jsonObject(with: data) as? Student.Schedule else {
                DispatchQueue.main.async { completion(nil, .onResponseParsing) }
                return
            }
            
            guard !schedule.isEmpty else {
                DispatchQueue.main.async { completion(nil, .badServerResponse) }
                return
            }
            
            
            /* Fixing the bad quality data *** */
            
            // Removing extra whitespaces
            for (numberOfDay, subjects) in schedule {
                for (indexOfSubject, subject) in subjects.enumerated() {
                    for (property, value) in subject {
                        schedule[numberOfDay]![indexOfSubject][property] = value.split(separator: " ").joined(separator: " ")
                    }
                }
            }
            
            // Beautifying the data
            let calendar = Calendar(identifier: .gregorian)
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "HH:mm"
            
            for (numberOfDay, subjects) in schedule {
                for (indexOfSubject, subject) in subjects.enumerated() {
                    // Checking is a weekday
                    if subject["disciplName"]!.contains("День консультаций") || subject["disciplName"]!.contains("Военная подготовка") {
                        schedule[numberOfDay] = [ ["disciplName": "Выходной"] ]
                        break
                    }
                    
                    // Beautifying the type data
                    switch subject["disciplType"] {
                        case "лек": schedule[numberOfDay]![indexOfSubject]["disciplType"] = "лекция"
                        case "пр": schedule[numberOfDay]![indexOfSubject]["disciplType"] = "практика"
                        case "л.р.": schedule[numberOfDay]![indexOfSubject]["disciplType"] = "лабораторная работа"
                        case "конс": schedule[numberOfDay]![indexOfSubject]["disciplType"] = "консультация"
                        
                        default: break
                    }
                    
                    // Beautifying the lecturer name data
                    schedule[numberOfDay]![indexOfSubject]["prepodName"] = subject["prepodName"]!.capitalized
                    
                    // Beautifying the time data
                    let time = subject["dayTime"]!.split(separator: ":").map { Int($0) }
                    
                    let beginTime = calendar.date(from: DateComponents(calendar: calendar, hour: time[0], minute: time[1]))!
                    let endTime = calendar.date(byAdding: {
                        if subject["disciplType"] == "л.р." {
                            return DateComponents(hour: 3, minute: time[0] == 11 ? 40 : 10)
                        } else {
                            return DateComponents(hour: 1, minute: 30)
                        }
                    }(), to: beginTime)!
                    
                    let begin = dateFormatter.string(from: beginTime)
                    let end = dateFormatter.string(from: endTime)
                    
                    schedule[numberOfDay]![indexOfSubject]["dayTime"] = "с " + begin + " до " + end
                    
                    // Beautifying the building data
                    var building = subject["buildNum"]!

                    if building.rangeOfCharacter(from: .decimalDigits) != nil {
                        building += "ке"
                    }
                    
                    if building.contains("ОЛИМП") {
                        building = "СК Олимп"
                        schedule[numberOfDay]![indexOfSubject]["audNum"] = ""
                    }
                    
                    schedule[numberOfDay]![indexOfSubject]["buildNum"] = "в " + building
                }
            }
            
            // Making all of 6 official educational days available
            for numberOfDay in [ "1", "2", "3", "4", "5", "6" ] where schedule[numberOfDay] == nil {
                schedule[numberOfDay] = [ ["disciplName": "Выходной"] ]
            }
            
            DispatchQueue.main.async { completion(schedule, nil) }
        } .resume()
    }

}
