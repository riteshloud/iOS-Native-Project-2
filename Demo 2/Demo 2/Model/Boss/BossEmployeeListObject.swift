//
//  BossEmployeeListObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 03/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class BossEmployeeListObject: NSObject {
    var id: Int = 0
    var emp_id: String = ""
    var employee_user_id: Int = 0
    var currency: String = ""
    var pay_rate: String = ""
    var timezone: String = ""
    
    var objUserEmployee: UserEmployeeObject = UserEmployeeObject.init([:])
    var objEmployeePunchLog: EmployeePunchLogObject = EmployeePunchLogObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.emp_id = dictionary["emp_id"] as? String ?? ""
        self.employee_user_id = dictionary["employee_user_id"] as? Int ?? 0
        self.currency = dictionary["currency"] as? String ?? ""
        self.pay_rate = dictionary["pay_rate"] as? String ?? ""
        self.timezone = dictionary["timezone"] as? String ?? ""
        
        //USER EMPLOYEE DETAIL
        if let user_employee = dictionary["user_employee"] as? Dictionary<String, Any> {
            self.objUserEmployee = UserEmployeeObject.init(user_employee)
        }
        
        if let employee_punch_log = dictionary["employee_punch_log"] as? Dictionary<String, Any> {
            self.objEmployeePunchLog = EmployeePunchLogObject.init(employee_punch_log)
        }
    }
}

//MARK:- EMPLOYEE PUNCH LOG OBJECT
class EmployeePunchLogObject: NSObject {
    var employee_user_id: Int = 0
    var punchin_time: String = ""
    var punchout_time: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.employee_user_id = dictionary["employee_user_id"] as? Int ?? 0
        self.punchin_time = dictionary["punchin_time"] as? String ?? ""
        self.punchout_time = dictionary["punchout_time"] as? String ?? ""
    }
}

//MARK:- USER EMPLOYEE OBJECT
class UserEmployeeObject: NSObject {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var country_code: String = ""
    var phone: String = ""
    var created_at: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.country_code = dictionary["country_code"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? String ?? ""
    }
}


//MARK:- COMPANY DEFAULT SETTING OBJECT
class CompanyDefaultSettingObject: NSObject {
    var company_user_id: Int = 0
    var balance_vacation: Int = 0
    var balance_sick: Int = 0
    var timesheet_status: Int = 0
    var lunch_break_time: String = ""
    var date_format: String = ""
    var time_format: String = ""
    var weekly_hours: Int = 0
    var daily_hours: Int = 0
    var daily_overtime: Int = 0
    var weekly_overtime: Int = 0
    
    init(_ dictionary: [String: Any]) {
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.balance_vacation = dictionary["balance_vacation"] as? Int ?? 0
        self.balance_sick = dictionary["balance_sick"] as? Int ?? 0
        self.timesheet_status = dictionary["timesheet_status"] as? Int ?? 0
        self.lunch_break_time = dictionary["lunch_break_time"] as? String ?? ""
        self.date_format = dictionary["date_format"] as? String ?? ""
        self.time_format = dictionary["time_format"] as? String ?? ""
        
        //COMPANY OVERTIME DETAIL
        if let get_company_overtime = dictionary["get_company_overtime"] as? Dictionary<String, Any> {
            self.weekly_hours = get_company_overtime["weekly_hours"] as? Int ?? 0
            self.daily_hours = get_company_overtime["daily_hours"] as? Int ?? 0
            self.weekly_overtime = get_company_overtime["weekly_overtime"] as? Int ?? 0
            self.daily_overtime = get_company_overtime["daily_overtime"] as? Int ?? 0
        }
    }
}
