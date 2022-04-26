//
//  BossSettingsObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 10/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class BossSettingsObject: NSObject, Codable {
    var id: Int = 0
    var company_user_id: Int = 0
    var company_name: String = ""
    var company_logo: String = ""
    var currency: String = ""
    var country_code: String = ""
    var pay_rate: String = ""
    var time_zone: String = ""
    var week_start: String = ""
    var timesheet_status: Int = 0
    var balance_vacation: Int = 0
    var balance_sick: Int = 0
    var company_location: Int = 0
    var manual_location_type: String = ""
    var lunch_break_type: Int = 0
    var lunch_break_time: String = ""
    var auto_lunch_break: String = ""
    var company_overtime: Int = 0
    var notificatin_type: Int = 0
    var date_format: String = ""
    var time_format: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var deleted_at: String = ""
    var geo_location_status: Int = 0
    
    //COMPANY USER DETAIL OBJECT
    var objUserDetail: BossUserDetailObject = BossUserDetailObject.init([:])
    
    //COMPANY OVERTIME
    var objOvertime: BossOvertimeObject = BossOvertimeObject.init([:])
    
    //NOTIFICATION SETTINGS
    var arrNotificationSettings: [CompanyNotificationSettingObject] = []
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.company_name = dictionary["company_name"] as? String ?? ""
        self.company_logo = dictionary["company_logo"] as? String ?? ""
        self.currency = dictionary["currency"] as? String ?? ""
        self.country_code = dictionary["country_code"] as? String ?? ""
        self.pay_rate = dictionary["pay_rate"] as? String ?? ""
        self.time_zone = dictionary["time_zone"] as? String ?? ""
        self.week_start = dictionary["week_start"] as? String ?? ""
        self.timesheet_status = dictionary["timesheet_status"] as? Int ?? 0
        self.balance_vacation = dictionary["balance_vacation"] as? Int ?? 0
        self.balance_sick = dictionary["balance_sick"] as? Int ?? 0
        self.company_location = dictionary["company_location"] as? Int ?? 0
        self.manual_location_type = dictionary["manual_location_type"] as? String ?? ""
        self.lunch_break_type = dictionary["lunch_break_type"] as? Int ?? 0
        self.lunch_break_time = dictionary["lunch_break_time"] as? String ?? ""
        self.auto_lunch_break = dictionary["auto_lunch_break"] as? String ?? ""
        self.company_overtime = dictionary["company_overtime"] as? Int ?? 0
        self.notificatin_type = dictionary["notificatin_type"] as? Int ?? 0
        self.date_format = dictionary["date_format"] as? String ?? ""
        self.time_format = dictionary["time_format"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""
        self.deleted_at = dictionary["deleted_at"] as? String ?? ""
        self.geo_location_status = dictionary["geo_location_status"] as? Int ?? 0
        
        //COMPANY USER DETAIL OBJECT
        if let user_details = dictionary["user_details"] as? Dictionary<String, Any> {
            self.objUserDetail = BossUserDetailObject.init(user_details)
        }
        
        //COMPANY OVERTIME
        if let get_company_overtime = dictionary["get_company_overtime"] as? Dictionary<String, Any> {
            self.objOvertime = BossOvertimeObject.init(get_company_overtime)
        }
        
        //NOTIFICATION SETTINGS
        if let company_notification_settings = dictionary["company_notification_settings"] as? [Dictionary<String, Any>] {
            for i in 0..<company_notification_settings.count  {
                let dictNotificationSetting = company_notification_settings[i]
                let objNotificationSetting = CompanyNotificationSettingObject.init(dictNotificationSetting)
                self.arrNotificationSettings.append(objNotificationSetting)
            }
        }
    }
}

//MARK:- USER DETAIL OBJECT
class BossUserDetailObject: NSObject, Codable {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var country_code: String = ""
    var phone: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.country_code = dictionary["country_code"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
    }
}

//MARK:- COMPANY OVERTIME OBJECT
class BossOvertimeObject: NSObject, Codable {
    var id: Int = 0
    var company_user_id: Int = 0
    var weekly_overtime: Int = 0
    var daily_overtime: Int = 0
    var weekly_hours: Int = 0
    var daily_hours: Int = 0
    var created_at: String = ""
    var updated_at: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.weekly_overtime = dictionary["weekly_overtime"] as? Int ?? 0
        self.daily_overtime = dictionary["daily_overtime"] as? Int ?? 0
        self.weekly_hours = dictionary["weekly_hours"] as? Int ?? 0
        self.daily_hours = dictionary["daily_hours"] as? Int ?? 0
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""
    }
}

//MARK:- COMPANY NOTIFICATION SETTING OBJECT
class CompanyNotificationSettingObject: NSObject, Codable {
    var id: Int = 0
    var company_user_id: Int = 0
    var notification_for: String = ""
    var email_notification: Int = 0
    var mobile_notification: Int = 0
    var sound_notification: Int = 0
    var created_at: String = ""
    var updated_at: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.notification_for = dictionary["notification_for"] as? String ?? ""
        self.email_notification = dictionary["email_notification"] as? Int ?? 0
        self.mobile_notification = dictionary["mobile_notification"] as? Int ?? 0
        self.sound_notification = dictionary["sound_notification"] as? Int ?? 0
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""
    }
}
