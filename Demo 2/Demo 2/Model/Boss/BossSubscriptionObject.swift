//
//  BossSubscriptionObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import Foundation

class BossSubscriptionObject: NSObject {
    var id: String = ""
    var packageName: String = ""
    var userLimit: Int = 0
    var packageId: String = ""
    var packagePrice: String = ""

    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.packageName = dictionary["packageName"] as? String ?? ""
        self.userLimit = dictionary["userLimit"] as? Int ?? 0
        self.packageId = dictionary["packageId"] as? String ?? ""
        self.packagePrice = dictionary["packagePrice"] as? String ?? ""
    }
}

class BossSubscribedObject: NSObject, Codable {
    var id: Int = 0
    var subscription_enddate: String = ""
    var price: String = ""
    var company_user_id: Int = 0
    var subscription_rate: String = ""
    var plan_id: String = ""
    var active_employee: Int = 0
    var no_of_users: Int = 0
    
    //GET PLAN
    var objGetPlan: GetPlanObject = GetPlanObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        if !(dictionary["subscription_enddate"] as? String ?? "").isEmpty {
            let strSubscriptionEndDate = AppFunctions.sharedInstance.formattedDateFromString(dateString: dictionary["subscription_enddate"] as? String ?? "", InputFormat: SUBSCRIPTION_DATE_INPUT_FORMAT, OutputFormat: SUBSCRIPTION_DATE_OUTPUT_FORMAT)
            self.subscription_enddate = strSubscriptionEndDate ?? ""
        } else {
            self.subscription_enddate = dictionary["subscription_enddate"] as? String ?? ""
        }
        self.price = dictionary["price"] as? String ?? ""
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.subscription_rate = dictionary["subscription_rate"] as? String ?? ""
        self.plan_id = dictionary["subscription_rate"] as? String ?? ""
        self.active_employee = dictionary["active_employee"] as? Int ?? 0
        self.no_of_users = dictionary["no_of_users"] as? Int ?? 0
        
        //GET PLAN
        if let get_plan = dictionary["get_plan"] as? Dictionary<String, Any> {
            self.objGetPlan = GetPlanObject.init(get_plan)
        }
    }
}

class GetPlanObject: NSObject, Codable {
    var id: Int = 0
    var package_name: String = ""
    var user_limit: Int = 0
    var ios_plan_id: String = ""
    var plan_type: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.package_name = dictionary["package_name"] as? String ?? ""
        self.user_limit = dictionary["user_limit"] as? Int ?? 0
        self.ios_plan_id = dictionary["ios_plan_id"] as? String ?? ""
        self.plan_type = dictionary["plan_type"] as? String ?? ""
    }
}
