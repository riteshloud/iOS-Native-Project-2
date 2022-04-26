//
//  EmployeePunchLogs.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import Foundation
import RealmSwift

class EmployeePunchLogs: Object {
    
    @objc dynamic var id = Int()
    @objc dynamic var guid = String()
    @objc dynamic var punchin_time = String()
    @objc dynamic var punchout_time = String()
    @objc dynamic var punchInLatitude = String()
    @objc dynamic var punchInLongitude = String()
    @objc dynamic var punchOutLatitude = String()
    @objc dynamic var punchOutLongitude = String()
    @objc dynamic var duration = String()
    @objc dynamic var note = String()
    @objc dynamic var timezone = String()
    @objc dynamic var is_updated = Bool()
    @objc dynamic var is_deleted = Bool()
    
    @objc dynamic var objJob:PunchJob?
    
    override static func primaryKey() -> String? {
        return "id"
    }
  
    class func updatePunchLog(object: EmployeePunchLogs) {
        do {
            try Database.shared.realm.write {
                object.is_deleted = true
            }
            Database.shared.update(object: object)
        } catch {
            
        }
    }
    
    class func deletePunchLog(object: EmployeePunchLogs) {
        do {
            try Database.shared.realm.write {
//                object.is_deleted = true
            }
            Database.shared.delete(object: object)
        } catch {
            
        }
    }
    
    class func getAllPunchLogs() -> [EmployeePunchLogs] {
        let data = Database.shared.realm.objects(EmployeePunchLogs.self).filter("is_deleted == false") .sorted(byKeyPath: "id", ascending: false)
        return Array(data)
    }
    
    class func getAllPunchLogsIncludingDeletedRecords() -> [EmployeePunchLogs] {
        let data = Database.shared.realm.objects(EmployeePunchLogs.self).sorted(byKeyPath: "id", ascending: false)
        return Array(data)
    }
    
    class func getAllActivePunchLogs() -> [EmployeePunchLogs] {
        let data = Database.shared.realm.objects(EmployeePunchLogs.self).filter("punchout_time == \"Now\"") .sorted(byKeyPath: "id", ascending: false)
        return Array(data)
    }
}
