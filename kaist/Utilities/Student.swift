//
//  Student.swift
//  kaist
//
//  Created by Airat K on 12/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation
import SwiftSoup


class Student {
    
    private var instituteName: String?
    private var instituteID: String?
    
    public let institutes: [String?: String] = [
        "ИАНТЭ": "1", "ФМФ": "2", "ИАЭП": "3",
        "ИКТЗИ": "4", "ИРЭТ": "5", "ИЭУСТ": "28"
    ]
    
    public var institute: String? {
        get { return self.instituteName }
        set {
            guard institutes.index(forKey: newValue) != nil else { return }
            
            self.instituteName = newValue
            self.instituteID = self.institutes[newValue]
        }
    }
    
    public var year: String?
    
    private var groupNumber: String?
    private var groupScheduleID: String?
    private var groupScoreID: String?
    
    public var group: String? {
        get { return self.groupNumber }
        set {
            self.groupNumber = newValue
            guard let groupNumber = newValue else { return }
            
            self.getGroupScheduleID { (scheduleID, error) in
                guard error == nil, let scheduleID = scheduleID else { return }
                
                self.groupScheduleID = scheduleID
            }
            
            self.getData(ofType: .groups) { (groups, error) in
                guard error == nil, let groups = groups, groups.index(forKey: groupNumber) != nil else { return }

                self.groupScoreID = groups[groupNumber]
            }
            
            if self.groupScheduleID == nil || self.groupScoreID == nil {
                self.groupNumber = nil
                self.groupScheduleID = nil
                self.groupScoreID = nil
            }
        }
    }
    
    private var fullName: String?
    private var ID: String?
    private var fellowStudentsNames: [String: String]?
    
    public var name: String? {
        get { return self.fullName }
        set {
            self.fullName = newValue
            
            guard let studentName = newValue else { return }
            
            self.getData(ofType: .names) { (names, error) in
                guard error == nil, let names = names, names.index(forKey: studentName) != nil else { return }
                
                self.ID = names[studentName]
                self.fellowStudentsNames = names
            }
        }
    }
    
    public var card: String?
    
    
    public var isSetUp: Bool {
        return (
            self.institute != nil &&
            self.year != nil &&
            self.group != nil &&
            self.name != nil &&
            self.card != nil
        )
    }
    
    
    public func setUserDefaults() {
        self.groupScheduleID = "17896"
    }
    
    
    private let scheduleURLString: String = "https://kai.ru/raspisanie"
    private let scoreURLString: String = "http://old.kai.ru/info/students/brs.php"
    
    
    public func getSchedule(ofType type: ScheduleType,
      _ completion: @escaping ([String: [[String: String]]]?, DataFetchingError?) -> Void) {
        let parameters = [
            "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
            "p_p_lifecycle": "2",
            "p_p_resource_id": type.rawValue,
            "p_p_col_count": "1",
            "groupId": self.groupScheduleID ?? ""
        ]
        
        guard let url = URL(string: self.scheduleURLString + "?" + parameters.toURLParametersString()) else {
            completion(nil, .onURLCreation)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                DispatchQueue.main.async { completion(nil, .noServerResponse) }
                return
            }
            
            guard var schedule = try? JSONSerialization.jsonObject(with: data) as? [String: [[String: String]]] else {
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
                    let endTime = calendar.date(byAdding: DateComponents(hour: 1, minute: 30), to: beginTime)!
                    
                    let begin = dateFormatter.string(from: beginTime)
                    let end = dateFormatter.string(from: endTime)
                    
                    schedule[numberOfDay]![indexOfSubject]["dayTime"] = "с " + begin + " до " + end
                    
                    // Beautifying the building data
                    var building = subject["buildNum"]!

                    switch building {
                        case _ where building.rangeOfCharacter(from: .decimalDigits) != nil: building += "ке"
                        case _ where building == "КАИ ОЛИМП": building = "СК «Олимп»"
                        
                        default: break
                    }
                    
                    schedule[numberOfDay]![indexOfSubject]["buildNum"] = "в " + building
                }
            }
            
            // Making all of 6 official educational days available for access
            for numberOfDay in [ "1", "2", "3", "4", "5", "6" ] {
                if schedule[numberOfDay] == nil {
                    schedule[numberOfDay] = [ ["disciplName": "Выходной"] ]
                }
            }
            
