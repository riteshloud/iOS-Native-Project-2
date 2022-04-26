//
//  EmployeeTimesheetListObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class TimesheetListObject: NSObject, Codable {
    var date: String = ""
    var arrPunchLog: [TimesheetPunchLogObject] = []

    init(_ dictionary: [String: Any]) {
        self.date = dictionary["date"] as? String ?? ""
        
        if let punch_logs = dictionary["punch_logs"] as? [Dictionary<String, Any>] {
            for i in 0..<punch_logs.count  {
                let objPunchLog = TimesheetPunchLogObject.init(punch_logs[i])
                self.arrPunchLog.append(objPunchLog)
            }
        }
    }
}

//MARK:- PUNCH LOG OBJECT
class TimesheetPunchLogObject: NSObject, Codable {
    var punchin_time: String = ""
    var id: Int = 0
    var guID: String = ""
    var punchout_time: String = ""
    var punchInLatitude: String = ""
    var punchInLongitude: String = ""
    var punchOutLatitude: String = ""
    var punchOutLongitude: String = ""
//    var duration: String = ""
    var duration_new: String = ""
    var note: String = ""
    var timezone: String = ""
    var is_updated: Bool = false
    var is_deleted: Bool = false
    
    var objJob = JobListObject.init([:])
    var objEmployee = EmployeeListObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self.punchin_time = dictionary["punchin_time"] as? String ?? ""
        self.id = dictionary["id"] as? Int ?? 0
        self.guID = dictionary["guid"] as? String ?? ""
        self.punchout_time = dictionary["punchout_time"] as? String ?? ""
//        self.duration = dictionary["duration"] as? String ?? ""
        self.duration_new = dictionary["duration_new"] as? String ?? ""
        self.note = dictionary["note"] as? String ?? ""
        self.timezone = dictionary["timezone"] as? String ?? ""
        
        self.is_updated = dictionary["is_updated"] as? Bool ?? false
        self.is_deleted = dictionary["is_deleted"] as? Bool ?? false
        
        //PUNCH IN LOCATION
        if let punch_location = dictionary["punch_location"] as? Dictionary<String, Any> {
            self.punchInLatitude = punch_location["lat"] as? String ?? ""
            self.punchInLongitude = punch_location["lon"] as? String ?? ""
        }
        
        //PUNCH OUT LOCATION
        if let punchout_location = dictionary["punchout_location"] as? Dictionary<String, Any> {
            self.punchOutLatitude = punchout_location["lat"] as? String ?? ""
            self.punchOutLongitude = punchout_location["lon"] as? String ?? ""
        }
        
        if let jobs = dictionary["jobs"] as? Dictionary<String, Any> {
            self.objJob = JobListObject.init(jobs)
        }
        
        if let employee = dictionary["employee"] as? Dictionary<String, Any> {
            self.objEmployee = EmployeeListObject.init(employee)
        }
    }
}
