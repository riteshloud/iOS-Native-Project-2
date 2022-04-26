//
//  EmployeeDashboardObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class EmployeeDashboardObject: NSObject, Codable {
    var date_format: String = ""
    var time_format: String = ""
    var week_start: String = ""
    var todays_earning: String = ""
    var weekly_hours: String = ""
    var today_hours: String = ""
    var subscription: String = ""
    var trial_period: String = ""
    var arrCurrentPunch: [TimesheetListObject] = []
    var objEmployeeSetting: BossEmployeeSettingsObject = BossEmployeeSettingsObject.init([:])
    
    var total_daily_hours: Int = 0
    var total_weekly_hours: Int = 0
    var total_used_weekly_hours: String = ""
    var weekly_overtime_hours: String = ""
    var currency: String = ""
    
    var arrJobs: [JobListObject] = []
    
    init(_ dictionary: [String: Any]) {
        self.date_format = dictionary["date_format"] as? String ?? ""
        self.time_format = dictionary["time_format"] as? String ?? ""
        self.week_start = dictionary["week_start"] as? String ?? ""
        self.todays_earning = dictionary["todays_earning"] as? String ?? ""
        self.weekly_hours = dictionary["weekly_hours"] as? String ?? ""
        self.today_hours = dictionary["today_hours"] as? String ?? ""
        self.subscription = dictionary["subscription"] as? String ?? ""
        self.trial_period = dictionary["trial_period"] as? String ?? ""
        
        //CURRENT PUNCH LOG
        if let current_punches = dictionary["current_punches"] as? [Dictionary<String, Any>] {
            for i in 0..<current_punches.count {
                let dictPunch = current_punches[i]
                let objCurrentPunchLog = TimesheetListObject.init(dictPunch)
                self.arrCurrentPunch.append(objCurrentPunchLog)
            }
        }
        
        //EMPLOYEE SETTING
        if let setting = dictionary["setting"] as? Dictionary<String, Any> {
            let objSetting = BossEmployeeSettingsObject.init(setting)
            self.objEmployeeSetting = objSetting
        }
        
        self.total_daily_hours = dictionary["total_daily_hours"] as? Int ?? 0
        self.total_weekly_hours = dictionary["total_weekly_hours"] as? Int ?? 0
        self.total_used_weekly_hours = dictionary["total_used_weekly_hours"] as? String ?? ""
        self.weekly_overtime_hours = dictionary["weekly_overtime_hours"] as? String ?? ""
        self.currency = dictionary["currency"] as? String ?? ""
        
        //JOBS
        if let jobs = dictionary["jobs"] as? [Dictionary<String, Any>] {
            for i in 0..<jobs.count {
                let dictJob = jobs[i]
                let objJob = JobListObject.init(dictJob)
                self.arrJobs.append(objJob)
            }
        }
    }
}


class BossEmployeeSettingsObject: NSObject, Codable {
    var timesheet_status: Int = 0
    var timezone: String = ""
    
    init(_ dictionary: [String: Any]) {
        
    }
}
