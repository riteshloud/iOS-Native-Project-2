//
//  EmployeePunchJob.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import RealmSwift

class PunchJob: Object {
    @objc dynamic var id = Int()
    @objc dynamic var job_code = String()
    @objc dynamic var job_title = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // DELETE PARTICULAR PUNCH JOB FROM ODB
    class func deletePunch(object: PunchJob) {
        do {
            try Database.shared.realm.write {
//                object.is_deleted = true
            }
            Database.shared.delete(object: object)
        } catch {
            
        }
    }
    
    // GET ALL PUNCH JOB
    class func getAllPunchJob() -> [PunchJob] {
        let data = Database.shared.realm.objects(PunchJob.self).sorted(byKeyPath: "id", ascending: false)
        return Array(data)
    }
}
