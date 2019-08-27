//
//  LecturerData.swift
//  kaist
//
//  Created by Airat K on 4/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


class LecturerData {

    private static let lecturersScheduleURLString: String = "https://kai.ru/for-staff/raspisanie"
    
    public typealias Lecturers = [[String: String]]
    public typealias Schedule = [String: [[String: String]]]
    
    
    public static func getLecturers(startingWith namePart: String,
      _ completion: @escaping (LecturerData.Lecturers?, DataFetchingError?) -> Void) {
        let parameters = "?" + [
            "p_p_id": "pubLecturerSchedule_WAR_publicLecturerSchedule10",
            "p_p_lifecycle": "2",
            "p_p_resource_id": "getLecturersURL",
            "query": namePart
        ].map {
            "\($0)=\($1)"
        } .joined(separator: "&")
        
        guard let url = URL(dataRepresentation: parameters.data(using: .utf8)!, relativeTo: URL(string: self.lecturersScheduleURLString)) else {
            completion(nil, .onURLCreation)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                completion(nil, .noServerResponse)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? LecturerData.Lecturers else {
                completion(nil, .onResponseParsing)
                return
            }
            
            guard !json.isEmpty else {
                completion(nil, .badServerResponse)
                return
            }
            
            completion(json, nil)
        } .resume()
    }
    
    public static func getSchedule(ofLecturerWithID lecturerID: String, ofType type: ScheduleType,
      _ completion: @escaping (LecturerData.Schedule?, DataFetchingError?) -> Void) {
        let parameters = "?" + [
            "p_p_id": "pubLecturerSchedule_WAR_publicLecturerSchedule10",
            "p_p_lifecycle": "2",
            "p_p_resource_id": type.rawValue,
            "prepodLogin": lecturerID
        ].map {
            "\($0)=\($1)"
        } .joined(separator: "&")
        
        guard let url = URL(dataRepresentation: parameters.data(using: .utf8)!, relativeTo: URL(string: self.lecturersScheduleURLString)) else {
            completion(nil, .onURLCreation)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                completion(nil, .noServerResponse)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: [[String: Any]]] else {
                completion(nil, .onResponseParsing)
                return
            }
            
            guard !json.isEmpty else {
                completion(nil, .badServerResponse)
                return
            }
            
            /* Fixing the bad quality data *** */
            
            // Casting Any to String & removing extra whitespaces
            var schedule = LecturerData.Schedule()

            for (numberOfDay, subjects) in json {
                schedule[numberOfDay] = []
                
                for (indexOfSubject, subject) in subjects.enumerated() {
                    schedule[numberOfDay]?.append([:])
                    
                    for (property, value) in subject {
                        var stringValue = String()
                        
                        switch value {
                            case let anyValue where anyValue as? String != nil: stringValue = value as! String
                            case let anyValue where anyValue as? Int != nil: stringValue = String(value as! Int)  // Losing prefix 0s?
                            
                            default: break
                        }
                        
                        schedule[numberOfDay]![indexOfSubject][property] = stringValue.split(separator: " ").joined(separator: " ")
                    }
                }
            }

            // Beautifying the data
            let calendar = Calendar(identifier: .gregorian)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            for (numberOfDay, subjects) in schedule {
                for (indexOfSubject, subject) in subjects.enumerated() {
                    // Beautifying the type data
                    switch subject["disciplType"] {
                        case "лек": schedule[numberOfDay]![indexOfSubject]["disciplType"] = "лекция"
                        case "пр": schedule[numberOfDay]![indexOfSubject]["disciplType"] = "практика"
                        case "л.р.": schedule[numberOfDay]![indexOfSubject]["disciplType"] = "лабораторная работа"

                        default: break
                    }

                    // Beautifying the time data
                    let time = subject["dayTime"]!.split(separator: ":").map { Int($0) }

                    let beginTime = calendar.date(from: DateComponents(calendar: calendar, hour: time[0], minute: time[1]))!
                    let endTime = calendar.date(byAdding: DateComponents(hour: 1, minute: 30), to: beginTime)!

                    let begin = dateFormatter.string(from: beginTime)
                    let end = dateFormatter.string(from: endTime)

                    schedule[numberOfDay]![indexOfSubject]["dayTime"] = "с " + begin + " до " + end

                    // Beautifying the building data
                    schedule[numberOfDay]![indexOfSubject]["buildNum"] = "в " + subject["buildNum"]!

                    if subject["buildNum"]!.rangeOfCharacter(from: .decimalDigits) != nil {
                        schedule[numberOfDay]![indexOfSubject]["buildNum"]! += "ке"
                    }
                }
            }
            
            completion(schedule, nil)
        } .resume()
    }

}
