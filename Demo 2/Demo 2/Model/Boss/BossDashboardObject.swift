//
//  BossDashboardObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 26/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class BossDashboardObject: NSObject {
    var trial_period: String = ""
    var subscription: String = ""
    var total_active_employee: Int = 0
    var today_active_employee: Int = 0
    var expire_day: Int = 0
    
    //PUNCH IN EMPLOYEE
    var arrPunchInEmployee: [PunchInEmployeeObject] = []
    
    //PUNCH OUT EMPLOYEE
    var arrPunchOutEmployee: [PunchInEmployeeObject] = []
    
    //UPCOMING LEAVE
    var arrUpcomingLeave: [UpcomingLeaveObject] = []
    
    //ESTIMATED PAYROLL
    var objPayroll: EstimatedPayrollObject = EstimatedPayrollObject.init([:])
    
    var strDailyWH: String = ""
    var strDailyOH: String = ""
    var strDailyPH: String = ""
    
    var strWeeklyWH: String = ""
    var strWeeklyOH: String = ""
    var strWeeklyPH: String = ""
    
    var strMonthlyWH: String = ""
    var strMonthlyOH: String = ""
    var strMonthlyPH: String = ""
    
    //COMPANY SETTING
    var objCompanySetting: BossSettingsObject = BossSettingsObject.init([:])
    
    var arrWeeklyPerformer: [TopPerformerEmployee] = []
    var arrMonthlyPerformer: [TopPerformerEmployee] = []
    var arrAllTimePerformer: [TopPerformerEmployee] = []
    
    init(_ dictionary: [String: Any]) {
        self.trial_period = dictionary["trial_period"] as? String ?? ""
        self.subscription = dictionary["subscription"] as? String ?? ""
        self.total_active_employee = dictionary["total_active_employee"] as? Int ?? 0
        self.today_active_employee = dictionary["today_active_employee"] as? Int ?? 0
        self.expire_day = dictionary["expire_day"] as? Int ?? 0
        appDelegate.trial_expire_day = self.expire_day
        
        //PUNCH IN EMPLOYEE
        if let get_punchin_emp_info = dictionary["punch_in_employee"] as? [Dictionary<String, Any>] {
            for i in 0..<get_punchin_emp_info.count {
                let dictPunchInEmp = get_punchin_emp_info[i]
                let objPunchInEmp = PunchInEmployeeObject.init(dictPunchInEmp)
                self.arrPunchInEmployee.append(objPunchInEmp)
            }
        }
        
        //PUNCH OUT EMPLOYEE
        if let get_punchout_emp_info = dictionary["punch_out_employee"] as? [Dictionary<String, Any>] {
            for i in 0..<get_punchout_emp_info.count {
                let dictPunchOutEmp = get_punchout_emp_info[i]
                let objPunchOutEmp = PunchInEmployeeObject.init(dictPunchOutEmp)
                self.arrPunchOutEmployee.append(objPunchOutEmp)
            }
        }
        
        //UPCOMING LEAVE
        if let get_upcoming_leave = dictionary["upcoming_leave"] as? [Dictionary<String, Any>] {
            for i in 0..<get_upcoming_leave.count {
                let dictUpcomingLeave = get_upcoming_leave[i]
                let objUpcomingLeave = UpcomingLeaveObject.init(dictUpcomingLeave)
                self.arrUpcomingLeave.append(objUpcomingLeave)
            }
        }
        
        //ESTIMATED PAYROLL
//        if let get_payroll = dictionary["estimated_payroll"] as? Dictionary<String, Any> {
//            self.objPayroll = EstimatedPayrollObject.init(get_payroll)
//        }
        
        if let payroll_chart = dictionary["payroll_chart"] as? Dictionary<String, Any> {
//            self.objPayroll = EstimatedPayrollObject.init(get_payroll)
            
            //DAILY
            if let daily = payroll_chart["daily"] as? Dictionary<String, Any> {
                let ftotal_working = daily["total_working"] as? Double ?? 0.0
                self.strDailyWH = ftotal_working.clean
                
                let fpayroll = daily["payroll"] as? Double ?? 0.0
                self.strDailyPH = fpayroll.clean
                
                let fovertime = daily["overtime"] as? Double ?? 0.0
                self.strDailyOH = fovertime.clean
            }
            
            //WEEKLY
            if let week = payroll_chart["week"] as? Dictionary<String, Any> {
                let ftotal_working = week["total_working"] as? Double ?? 0.0
                self.strWeeklyWH = ftotal_working.clean
                
                let fpayroll = week["payroll"] as? Double ?? 0.0
                self.strWeeklyPH = fpayroll.clean
                
                let fovertime = week["overtime"] as? Double ?? 0.0
                self.strWeeklyOH = fovertime.clean
            }
            
            //MONTHLY
            if let month = payroll_chart["month"] as? Dictionary<String, Any> {
                let ftotal_working = month["total_working"] as? Double ?? 0.0
                self.strMonthlyWH = ftotal_working.clean
                
                let fpayroll = month["payroll"] as? Double ?? 0.0
                self.strMonthlyPH = fpayroll.clean
                
                let fovertime = month["overtime"] as? Double ?? 0.0
                self.strMonthlyOH = fovertime.clean
            }
        }
        
        //COMPANY SETTING
        if let get_Setting = dictionary["company_setting"] as? Dictionary<String, Any> {
            self.objCompanySetting = BossSettingsObject.init(get_Setting)
        }
        
        //TOP PERFORMER
        if let top_perform_employee = dictionary["top_perform_employee"] as? Dictionary<String, Any> {
            
            //WEEK
            if let week = top_perform_employee["week"] as? [Dictionary<String, Any>] {
                for i in 0..<week.count {
                    let objWeeklyPerformer = TopPerformerEmployee.init(week[i])
                    self.arrWeeklyPerformer.append(objWeeklyPerformer)
                }
            }
            
            //MONTHLY
            if let monthly = top_perform_employee["monthly"] as? [Dictionary<String, Any>] {
                for i in 0..<monthly.count {
                    let objMonthlyPerformer = TopPerformerEmployee.init(monthly[i])
                    self.arrMonthlyPerformer.append(objMonthlyPerformer)
                }
            }
            
            //ALL-TIME
            if let all = top_perform_employee["all"] as? [Dictionary<String, Any>] {
                for i in 0..<all.count {
                    let objAllTimePerformer = TopPerformerEmployee.init(all[i])
                    self.arrAllTimePerformer.append(objAllTimePerformer)
                }
            }
        }
    }
}

