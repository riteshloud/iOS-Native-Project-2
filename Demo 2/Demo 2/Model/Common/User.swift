//
//  User.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class User: NSObject, Codable {
    var login_type: String = ""
    var name: String = ""
    var country_code: String = ""
    var device_token: String = ""
    var access_token: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var phone: String = ""
    var device_model: String = ""
    var email_verified_at: String = ""
    var device_login: Int = 0
    var reg_status_two: Bool = false
    var login_via: String = ""
    var id: Int = 0
    var deleted_at: String = ""
    var device_name: String = ""
    var status: String = ""
    var device_id: String = ""
    var email: String = ""
    
    var objCompanyInfo: BossSettingsObject = BossSettingsObject.init([:])
    var objEmployeeInfo: EmployeeDashboardObject = EmployeeDashboardObject.init([:])
    
    class func initWith(dict: Dictionary<String, Any>) -> User {
        
        let object = User()
        
        if let login_type = dict["login_type"] as? String {
            object.login_type = login_type
        }
        if let name = dict["name"] as? String {
            object.name = name
        }
        if let country_code = dict["country_code"] as? String {
            object.country_code = country_code
        }
        if let device_token = dict["device_token"] as? String {
            object.device_token = device_token
        }
        if let access_token = dict["access_token"] as? String {
            object.access_token = access_token
        }
        if let created_at = dict["created_at"] as? String {
            object.created_at = created_at
        }
        if let updated_at = dict["updated_at"] as? String {
            object.updated_at = updated_at
        }
        if let phone = dict["phone"] as? String {
            object.phone = phone
        }
        if let device_model = dict["device_model"] as? String {
            object.device_model = device_model
        }
        if let email_verified_at = dict["email_verified_at"] as? String {
            object.email_verified_at = email_verified_at
        }
        if let device_login = dict["device_login"] as? Int {
            object.device_login = device_login
        }
        if let reg_status_two = dict["reg_status_two"] as? Bool {
            object.reg_status_two = reg_status_two
        }
        if let login_via = dict["login_via"] as? String {
            object.login_via = login_via
        }
        if let id = dict["id"] as? Int {
            object.id = id
        }
        if let deleted_at = dict["deleted_at"] as? String {
            object.deleted_at = deleted_at
        }
        if let device_name = dict["device_name"] as? String {
            object.device_name = device_name
        }
        if let status = dict["status"] as? String {
            object.status = status
        }
        if let device_id = dict["device_id"] as? String {
            object.device_id = device_id
        }
        if let email = dict["email"] as? String {
            object.email = email
        }
        
        //COMPANY INFO
        if let company_info = dict["company_info"] as? Dictionary<String, Any> {
            object.objCompanyInfo = BossSettingsObject.init(company_info)
        }
        
        //EMPLOYEE DASHBOARD
        if let dashboard = dict["dashboard"] as? Dictionary<String, Any> {
            object.objEmployeeInfo = EmployeeDashboardObject.init(dashboard)
        }
        
        return object
    }
}
