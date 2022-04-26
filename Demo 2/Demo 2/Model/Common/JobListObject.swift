//
//  JobListObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 12/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class JobListObject: NSObject, Codable {
    var id: Int = 0
    var company_user_id: Int = 0
    var employee_user_id: [String] = []
    var client_id: Int = 0
    var job_title: String = ""
    var job_code: String = ""
    var job_hourly_rate: String = ""
    var job_date: String = ""
    var descriptionn: String = ""
    var currency: String = ""
    var status: String = ""
    var job_id: Int = 0
    var strCreatedByForBoss: String = ""
    var isDeletableForEmployee: Int = 0
    var totalHours: Int = 0
    
    //CLIENT OBJECT
    var objClient: ClientListObject = ClientListObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.employee_user_id = dictionary["employee_user_id"] as? [String] ?? []
        self.client_id = dictionary["client_id"] as? Int ?? 0
        self.job_title = dictionary["job_title"] as? String ?? ""
        self.job_code = dictionary["job_code"] as? String ?? ""
        self.job_hourly_rate = dictionary["job_hourly_rate"] as? String ?? ""
        self.job_date = dictionary["job_date"] as? String ?? ""
        self.descriptionn = dictionary["description"] as? String ?? ""
        self.currency = dictionary["currency"] as? String ?? ""
        self.status = dictionary["status"] as? String ?? ""
        self.job_id = dictionary["job_id"] as? Int ?? 0
        self.isDeletableForEmployee = dictionary["is_deletable"] as? Int ?? 0
        
        if let get_client = dictionary["get_client"] as? Dictionary<String, Any> {
            self.objClient = ClientListObject.init(get_client)
        }
        
        if let created_by = dictionary["created_by"] as? Dictionary<String, Any> {
            self.strCreatedByForBoss = created_by["name"] as? String ?? ""
        }
    }
}