//MARK:- PUNCH IN EMPLOYEE OBJECT -
class PunchInEmployeeObject: NSObject {
    var id: Int = 0
    var employee_user_id: Int = 0
    var job_id: Int = 0
    var punchin_time: String = ""
    var punchout_time: String = ""
    var punchInLatitude: String = ""
    var punchInLongitude: String = ""
    var punchOutLatitude: String = ""
    var punchOutLongitude: String = ""
    var timezone: String = ""
    var country: String = ""
    var currency: String = ""
    var pay_rate: String = ""
    var note: String = ""
    var updated_by: Int = 0
    var punch_via: String = ""
    var is_sync: Int = 0
    var is_manual: Int = 0
    
    //EMPLOYEE INFO
    var objEmployeeInfo: PunchInEmployeeInfoObject = PunchInEmployeeInfoObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.employee_user_id = dictionary["employee_user_id"] as? Int ?? 0
        self.job_id = dictionary["job_id"] as? Int ?? 0
        self.punchin_time = dictionary["punchin_time"] as? String ?? ""
        self.punchout_time = dictionary["punchout_time"] as? String ?? ""
        
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
        
        self.timezone = dictionary["timezone"] as? String ?? ""
        self.country = dictionary["country"] as? String ?? ""
        self.currency = dictionary["currency"] as? String ?? ""
        self.pay_rate = dictionary["pay_rate"] as? String ?? ""
        self.note = dictionary["note"] as? String ?? ""
        self.updated_by = dictionary["updated_by"] as? Int ?? 0
        self.punch_via = dictionary["punch_via"] as? String ?? ""
        self.is_sync = dictionary["is_sync"] as? Int ?? 0
        self.is_manual = dictionary["is_manual"] as? Int ?? 0
        
        if let get_EmpInfo = dictionary["employee_info"] as? Dictionary<String, Any> {
            self.objEmployeeInfo = PunchInEmployeeInfoObject.init(get_EmpInfo)
        }
    }
}

//PUNCH IN EMPLOYEE INFO
class PunchInEmployeeInfoObject: NSObject {
    var id: Int = 0
    var name: String = ""

    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
    }
}

//MARK:- UPCOMING LEAVE OBJECT -
class UpcomingLeaveObject: NSObject {
    var id: Int = 0
    var employee_user_id: Int = 0
    var company_user_id: Int = 0
    var leave_type: String = ""
    var from_date: String = ""
    var to_date: String = ""
    var leave_time: String = ""
    var deleted_at: String = ""
    
    //USER EMPLOYEE
    var objUserEmployee: PunchInEmployeeInfoObject = PunchInEmployeeInfoObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.employee_user_id = dictionary["employee_user_id"] as? Int ?? 0
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.leave_type = dictionary["leave_type"] as? String ?? ""
        self.from_date = dictionary["from_date"] as? String ?? ""
        self.to_date = dictionary["to_date"] as? String ?? ""
        self.leave_time = dictionary["leave_time"] as? String ?? ""
        self.deleted_at = dictionary["deleted_at"] as? String ?? ""
        
        if let get_UserEmp = dictionary["user_employee"] as? Dictionary<String, Any> {
            self.objUserEmployee = PunchInEmployeeInfoObject.init(get_UserEmp)
        }
    }
}

//MARK:- ESTIMATED PAYROLL OBJECT -
class EstimatedPayrollObject: NSObject {
    var total_payroll: Int = 0
    var total_overtime: Int = 0
    var total_working: Int = 0
    var currency: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.total_payroll = dictionary["total_payroll"] as? Int ?? 0
        self.total_overtime = dictionary["total_overtime"] as? Int ?? 0
        self.total_working = dictionary["total_working"] as? Int ?? 0
        self.currency = dictionary["currency"] as? String ?? ""
    }
}

//MARK:- TOP PERFORMER EMPLOYEE
class TopPerformerEmployee: NSObject {
    var id: Int = 0
    var name: String = ""
    var total_hours: Double = 0.0
    
    init(_ dictionary: [String: Any]) {
        let strHours = dictionary["total_hours"] as? String ?? ""
        self.total_hours = Double(strHours) ?? 0.0
        
        if let user_employee = dictionary["user_employee"] as? Dictionary<String, Any> {
            self.id = user_employee["id"] as? Int ?? 0
            self.name = user_employee["name"] as? String ?? ""
        }
    }
}
