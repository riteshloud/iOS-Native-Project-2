//
//  Jobs.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import RealmSwift

class Jobs: Object {
    @objc dynamic var id = Int()
    @objc dynamic var job_title = String()
    @objc dynamic var job_code = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // ADD/UPDATE JOB DATA IN DB
    class func addJob(objJob: JobListObject) {
        Database.shared.realm.beginWrite()
        let object: Jobs = Jobs()
        object.id = objJob.id
        object.job_title = objJob.job_title
        object.job_code = objJob.job_code
        Database.shared.add(object: object)
        
        do {
            try Database.shared.realm.commitWrite()
        }
        catch {
            
        }
    }
    
    // DELETE ALL JOBS DATA FROM DB
    class func deleteAllJobData() {
        do {
            try Database.shared.realm.write {
                let allJobs = Database.shared.realm.objects(Jobs.self)
                Database.shared.realm.delete(allJobs)
            }
        } catch {
            
        }
    }
    
    // GET ALL JOBS DATA IN DB MODEL
    class func getAllJob() -> [Jobs] {
        let data = Database.shared.realm.objects(Jobs.self).sorted(byKeyPath: "id", ascending: false)
        return Array(data)
    }
    
    // GET ALL JOBS DATA IN API MODEL
    class func getAllJobsInAPIModel() -> [JobListObject] {
        let arrData = Jobs.getAllJob()
        
        var arrJobs: [JobListObject] = []
        
        for i in 0..<arrData.count {
            let objDBJob = arrData[i]
            let objJob = JobListObject.init([:])
            
            objJob.id = objDBJob.id
            objJob.job_title = objDBJob.job_title
            objJob.job_code = objDBJob.job_code
            arrJobs.append(objJob)
        }
        
        return arrJobs
    }
}
