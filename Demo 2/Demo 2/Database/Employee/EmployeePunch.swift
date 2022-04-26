//
//  EmployeePunch.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import RealmSwift

class EmployeePunch: Object {
    @objc dynamic var date = String()
    var arrPunchLogs = List<EmployeePunchLogs>()
    @objc dynamic var is_updated = Bool()
    @objc dynamic var is_deleted = Bool()
    
    override static func primaryKey() -> String? {
        return "date"
    }
    
    //MARK:- ADD/UPDATE PUNCH DATA IN DB
    class func addPunch(objTimeSheet: TimesheetListObject) {
        let arrPunch = self.getAllPunch()
        
        Database.shared.realm.beginWrite()
        let object: EmployeePunch = EmployeePunch()
        object.date = objTimeSheet.date
        
        if let row = arrPunch.firstIndex(where: {$0.date == objTimeSheet.date}) {
            for i in 0..<arrPunch[row].arrPunchLogs.count  {
                object.arrPunchLogs.append(arrPunch[row].arrPunchLogs[i])
            }
        }
        
        for i in 0..<objTimeSheet.arrPunchLog.count  {
            let objPunchLog = objTimeSheet.arrPunchLog[i]
            let objectPunchLog: EmployeePunchLogs = EmployeePunchLogs()
            objectPunchLog.id = objPunchLog.id
            objectPunchLog.guid = objPunchLog.guID
            objectPunchLog.punchin_time = objPunchLog.punchin_time
            objectPunchLog.punchout_time = objPunchLog.punchout_time
            objectPunchLog.punchInLatitude = objPunchLog.punchInLatitude
            objectPunchLog.punchInLongitude = objPunchLog.punchInLongitude
            objectPunchLog.punchOutLatitude = objPunchLog.punchOutLatitude
            objectPunchLog.punchOutLongitude = objPunchLog.punchOutLongitude
            objectPunchLog.duration = objPunchLog.duration_new
            objectPunchLog.note = objPunchLog.note
            objectPunchLog.timezone = objPunchLog.timezone
            objectPunchLog.is_updated = objPunchLog.is_updated
            objectPunchLog.is_deleted = objPunchLog.is_deleted
            
            if objPunchLog.objJob.id > 0 {
                let objPunchJob: PunchJob = PunchJob()
                objPunchJob.id = objPunchLog.objJob.id
                objPunchJob.job_code = objPunchLog.objJob.job_code
                objPunchJob.job_title = objPunchLog.objJob.job_title
                objectPunchLog.objJob = objPunchJob
            }
            
            if let row = object.arrPunchLogs.firstIndex(where: {$0.id == objPunchLog.id}) {
                debugPrint("PUNCHLOG UPDATED")
                object.arrPunchLogs[row] = objectPunchLog
            }
            else {
                debugPrint("NEW PUNCHLOG CREATED")
                object.arrPunchLogs.insert(objectPunchLog, at: 0)
//                object.arrPunchLogs.append(objectPunchLog)
            }
        }
        Database.shared.add(object: object)
        
        do {
            try Database.shared.realm.commitWrite()
        }
        catch {
            
        }
    }
    
    //MARK:- GET ACTIVE PUNCH LOG FROM DB
    class func getAnyActivePunchLogInDatabase() -> TimesheetListObject {
        let arrPunches = self.getAllPunch()
        
        let objTimesheet = TimesheetListObject.init([:])
        
