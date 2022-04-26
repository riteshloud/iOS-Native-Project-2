//
//  EmployeeListObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 16/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class EmployeeListObject: NSObject, Codable {
    var employee_user_id: Int = 0
    var company_user_id: Int = 0
    var TotalVacation: Int = 0
    var TotalSick: Int = 0
    var used_vacation_count: Int = 0
    var used_sick_count: Int = 0
    var employeeName: String = ""
    var employeeID: Int = 0
    
    var id: Int = 0
    var name: String = ""
    var country_code: String = ""
    var email: String = ""
    var phone: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.employee_user_id = dictionary["employee_user_id"] as? Int ?? 0
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.TotalVacation = dictionary["TotalVacation"] as? Int ?? 0
        self.TotalSick = dictionary["TotalSick"] as? Int ?? 0
        self.used_vacation_count = dictionary["used_vacation_count"] as? Int ?? 0
        self.used_sick_count = dictionary["used_sick_count"] as? Int ?? 0
        self.employeeName = dictionary["name"] as? String ?? ""
        self.employeeID = dictionary["id"] as? Int ?? 0
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        
        if let user_employee = dictionary["user_employee"] as? Dictionary<String, Any> {
            self.id = user_employee["id"] as? Int ?? 0
            self.name = user_employee["name"] as? String ?? ""
            self.country_code = user_employee["country_code"] as? String ?? ""
            self.email = user_employee["email"] as? String ?? ""
            self.phone = user_employee["phone"] as? String ?? ""
        }
    }
}
