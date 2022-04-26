//
//  PayrollReportListObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class PayrollReportListObject: NSObject {
    var straight: String = ""
    var regular_hours: String = ""
    var vacation_sick: String = ""
    var auto_lunch: String = ""
    var overtime: String = ""
    var total_paid_hours: String = ""
    var payable_amount: String = ""
    var currency: String = ""
    
    //EMPLOYEE OBJECT
    var objEmployee: EmployeeListObject = EmployeeListObject.init([:])
    
//    //CATEGORY OBJECT
//    var objCategory: CategoryListObject = CategoryListObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        let fStraight = dictionary["straight"] as? Double ?? 0.0
        self.straight = fStraight.clean
        
        let fregular_hours = dictionary["regular_hours"] as? Double ?? 0.0
        self.regular_hours = fregular_hours.clean
        
        let fvacation_sick = dictionary["vacation_sick"] as? Double ?? 0.0
        self.vacation_sick = fvacation_sick.clean
        
        let fauto_lunch = dictionary["auto_lunch"] as? Double ?? 0.0
        self.auto_lunch = fauto_lunch.clean
        
        let fovertime = dictionary["overtime"] as? Double ?? 0.0
        self.overtime = fovertime.clean
        
        let ftotal_paid_hours = dictionary["total_paid_hours"] as? Double ?? 0.0
        self.total_paid_hours = ftotal_paid_hours.clean
        
        let fpayable_amount = dictionary["payable_amount"] as? Double ?? 0.0
        self.payable_amount = fpayable_amount.clean
        
        self.currency = dictionary["currency"] as? String ?? ""
        
        //EMPLOYEE OBJECT
        if let get_employee = dictionary["employeeInfo"] as? Dictionary<String, Any> {
            self.objEmployee = EmployeeListObject.init(get_employee)
        }
        
        /*
        //CATEGORY OBJECT
        if let get_category = dictionary["get_category"] as? Dictionary<String, Any> {
            self.objCategory = CategoryListObject.init(get_category)
        }
        */
    }
}

/*
class PayrollReportDateObject: NSObject {
    var date: String = ""
    var arrPayrollList: [PayrollReportListObject] = []

    init(_ dictionary: [String: Any]) {
        self.date = dictionary["date"] as? String ?? ""
        
        if let payroll = dictionary["payroll"] as? [Dictionary<String, Any>] {
            for i in 0..<payroll.count  {
                let objPayroll = PayrollReportListObject.init(payroll[i])
                self.arrPayrollList.append(objPayroll)
            }
        }
    }
}
*/


//MARK:- EXPENSE DETAIL OBJECT
class ExpenseDetailListObject: NSObject {
    var category: String = ""
    var amount: String = ""

    init(_ dictionary: [String: Any]) {
        self.category = dictionary["category"] as? String ?? ""
        self.amount = dictionary["amount"] as? String ?? ""
    }
}