        var objActivePunchLog: EmployeePunchLogs?
        for i in 0..<arrPunches.count  {
            let objPunch = arrPunches[i]
            
            let objActivePL = objPunch.arrPunchLogs.filter { $0.punchout_time == "Now" }.first
            if objActivePL != nil {
                objTimesheet.date = objPunch.date
                
                let objPunchLog = TimesheetPunchLogObject.init([:])
                
                objPunchLog.id = objActivePL!.id
                objPunchLog.guID = objActivePL!.guid
                objPunchLog.punchin_time = objActivePL!.punchin_time
                objPunchLog.punchout_time = objActivePL!.punchout_time
                objPunchLog.punchInLatitude = objActivePL!.punchInLatitude
                objPunchLog.punchInLongitude = objActivePL!.punchInLongitude
                objPunchLog.punchOutLatitude = objActivePL!.punchOutLatitude
                objPunchLog.punchOutLongitude = objActivePL!.punchOutLongitude
                objPunchLog.duration_new = objActivePL!.duration
                objPunchLog.note = objActivePL!.note
                objPunchLog.timezone = objActivePL!.timezone
                
                let objDBJob = objActivePL!.objJob
                let objJob = JobListObject.init([:])
                objJob.id = objDBJob?.id ?? 0
                objJob.job_code = objDBJob?.job_code ?? ""
                objJob.job_title = objDBJob?.job_title ?? ""
                
                objPunchLog.objJob = objJob
                objTimesheet.arrPunchLog.append(objPunchLog)
            }
            objActivePunchLog = objActivePL
            
            if objActivePunchLog != nil {
                break
            }
        }
        
        return objTimesheet
    }
    
    //MARK:- UPDATE PUNCH LOG
    class func updatePunchLog(object: EmployeePunch) {
        do {
            try Database.shared.realm.write {
                object.is_deleted = true
            }
            Database.shared.update(object: object)
        } catch {
            
        }
    }
    
    //MARK:- DELETE PUNCH LOG
    class func deletePunch(object: EmployeePunch) {
        do {
            try Database.shared.realm.write {
                object.is_deleted = true
            }
            Database.shared.delete(object: object)
        } catch {
            
        }
    }
    
    //MARK:- GET ALL PUNCH DATA FROM DB
    class func getAllPunch() -> [EmployeePunch] {
        let data = Database.shared.realm.objects(EmployeePunch.self).filter("is_deleted == false") .sorted(byKeyPath: "date", ascending: false)
        return Array(data)
    }
    
    class func getAllPunchIncludingDeletedRecords() -> [EmployeePunch] {
        let data = Database.shared.realm.objects(EmployeePunch.self).sorted(byKeyPath: "date", ascending: false)
        return Array(data)
    }
    
    class func getAllPunchToGetAddedUpdatedDeletedData() -> [EmployeePunch] {
        let data = Database.shared.realm.objects(EmployeePunch.self).sorted(byKeyPath: "date", ascending: false)
        return Array(data)
    }
    
    //MARK:- GET ALL PUNCH DATA IN API MODEL
    class func getAllPunchDataInAPIModel() -> [TimesheetListObject] {
        let arrData = EmployeePunch.getAllPunch()
        
        var arrTimesheet: [TimesheetListObject] = []
        
        for i in 0..<arrData.count {
            let objDBPunch = arrData[i]
            let objTimesheet = TimesheetListObject.init([:])
            
            objTimesheet.date = objDBPunch.date
            
            for j in 0..<objDBPunch.arrPunchLogs.count {
                let objDBPunchLog = objDBPunch.arrPunchLogs[j]
                if !objDBPunchLog.is_deleted {
                    let objPunchLog = TimesheetPunchLogObject.init([:])
                    
                    objPunchLog.id = objDBPunchLog.id
                    objPunchLog.guID = objDBPunchLog.guid
//                    objPunchLog.punchin_time = objDBPunchLog.punchin_time
//                    objPunchLog.punchout_time = objDBPunchLog.punchout_time
                    
                    if objDBPunchLog.punchin_time.contains("am") || objDBPunchLog.punchin_time.contains("AM") || objDBPunchLog.punchin_time.contains("pm") || objDBPunchLog.punchin_time.contains("PM") {
                        
                        if globalTimeFormat == twelveHoursTimeFormat {
                            objPunchLog.punchin_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchin_time, InputFormat: fullToShortTimeFormat, OutputFormat: fullToShortTimeFormat)!.uppercased()
                        }
                        else if globalTimeFormat == twentryFourHoursTimeFormat {
                            objPunchLog.punchin_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchin_time, InputFormat: fullToShortTimeFormat, OutputFormat: API_REQUEST_TIME_FORMAT)!.uppercased()
                        }
                    }
                    else {
                        if globalTimeFormat == twelveHoursTimeFormat {
                            objPunchLog.punchin_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchin_time, InputFormat: API_REQUEST_TIME_FORMAT, OutputFormat: fullToShortTimeFormat)!.uppercased()
                        }
                        else if globalTimeFormat == twentryFourHoursTimeFormat {
                            objPunchLog.punchin_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchin_time, InputFormat: API_REQUEST_TIME_FORMAT, OutputFormat: API_REQUEST_TIME_FORMAT)!.uppercased()
                        }
//                        objPunchLog.punchin_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchin_time, InputFormat: API_REQUEST_TIME_FORMAT, OutputFormat: globalTimeFormat)!
                    }
                    
