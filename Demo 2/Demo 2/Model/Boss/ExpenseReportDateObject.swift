//
//  ExpenseReportDateObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

/*
class ExpenseReportDateObject: NSObject {
    var date: String = ""
    var arrReports: [ExpenseReportListObject] = []
    
    init(_ dictionary: [String: Any]) {
        self.date = dictionary["date"] as? String ?? ""
        
        if let expenses = dictionary["expenses"] as? [Dictionary<String, Any>] {
            for i in 0..<expenses.count  {
                let dictDetail = expenses[i]
                let objExpenseReport = ExpenseReportListObject.init(dictDetail)
                self.arrReports.append(objExpenseReport)
            }
        }
    }
}
*/

//MARK:- PUNCH LOG OBJECT
class ExpenseReportListObject: NSObject {
    var employee_id: Int        = 0
    var employee_name: String   = ""
    var totalSum: String        = ""
    
    var arrExpenseCategory:[BossReportExpenseGraphCategory] = []
    
    init(_ dictionary: [String: Any]) {
        self.employee_id    = dictionary["employee_id"] as? Int ?? 0
        self.employee_name  = dictionary["employee_name"] as? String ?? ""
        
        let ftotalSum = dictionary["totalSum"] as? Float ?? 0.0
        self.totalSum = ftotalSum.clean

        //EXPENSES
        if let expenses = dictionary["expenses"] as? [Dictionary<String, Any>] {
            for i in 0..<expenses.count  {
                let dictDetail = expenses[i]
                let objExpenseCategory = BossReportExpenseGraphCategory.init(dictDetail)
                self.arrExpenseCategory.append(objExpenseCategory)
            }
        }
    }
}

class BossReportExpenseGraphCategory: NSObject {
    var cat_name: String = ""
    var total: String = ""

    init(_ dictionary: [String: Any]) {
        self.cat_name = dictionary["cat_name"] as? String ?? ""
        self.total = dictionary["total"] as? String ?? ""
    }
}
