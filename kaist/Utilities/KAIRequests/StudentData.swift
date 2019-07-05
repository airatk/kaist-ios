//
//  StudentData.swift
//  kaist
//
//  Created by Airat K on 4/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import Foundation


class Student {
    
    var isSetUp: Bool {
        return (
            institute != nil &&
            year != nil &&
            groupNumber != nil &&
            name != nil &&
            cardNumber != nil
        )
    }
    
    var institute: String?
    var instituteId: String?
    
    var year: String?
    
    var groupNumber: String?
    var groupNumberScheduleId: String?
    var groupNumberScoreId: String?
    
    var name: String?
    var nameId: String?
    var names: [String]?
    
    var cardNumber: String?
    
    
    
    
}


//    def group_number(self, group_number):
//        # Setting raw group number
//        self._group_number = group_number
//
//        try:
//            # Setting id of group number for schedule
//            self._group_number_schedule = get(url=SCHEDULE_URL, params={
//                "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
//                "p_p_lifecycle": "2",
//                "p_p_resource_id": "getGroupsURL",
//                "query": group_number
//            }).json()[0]["id"]
//
//            # Setting id of group number for score
//            if self._institute_id != "КИТ": self._group_number_score = self.get_dictionary_of(type="p_group")[group_number]
//        except (IndexError, KeyError):
//            self._group_number = "non-existing"
//        except Exception:
//            self._group_number = None

//    def name(self, name):
//        # Setting raw name
//        self._name = name
//
//        try:
//            # Setting id of name for score
//            self._name_id = self.get_dictionary_of(type="p_stud")[name]
//        except Exception:
//            self._name = None

//    # /classes & /exams
//    def get_schedule(self, type, next=False):
//        is_own_group_asked = self._another_group_number_schedule is None
//
//        try:
//            response = post(url=SCHEDULE_URL, params={
//                "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
//                "p_p_lifecycle": "2",
//                "p_p_resource_id": "schedule" if type == "classes" else "examSchedule"
//            }, data={
//                "groupId": self._group_number_schedule if is_own_group_asked else self._another_group_number_schedule
//            }).json()
//        except ConnectionError:
//            return [ "kai.ru не отвечает🤷🏼‍♀️" ]
//
//        if not response: return [ "Нет данных." ]
//
//        return beautify_classes(response, next, self._edited_subjects) if type == "classes" else beautify_exams(response)

//    # /score & associated stuff
//    def get_dictionary_of(self, type):
//        try:
//            page = get(url=SCORE_URL, params={
//                "p_fac": self._institute_id,
//                "p_kurs": self._year,
//                "p_group": self._group_number_score
//            }).content.decode("CP1251")
//        except ConnectionError:
//            return None
//
//        soup = BeautifulSoup(page, "html.parser")
//        selector = soup.find(name="select", attrs={ "name": type })
//
//        keys = [ option.text for option in selector.find_all("option") ][1:]
//        values = [ option["value"] for option in selector.find_all("option") ][1:]
//
//        # Fixing bad quality response
//        for i in range(1, len(keys)): keys[i - 1] = keys[i - 1].replace(keys[i], "")
//        for i, key in enumerate(keys): keys[i] = key[:-1] if key.endswith(" ") else key
//
//        return dict(zip(keys, values))

//    def get_scoretable(self, semester):
//        try:
//            page = post(SCORE_URL, data={
//                "p_sub": "",  # Unknown nonsense thing which is necessary
//                "p_fac": self._institute_id,
//                "p_kurs": self._year,
//                "p_group": self._group_number_score,
//                "p_stud": self._name_id,
//                "p_zach": self._student_card_number,
//                "semestr": semester
//            }).content.decode("CP1251")
//        except ConnectionError:
//            return None
//
//        soup = BeautifulSoup(page, features="html.parser")
//        table = soup.html.find(name="table", attrs={ "id": "reyt" })
//
//        if not table: return []
//
//        subjects = []
//        for row in table.find_all("tr"):
//            subject = []
//            for data in row.find_all("td"):
//                subject.append(data.text if data.text else "-")
//            subjects.append(subject)
//        subjects = subjects[2:]
//
//        return subjects