                    if objDBPunchLog.punchout_time == "Now".localized() {
                        objPunchLog.punchout_time = objDBPunchLog.punchout_time
                    }
                    else {
                        if objDBPunchLog.punchout_time.contains("am") || objDBPunchLog.punchout_time.contains("AM") || objDBPunchLog.punchout_time.contains("pm") || objDBPunchLog.punchout_time.contains("PM") {
                            
                            if globalTimeFormat == twelveHoursTimeFormat {
                                objPunchLog.punchout_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchout_time, InputFormat: fullToShortTimeFormat, OutputFormat: fullToShortTimeFormat)!.uppercased()
                            }
                            else if globalTimeFormat == twentryFourHoursTimeFormat {
                                objPunchLog.punchout_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchout_time, InputFormat: fullToShortTimeFormat, OutputFormat: API_REQUEST_TIME_FORMAT)!.uppercased()
                            }
                            //                        objPunchLog.punchout_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchout_time, InputFormat: fullToShortTimeFormat, OutputFormat: globalTimeFormat)!.capitalized
                        }
                        else {
                            if globalTimeFormat == twelveHoursTimeFormat {
                                objPunchLog.punchout_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchout_time, InputFormat: API_REQUEST_TIME_FORMAT, OutputFormat: fullToShortTimeFormat)!.uppercased()
                            }
                            else if globalTimeFormat == twentryFourHoursTimeFormat {
                                objPunchLog.punchout_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchout_time, InputFormat: API_REQUEST_TIME_FORMAT, OutputFormat: API_REQUEST_TIME_FORMAT)!.uppercased()
                            }
                            
                            //                        objPunchLog.punchout_time = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunchLog.punchout_time, InputFormat: API_REQUEST_TIME_FORMAT, OutputFormat: globalTimeFormat)!
                        }
                    }
                    
                    objPunchLog.punchInLatitude = objDBPunchLog.punchInLatitude
                    objPunchLog.punchInLongitude = objDBPunchLog.punchInLongitude
                    objPunchLog.punchOutLatitude = objDBPunchLog.punchOutLatitude
                    objPunchLog.punchOutLongitude = objDBPunchLog.punchOutLongitude
                    objPunchLog.duration_new = objDBPunchLog.duration
                    objPunchLog.note = objDBPunchLog.note
                    objPunchLog.timezone = objDBPunchLog.timezone
                    
                    let objDBJob = objDBPunchLog.objJob
                    let objJob = JobListObject.init([:])
                    objJob.id = objDBJob?.id ?? 0
                    objJob.job_code = objDBJob?.job_code ?? ""
                    objJob.job_title = objDBJob?.job_title ?? ""
                    
                    objPunchLog.objJob = objJob
                    objTimesheet.arrPunchLog.append(objPunchLog)
                }
                
            }
            arrTimesheet.append(objTimesheet)
        }
        
        return arrTimesheet
    }
    
    //MARK:- GET DAY OBJECT TO CALCULATE EARNING
    class func getDayPunchLogToCalculateTotal() -> TimesheetListObject {
        let arrData = EmployeePunch.getAllPunch()
        
        var objCurrentDayTimesheet = TimesheetListObject.init([:])
        
        for i in 0..<arrData.count {
            let objDBPunch = arrData[i]
            let objTimesheet = TimesheetListObject.init([:])
            
            objTimesheet.date = objDBPunch.date
            
            if objDBPunch.date == Date().getOnlydateInNumbers() {
                for j in 0..<objDBPunch.arrPunchLogs.count {
                    let objDBPunchLog = objDBPunch.arrPunchLogs[j]
                    if !objDBPunchLog.is_deleted {
                        let objPunchLog = TimesheetPunchLogObject.init([:])
                        
                        objPunchLog.id = objDBPunchLog.id
                        objPunchLog.guID = objDBPunchLog.guid
                        objPunchLog.punchin_time = objDBPunchLog.punchin_time
                        objPunchLog.punchout_time = objDBPunchLog.punchout_time
                        objPunchLog.punchInLatitude = objDBPunchLog.punchInLatitude
                        objPunchLog.punchInLongitude = objDBPunchLog.punchInLongitude
                        objPunchLog.punchOutLatitude = objDBPunchLog.punchOutLatitude
                        objPunchLog.punchOutLongitude = objDBPunchLog.punchOutLongitude
                        objPunchLog.duration_new = objDBPunchLog.duration
                        objPunchLog.note = objDBPunchLog.note
                        objPunchLog.timezone = objDBPunchLog.timezone
                        
                        let objDBJob = objDBPunchLog.objJob
                        let objJob = JobListObject.init([:])
                        objJob.id = objDBJob?.id ?? 0
                        objJob.job_code = objDBJob?.job_code ?? ""
                        objJob.job_title = objDBJob?.job_title ?? ""
                        
                        objPunchLog.objJob = objJob
                        objTimesheet.arrPunchLog.append(objPunchLog)
                    }
                }
                
                objCurrentDayTimesheet = objTimesheet
            }
        }
        return objCurrentDayTimesheet
    }
    
    //MARK:- GET WEEK OBJECTS TO CALCULATE EARNING
    class func getWeekPunchLogToCalculateTotal(strWeekDay: String) -> [TimesheetListObject] {
        let arrData = EmployeePunch.getAllPunch()
        
        var arrTimesheet: [TimesheetListObject] = []
        
        
        //************************* WEEK TOTAL CALCULATION LOGIC ****************************
        
        //TO FIND WEEK TOTAL, FIRST OF WE TAKE CURRET DATE AND IT'S WEEK START DAY AND THEN WE CHECK IF CURRENT DATE WEEK START DAY AND USER WEEK START DAY ARE SAME OR NOT. IF THEY ARE NOT SAME THEN DESCREASE 1 DAY FROM CURRENT DATE AND AGAIN COMPARE THAT NEW DATE WEEK START DAY WITH USER WEEK START DAY. IF THEY ARE SAME THEN WE FOUND OUT WEEK START DATE.
        
        //GET CURRENT DATE
        let strCurrentDate = AppFunctions.sharedInstance.formattedDateFromString(dateString: Date().getOnlydateInNumbers()!, InputFormat: API_RESPONSE_DATE_FORMAT, OutputFormat: "EEEE yyyy-MM-dd")
        debugPrint(strCurrentDate!)
        var dtCurrent: Date = AppFunctions.sharedInstance.convertStringToDate(StrDate: strCurrentDate!, DateFormat: "EEEE yyyy-MM-dd")
        
        var dtWeekStart: Date!
        
        var i = 0
        while i < 8 {
            if self.getDayOfWeek(date: dtCurrent).lowercased() == strWeekDay.lowercased() {
                debugPrint("YOUR WEEKDAY IS -> \(self.getDayOfWeek(date: dtCurrent))")
                
                //SET WEEK START DATE
                dtWeekStart = dtCurrent
                break
            }
            else {
                //DESCREASE 1 DAY FROM DATE
                debugPrint("DAYS IN WEEKS ARE -> \(self.getDayOfWeek(date: dtCurrent))")
                let calendar = Calendar.current
                let remove1DayFromDate = calendar.date(byAdding: .day, value: -1, to: dtCurrent)
                dtCurrent = remove1DayFromDate ?? Date()
                debugPrint(dtCurrent)
            }
            i += 1
            debugPrint(i)
        }
        
        for i in 0..<arrData.count {
            let objDBPunch = arrData[i]
            let objTimesheet = TimesheetListObject.init([:])

            objTimesheet.date = objDBPunch.date
            let strTimesheetDate = AppFunctions.sharedInstance.formattedDateFromString(dateString: objDBPunch.date, InputFormat: API_RESPONSE_DATE_FORMAT, OutputFormat: "EEEE yyyy-MM-dd")
            let dtTimesheet: Date = AppFunctions.sharedInstance.convertStringToDate(StrDate: strTimesheetDate!, DateFormat: "EEEE yyyy-MM-dd")
            
            for j in 0..<objDBPunch.arrPunchLogs.count {
                let objDBPunchLog = objDBPunch.arrPunchLogs[j]
                if !objDBPunchLog.is_deleted {
                    let objPunchLog = TimesheetPunchLogObject.init([:])

                    objPunchLog.id = objDBPunchLog.id
                    objPunchLog.guID = objDBPunchLog.guid
                    objPunchLog.punchin_time = objDBPunchLog.punchin_time
                    objPunchLog.punchout_time = objDBPunchLog.punchout_time
                    objPunchLog.punchInLatitude = objDBPunchLog.punchInLatitude
                    objPunchLog.punchInLongitude = objDBPunchLog.punchInLongitude
                    objPunchLog.punchOutLatitude = objDBPunchLog.punchOutLatitude
                    objPunchLog.punchOutLongitude = objDBPunchLog.punchOutLongitude
                    objPunchLog.duration_new = objDBPunchLog.duration
                    objPunchLog.note = objDBPunchLog.note
                    objPunchLog.timezone = objDBPunchLog.timezone
                    
                    let objDBJob = objDBPunchLog.objJob
                    let objJob = JobListObject.init([:])
                    objJob.id = objDBJob?.id ?? 0
                    objJob.job_code = objDBJob?.job_code ?? ""
                    objJob.job_title = objDBJob?.job_title ?? ""

                    objPunchLog.objJob = objJob
                    objTimesheet.arrPunchLog.append(objPunchLog)
                }
            }
            
            if dtTimesheet == dtWeekStart || dtTimesheet > dtWeekStart {
                arrTimesheet.append(objTimesheet)
            }
        }
        return arrTimesheet
    }
    
    class func getDayOfWeek(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }
    
    //MARK:- GET NEWLY ADDED PUNCHES DATA
    class func getNewlyAddedPunchesData() -> [Dictionary<String, Any>] {
        let arrData = EmployeePunch.getAllPunchToGetAddedUpdatedDeletedData()
        
        var arrNewlyAddedTimesheet: [Dictionary<String, Any>] = []
        
//        var arrTimesheet: [TimesheetListObject] = []
        
        for i in 0..<arrData.count {
            let objDBPunch = arrData[i]
//            let objTimesheet = TimesheetListObject.init([:])
            
            var arrDictPunchLogs = [Dictionary<String, Any>]()
                
//            objTimesheet.date = objDBPunch.date
            
            var dictTimesheet = Dictionary<String, Any>()
            dictTimesheet["date"] = objDBPunch.date
            
            for j in 0..<objDBPunch.arrPunchLogs.count {
                let objDBPunchLog = objDBPunch.arrPunchLogs[j]
                var dictDBPunchLog = Dictionary<String, Any>()
                
                if !objDBPunchLog.is_deleted {
                    if objDBPunchLog.id == objDBPunchLog.guid.convertStringToInt() { //objDBPunchLog.guid.isEmpty {
                        dictDBPunchLog["id"] = objDBPunchLog.id
                        dictDBPunchLog["timezone"] = objDBPunchLog.timezone
                        dictDBPunchLog["guid"] = objDBPunchLog.guid
                        dictDBPunchLog["is_updated"] = objDBPunchLog.is_updated
                        dictDBPunchLog["is_deleted"] = objDBPunchLog.is_deleted
                        dictDBPunchLog["punchin_time"] = objDBPunchLog.punchin_time
                        dictDBPunchLog["punchout_time"] = objDBPunchLog.punchout_time
                        
                        //PUNCH LOCATION
                        var dictPunchLocation = Dictionary<String, Any>()
                        if !objDBPunchLog.punchInLatitude.isEmpty {
                            dictPunchLocation["lat"] = objDBPunchLog.punchInLatitude
                        }
                        if !objDBPunchLog.punchInLongitude.isEmpty {
                            dictPunchLocation["lon"] = objDBPunchLog.punchInLongitude
                        }
                        
                        dictDBPunchLog["punch_location"] = dictPunchLocation
                        
                        //PUNCHOUT LOCATION
                        var dictPunchOutLocation = Dictionary<String, Any>()
                        if !objDBPunchLog.punchOutLatitude.isEmpty {
                            dictPunchOutLocation["lat"] = objDBPunchLog.punchOutLatitude
                        }
                        if !objDBPunchLog.punchOutLongitude.isEmpty {
                            dictPunchOutLocation["lon"] = objDBPunchLog.punchOutLongitude
                        }
                        dictDBPunchLog["punchout_location"] = dictPunchOutLocation
                        
                        dictDBPunchLog["duration"] = objDBPunchLog.duration
                        dictDBPunchLog["note"] = objDBPunchLog.note
                        
                        //JOB
                        var dictJob = Dictionary<String, Any>()
                        if objDBPunchLog.objJob != nil {
                            dictJob["id"] = objDBPunchLog.objJob?.id
                            dictJob["job_code"] = objDBPunchLog.objJob?.job_code
                            dictJob["job_title"] = objDBPunchLog.objJob?.job_title
                            dictDBPunchLog["jobs"] = dictJob
                        }
                        
                        arrDictPunchLogs.append(dictDBPunchLog)
                        dictTimesheet["punch_logs"] = arrDictPunchLogs
                    }
                }
            }
            
            if let arrAddedPunchLogs = dictTimesheet["punch_logs"] as? [Dictionary<String, Any>], arrAddedPunchLogs.count > 0 {
                arrNewlyAddedTimesheet.append(dictTimesheet)
            }
        }
        return arrNewlyAddedTimesheet
    }
    
    //MARK:- GET UPDATED PUNCHES DATA
    class func getUpdatedPunchesData() -> [Dictionary<String, Any>] {
        let arrData = EmployeePunch.getAllPunchToGetAddedUpdatedDeletedData()
        
        var arrUpdatedTimesheet: [Dictionary<String, Any>] = []
        
        for i in 0..<arrData.count {
            let objDBPunch = arrData[i]
            var arrDictPunchLogs = [Dictionary<String, Any>]()
            
            var dictTimesheet = Dictionary<String, Any>()
            dictTimesheet["date"] = objDBPunch.date
            
            for j in 0..<objDBPunch.arrPunchLogs.count {
                let objDBPunchLog = objDBPunch.arrPunchLogs[j]
                var dictDBPunchLog = Dictionary<String, Any>()
                
                if objDBPunchLog.is_updated == true && objDBPunchLog.is_deleted == false {
                    dictDBPunchLog["id"] = objDBPunchLog.id
                    dictDBPunchLog["timezone"] = objDBPunchLog.timezone
                    dictDBPunchLog["guid"] = objDBPunchLog.guid
                    dictDBPunchLog["is_updated"] = objDBPunchLog.is_updated
                    dictDBPunchLog["is_deleted"] = objDBPunchLog.is_deleted
                    dictDBPunchLog["punchin_time"] = objDBPunchLog.punchin_time
                    dictDBPunchLog["punchout_time"] = objDBPunchLog.punchout_time
                    
                    //PUNCH LOCATION
                    var dictPunchLocation = Dictionary<String, Any>()
                    if !objDBPunchLog.punchInLatitude.isEmpty {
                        dictPunchLocation["lat"] = objDBPunchLog.punchInLatitude
                    }
                    if !objDBPunchLog.punchInLongitude.isEmpty {
                        dictPunchLocation["lon"] = objDBPunchLog.punchInLongitude
                    }
                    
                    dictDBPunchLog["punch_location"] = dictPunchLocation
                    
                    //PUNCHOUT LOCATION
                    var dictPunchOutLocation = Dictionary<String, Any>()
                    if !objDBPunchLog.punchOutLatitude.isEmpty {
                        dictPunchOutLocation["lat"] = objDBPunchLog.punchOutLatitude
                    }
                    if !objDBPunchLog.punchOutLongitude.isEmpty {
                        dictPunchOutLocation["lon"] = objDBPunchLog.punchOutLongitude
                    }
                    dictDBPunchLog["punchout_location"] = dictPunchOutLocation
                    
                    dictDBPunchLog["duration"] = objDBPunchLog.duration
                    dictDBPunchLog["note"] = objDBPunchLog.note
                    
                    //JOB
                    var dictJob = Dictionary<String, Any>()
                    if objDBPunchLog.objJob != nil {
                        dictJob["id"] = objDBPunchLog.objJob?.id
                        dictJob["job_code"] = objDBPunchLog.objJob?.job_code
                        dictJob["job_title"] = objDBPunchLog.objJob?.job_title
                        dictDBPunchLog["jobs"] = dictJob
                    }
                    
                    arrDictPunchLogs.append(dictDBPunchLog)
                    dictTimesheet["punch_logs"] = arrDictPunchLogs
                }
            }
            
            if let arrUpdatedPunchLogs = dictTimesheet["punch_logs"] as? [Dictionary<String, Any>], arrUpdatedPunchLogs.count > 0 {
                arrUpdatedTimesheet.append(dictTimesheet)
            }
        }
        return arrUpdatedTimesheet
    }
    
    //MARK:- GET DELETED PUNCHES DATA
    class func getDeletedPunchesData() -> [Dictionary<String, Any>] {
        let arrData = EmployeePunch.getAllPunchToGetAddedUpdatedDeletedData()
        
        var arrDeletedTimesheet: [Dictionary<String, Any>] = []
        
        for i in 0..<arrData.count {
            let objDBPunch = arrData[i]
            var arrDictPunchLogs = [Dictionary<String, Any>]()
            
            var dictTimesheet = Dictionary<String, Any>()
            dictTimesheet["date"] = objDBPunch.date
            
            for j in 0..<objDBPunch.arrPunchLogs.count {
                let objDBPunchLog = objDBPunch.arrPunchLogs[j]
                var dictDBPunchLog = Dictionary<String, Any>()
                
                if objDBPunchLog.is_deleted == true {
                    dictDBPunchLog["id"] = objDBPunchLog.id
                    dictDBPunchLog["timezone"] = objDBPunchLog.timezone
                    dictDBPunchLog["guid"] = objDBPunchLog.guid
                    dictDBPunchLog["is_updated"] = objDBPunchLog.is_updated
                    dictDBPunchLog["is_deleted"] = objDBPunchLog.is_deleted
                    dictDBPunchLog["punchin_time"] = objDBPunchLog.punchin_time
                    dictDBPunchLog["punchout_time"] = objDBPunchLog.punchout_time
                    
                    //PUNCH LOCATION
                    var dictPunchLocation = Dictionary<String, Any>()
                    if !objDBPunchLog.punchInLatitude.isEmpty {
                        dictPunchLocation["lat"] = objDBPunchLog.punchInLatitude
                    }
                    if !objDBPunchLog.punchInLongitude.isEmpty {
                        dictPunchLocation["lon"] = objDBPunchLog.punchInLongitude
                    }
                    
                    dictDBPunchLog["punch_location"] = dictPunchLocation
                    
                    //PUNCHOUT LOCATION
                    var dictPunchOutLocation = Dictionary<String, Any>()
                    if !objDBPunchLog.punchOutLatitude.isEmpty {
                        dictPunchOutLocation["lat"] = objDBPunchLog.punchOutLatitude
                    }
                    if !objDBPunchLog.punchOutLongitude.isEmpty {
                        dictPunchOutLocation["lon"] = objDBPunchLog.punchOutLongitude
                    }
                    dictDBPunchLog["punchout_location"] = dictPunchOutLocation
                    
                    dictDBPunchLog["duration"] = objDBPunchLog.duration
                    dictDBPunchLog["note"] = objDBPunchLog.note
                    
                    //JOB
                    var dictJob = Dictionary<String, Any>()
                    if objDBPunchLog.objJob != nil {
                        dictJob["id"] = objDBPunchLog.objJob?.id
                        dictJob["job_code"] = objDBPunchLog.objJob?.job_code
                        dictJob["job_title"] = objDBPunchLog.objJob?.job_title
                        dictDBPunchLog["jobs"] = dictJob
                    }
                    
                    arrDictPunchLogs.append(dictDBPunchLog)
                    dictTimesheet["punch_logs"] = arrDictPunchLogs
                }
            }
            
            if let arrDeletedPunchLogs = dictTimesheet["punch_logs"] as? [Dictionary<String, Any>], arrDeletedPunchLogs.count > 0 {
                arrDeletedTimesheet.append(dictTimesheet)
            }
        }
        return arrDeletedTimesheet
    }
    
    //MARK:- DELETE RECORDS FROM REALM WHICH RECEIVED FROM SYNC API (DELETED)
    class func deleteRecordsFromRealm(objTimeSheet: TimesheetListObject) {
        let arrDBTimesheet = EmployeePunch.getAllPunchIncludingDeletedRecords()
        
        self.deletePunchLogFromRealm(arrPunchLogsToDelete: objTimeSheet.arrPunchLog)
        
        /*
        //DELETE PUNCHJOB OBJECT IF NOT USED IN PUNCHLOGS DATA
        let arrPunchLog = EmployeePunchLogs.getAllPunchLogs()
        let arrPunchJobs = PunchJob.getAllPunchJob()
        
        for i in 0..<arrPunchJobs.count {
            let objPunchJob = arrPunchJobs[i]
            
            let count = arrPunchLog.filter{ $0.objJob?.id == objPunchJob.id }.count
            if count <= 0 {
                PunchJob.deletePunch(object: objPunchJob)
            }
        }
        */
        
        //DELETE MAIN TIMESHEET OBJECT FROM DB IF IT DOESN'T HAVE ANY PUNCH LOG
        if let objDeletedTimesheet = arrDBTimesheet.filter({ $0.date == objTimeSheet.date}).first {
            if objDeletedTimesheet.arrPunchLogs.count <= 0 {
                EmployeePunch.deletePunch(object: objDeletedTimesheet)
            }
        }
    }
    
    class func deletePunchLogFromRealm(arrPunchLogsToDelete: [TimesheetPunchLogObject]) {
        let arrDBPunchLogs = EmployeePunchLogs.getAllPunchLogsIncludingDeletedRecords()
        
        var punchLogs = [EmployeePunchLogs]()
        
        for i in 0..<arrDBPunchLogs.count {
            let objDBPunchLog = arrDBPunchLogs[i]
            
            for j in 0..<arrPunchLogsToDelete.count {
                let objPunchLogToDelete = arrPunchLogsToDelete[j]
                
                if objPunchLogToDelete.id == objDBPunchLog.id {
                    if let objPunchLog = arrDBPunchLogs.filter({ $0.id == objPunchLogToDelete.id}).first {
                        punchLogs.append(objPunchLog)
                    }
                }
            }
        }
        
        try! Database.shared.realm.write {
            Database.shared.realm.delete(punchLogs)
        }
    }
    
    //MARK:- ADD NEW RECORDS TO REALM WHICH RECEIVED FROM SYNC API (ADDED)
    class func addNewlyAddedDataInRealm(objTimesheet: TimesheetListObject) {
        let arrDBTimesheet = EmployeePunch.getAllPunch()
        let arrDBPunchLogs = EmployeePunchLogs.getAllPunchLogs()
        
        var offlinePunchLogsToDelete = [EmployeePunchLogs]()
        
        for i in 0..<arrDBPunchLogs.count {
            let objDBPunchLog = arrDBPunchLogs[i]
            
            for j in 0..<objTimesheet.arrPunchLog.count {
                let objPunchLogToDelete = objTimesheet.arrPunchLog[j]
                
                if String(objDBPunchLog.id) == objDBPunchLog.guid {
                    if objPunchLogToDelete.guID == objDBPunchLog.guid {
                        offlinePunchLogsToDelete.append(objDBPunchLog)
                    }
                }
            }
        }
        
        try! Database.shared.realm.write {
            Database.shared.realm.delete(offlinePunchLogsToDelete)
        }
        
        //DELETE MAIN TIMESHEET OBJECT FROM DB IF IT DOESN'T HAVE ANY PUNCH LOG
        if let objDeletedTimesheet = arrDBTimesheet.filter({ $0.date == objTimesheet.date}).first {
            if objDeletedTimesheet.arrPunchLogs.count <= 0 {
                EmployeePunch.deletePunch(object: objDeletedTimesheet)
            }
        }
        
        self.addPunch(objTimeSheet: objTimesheet)
    }
}