            DispatchQueue.main.async { completion(schedule, nil) }
        } .resume()
    }
    
    public func getScoretable(forSemester semester: Int,
      _ completion: @escaping ([[String]]?, DataFetchingError?) -> Void) {
        let parameters = [
            "p_sub": "",  // Unknown nonsense thing which is necessary
            "p_fac": self.instituteID ?? "",
            "p_kurs": self.year ?? "",
            "p_group": self.groupScoreID ?? "",
            "p_stud": self.ID ?? "",
            "p_zach": self.card ?? "",
            "semestr": "\(semester)"
        ]
        
        guard let url = URL(string: self.scoreURLString) else {
            completion(nil, .onURLCreation)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.toURLParametersString().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                completion(nil, .noServerResponse)
                return
            }
            
            guard let page = String(data: data, encoding: .windowsCP1251) else {
                completion(nil, .badServerResponse)
                return
            }
            
            do {
                let document = try SwiftSoup.parse(page)
                
                let tables = try document.getElementsByAttributeValue("id", "reyt")
                guard let table = tables.first() else { throw DataFetchingError.onResponseParsing }
                
                var subjects = [[String]]()
                var subject = [String]()
                
                for tableRow in try table.getElementsByTag("tr") {
                    for tableData in try tableRow.getElementsByTag("td") where !(try tableData.text()).isEmpty {
                        subject.append(try tableData.text())
                    }
                    
                    subjects.append(subject)
                    subject = []
                }
                
                subjects = Array(subjects[2...])
                
                guard !subjects.isEmpty else { throw DataFetchingError.badServerResponse }
                
                completion(subjects, nil)
            } catch DataFetchingError.badServerResponse {
                completion(nil, .badServerResponse)
            } catch {
                completion(nil, .onResponseParsing)
            }
        } .resume()
    }
    
    public func getLastAvailableSemester(_ completion: @escaping (Int?, DataFetchingError?) -> Void) {
        let parameters = [
            "p_sub": "",  // Unknown nonsense thing which is necessary
            "p_fac": self.instituteID ?? "",
            "p_kurs": self.year ?? "",
            "p_group": self.groupScoreID ?? "",
            "p_stud": self.ID ?? "",
            "p_zach": self.card ?? ""
        ]
        
        guard let url = URL(string: self.scoreURLString) else {
            completion(nil, .onURLCreation)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.toURLParametersString().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                completion(nil, .noServerResponse)
                return
            }
            
            guard let page = String(data: data, encoding: .windowsCP1251) else {
                completion(nil, .badServerResponse)
                return
            }
            
            do {
                let document = try SwiftSoup.parse(page)
                
                let selectors = try document.getElementsByAttributeValue("name", "semestr")
                guard let selector = selectors.first() else { throw DataFetchingError.onResponseParsing }
                
                let options = Array(try selector.getElementsByTag("option"))
                guard !options.isEmpty else { throw DataFetchingError.onResponseParsing }
                
                let semesters = try options.map { try $0.attr("value") }
                guard !semesters.isEmpty else { throw DataFetchingError.badServerResponse }
                
                guard let lastSemester = semesters.max() else { throw DataFetchingError.badServerResponse }
                
                completion(Int(lastSemester), nil)
            } catch DataFetchingError.badServerResponse {
                completion(nil, .badServerResponse)
            } catch {
                completion(nil, .onResponseParsing)
            }
        } .resume()
    }
    
    public func getData(ofType type: DataType,
      _ completion: @escaping ([String: String]?, DataFetchingError?) -> Void) {
        let parameters: [String: String] = [
            "p_fac": self.instituteID ?? "",
            "p_kurs": self.year ?? "",
            "p_group": self.groupScoreID ?? ""
        ]
        
        guard let url = URL(string: self.scoreURLString + "?" + parameters.toURLParametersString()) else {
            completion(nil, .onURLCreation)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                completion(nil, .noServerResponse)
                return
            }
            
            guard let page = String(data: data, encoding: .windowsCP1251) else {
                completion(nil, .onResponseParsing)
                return
            }
            
            do {
                let document = try SwiftSoup.parse(page)
                
                let selectors = try document.getElementsByAttributeValue("name", type.rawValue)
                guard let selector = selectors.first() else { throw DataFetchingError.onResponseParsing }
                
                var options = Array(try selector.getElementsByTag("option"))
                guard !options.isEmpty else { throw DataFetchingError.onResponseParsing }
                options.removeFirst()
                
                var studentData: [String: String] = [:]
                
                for option in options {
                    let key = try option.text()
                    let value = try option.attr("value")
                
                    studentData[key] = value
                }
                
                guard !studentData.isEmpty else { throw DataFetchingError.badServerResponse }
                
                completion(studentData, nil)
            } catch DataFetchingError.badServerResponse {
                completion(nil, .badServerResponse)
            } catch {
                completion(nil, .onResponseParsing)
            }
        } .resume()
    }
    
    
    private func getGroupScheduleID(_ completion: @escaping (String?, DataFetchingError?) -> Void) {
        let parameters = [
            "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
            "p_p_lifecycle": "2",
            "p_p_resource_id": "getGroupsURL",
            "query": self.groupNumber ?? ""
        ]
        
        guard let url = URL(string: self.scheduleURLString + "?" + parameters.toURLParametersString()) else {
            completion(nil, .onURLCreation)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                completion(nil, .noServerResponse)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                completion(nil, .onResponseParsing)
                return
            }
            
            guard let groupScheduleID = json.first?["id"] as? Int else {
                completion(nil, .badServerResponse)
                return
            }
            
            completion(String(groupScheduleID), nil)
        } .resume()
    }
    
}


extension Dictionary {

    func toURLParametersString() -> String {
        return self.map { "\($0)=\($1)" } .joined(separator: "&")
    }
    
}
