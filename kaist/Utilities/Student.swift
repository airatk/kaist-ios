//
//  Student.swift
//  kaist
//
//  Created by Airat K on 12/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation
import SwiftSoup


extension Dictionary {

    func toURLParametersString() -> String {
        return self.map { "\($0)=\($1)" } .joined(separator: "&")
    }
    
}


class Student {
    
    private var instituteName: String?
    private var instituteID: String?
    
    public let institutes: [String?: String] = [
        "ИАНТЭ": "1", "ФМФ": "2", "ИАЭП": "3",
        "ИКТЗИ": "4", "ИРЭТ": "5", "ИЭУСТ": "28"
    ]
    
    public var institute: String? {
        get {
            return self.instituteName
        }
        set(instituteName) {
            guard institutes.index(forKey: instituteName) != nil else { return }
            
            self.instituteName = instituteName
            self.instituteID = self.institutes[instituteName]
        }
    }
    
    public var year: String?
    
    private var groupNumber: String?
    private var groupScheduleID: String?
    private var groupScoreID: String?
    
    public var group: String? {
        get {
            return self.groupNumber
        }
        set(groupNumber) {
            guard let groupNumber = groupNumber else { return }
            
            self.getGroupScheduleID { (scheduleID, error) in
                guard error == nil else { return }
                guard let scheduleID = scheduleID else { return }
                
                self.groupScheduleID = scheduleID
            }

            self.getData(ofType: .groups) { (groups, error) in
                guard error == nil else { return }
                guard let groups = groups, groups.index(forKey: groupNumber) != nil else { return }
                
                self.groupScoreID = groups[groupNumber]
            }
            
            guard self.groupScheduleID != nil, self.groupScoreID != nil else { return }
            
            self.groupNumber = groupNumber
        }
    }
    
    private var fullName: String?
    private var ID: String?
    
    private var fellowStudentsNames: [String: String]?
    
    public var name: String? {
        get {
            return self.fullName
        }
        set(studentName) {
            guard let studentName = studentName else { return }
            
            self.getData(ofType: .names) { (names, error) in
                guard error == nil else { return }
                guard let names = names, names.index(forKey: studentName) != nil else { return }
                
                self.fullName = studentName
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
    
    
    private let scheduleURLString: String = "https://kai.ru/raspisanie"
    private let scoreURLString: String = "http://old.kai.ru/info/students/brs.php"
    
    
    public func getSchedule(ofType type: Student.ScheduleType,
      _ completion: @escaping ([String: [[String: String]]]?, Student.DataFetchingError?) -> Void) {
        let parameters = [
            "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
            "p_p_lifecycle": "2",
            "p_p_resource_id": type.rawValue,
            "groupId": self.groupScheduleID ?? ""
        ]
        
        guard let url = URL(string: self.scheduleURLString + "?" + parameters.toURLParametersString()) else {
            completion(nil, .onURLCreation)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil,
              (200...299) ~= response.statusCode else {
                completion(nil, .noServerResponse)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: [[String: String]]] else {
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
    
    public func getScoretable(forSemester semester: Int,
      _ completion: @escaping ([[String]]?, Student.DataFetchingError?) -> Void) {
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
                guard let table = tables.first() else { throw Student.DataFetchingError.onResponseParsing }
                
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
                
                guard !subjects.isEmpty else { throw Student.DataFetchingError.badServerResponse }
                
                completion(subjects, nil)
            } catch Student.DataFetchingError.badServerResponse {
                completion(nil, .badServerResponse)
            } catch {
                completion(nil, .onResponseParsing)
            }
        } .resume()
    }
    
    public func getData(ofType type: Student.DataType,
      _ completion: @escaping ([String: String]?, Student.DataFetchingError?) -> Void) {
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
                guard let selector = selectors.first() else { throw Student.DataFetchingError.onResponseParsing }
                
                let options = (try selector.getElementsByTag("option"))[1...]
                
                var studentData: [String: String] = [:]
                
                for option in options {
                    let key = try option.text()
                    let value = try option.attr("value")
                
                    studentData[key] = value
                }
                
                guard !studentData.isEmpty else { throw Student.DataFetchingError.badServerResponse }
                
                completion(studentData, nil)
            } catch Student.DataFetchingError.badServerResponse {
                completion(nil, .badServerResponse)
            } catch {
                completion(nil, .onResponseParsing)
            }
        } .resume()
    }
    
    
    private func getGroupScheduleID(_ completion: @escaping (String?, Student.DataFetchingError?) -> Void) {
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
    
    
    public enum ScheduleType: String {
        case classes = "schedule"
        case exams = "examSchedule"
    }
    
    public enum DataType: String {
        case years = "p_kurs"
        case groups = "p_group"
        case names = "p_stud"
    }
    
    public enum DataFetchingError: Error {
        case onURLCreation
        case noServerResponse
        case onResponseParsing
        case badServerResponse
    }
    
}
