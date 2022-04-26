//
//  EmployeeTimesheetListVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class EmployeeTimesheetListVC: BaseVC {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var tblSheetList: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var btnAddTimesheet: UIButton!
    
    private var OFFSET: Int = 0
    private var PAGING_LIMIT: Int = 30
    private var requestState: REQUEST = .notStarted
    
    var arrTimesheetList: [TimesheetListObject] = []
    var arrJobList: [JobListObject] = []
    
    //OFFLINE
    var arrDBTimesheet: [EmployeePunch] = []
    var isUserOnline: Bool = false
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblNoRecord.isHidden = true
        self.tblSheetList.isHidden = true
        
        //CHEKC INTERNET CONNECTION, IF INTERNE CONNECTION IS AVAILABLE THEN GET DATA FROM API OTHERWISE GET DATA FROM LOCAL DB
        if appDelegate.isInternetConnected() == true {
            self.isUserOnline = true
            self.getTimesheetListData()
        } else {
            self.isUserOnline = false
            self.getOfflineRealmData()
        }
    }
    
    //CALL API WHEN EMPLOYEE DO MANUAL HOURS ENTRY
    @objc private func addNewlyCreatedTimesheetInList(_ notification: NSNotification) {
        if let arrTimeSheet = notification.userInfo?["timesheet"] as? [TimesheetListObject] {
            self.OFFSET = 0
            self.PAGING_LIMIT = self.arrTimesheetList.count + arrTimeSheet.count
            self.getTimesheetListData()
        }
    }
    
    //CALL API WHEN EMPLOYEE UPDATE ANY EXISTING DATA
    @objc private func updateExistingTimesheetInList(_ notification: NSNotification) {
        if let arrUpdatedTimeSheet = notification.userInfo?["timesheet"] as? [TimesheetListObject] {
            self.OFFSET = 0
            self.PAGING_LIMIT = self.arrTimesheetList.count + arrUpdatedTimeSheet.count
            self.getTimesheetListData()
        }
    }
    
    @objc private func deleteExistingTimesheetInList(_ notification: NSNotification) {
        
        self.lblNoRecord.isHidden = true
        self.tblSheetList.isHidden = true
        
        //CHEKC INTERNET CONNECTION, IF INTERNE CONNECTION IS AVAILABLE THEN GET DATA FROM API OTHERWISE GET DATA FROM LOCAL DB
        if appDelegate.isInternetConnected() == true {
            self.isUserOnline = true
            self.getTimesheetListData()
        } else {
            self.isUserOnline = false
            self.getOfflineRealmData()
        }
    }
    
    // MARK:- ACTIONS -
    @objc func profileAction() {
        let objEmployeeSettings = EmployeeSettingsObject.init([:])
        objEmployeeSettings.name = appDelegate.objEmployeeSettings.name
        objEmployeeSettings.email = appDelegate.objEmployeeSettings.email
        objEmployeeSettings.country_code = appDelegate.objEmployeeSettings.country_code
        objEmployeeSettings.phone = appDelegate.objEmployeeSettings.phone
        
        let vc = AppFunctions.employeeSettingMenuStoryBoard().instantiateViewController(withIdentifier: "EmployeeEditProfileVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func syncAction() {
        let controller = AppFunctions.employeeDashboardStoryBoard().instantiateViewController(withIdentifier: "EmployeeDashboardVC") as! EmployeeDashboardVC
        controller.isWantToShowSyncingProgress = true
        controller.isWantToSyncOnLogout = false
        controller.callSyncAPI()
    }
    
    @IBAction func btnAddTimesheetTapped(_ sender: UIButton) {
        let vc = AppFunctions.employeeTimesheetStoryBoard().instantiateViewController(withIdentifier: "EmployeeAddTimesheetVC") as! EmployeeAddTimesheetVC
        vc.arrJobList = self.arrJobList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Pagination Call
    private func nextPageForTimesheetListIfNeeded(at section: Int) {
        if self.arrTimesheetList.count >= 30 {
            if section == (self.arrTimesheetList.count - 1) {
                if requestState != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.arrTimesheetList.count
                    self.PAGING_LIMIT = 30
                    self.getTimesheetListData()
                }
            }
        }
    }
    
    // MARK:- GET OFFLINE DATA -
    
    func getOfflineRealmData() {
        self.arrTimesheetList = EmployeePunch.getAllPunchDataInAPIModel()
        self.tblSheetList.isHidden = false
        
        if self.arrTimesheetList.count > 0 {
            self.lblNoRecord.isHidden = true
        } else {
            self.lblNoRecord.isHidden = false
        }
        
        self.tblSheetList.reloadData()
    }
}

// MARK:- UITABLEVIEW DATASOURCE & DELEGATE METHOD -

extension EmployeeTimesheetListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor.init(HexCode: 0xF6F6F6)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tblSheetList.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! CustomSectionHeader
        
        let objTimesheet = self.arrTimesheetList[section]
        header.lblDate.text = AppFunctions.sharedInstance.formattedDateFromString(dateString: objTimesheet.date, InputFormat: API_RESPONSE_DATE_FORMAT, OutputFormat: headerDateFormat)
        
        var arrTimes = objTimesheet.arrPunchLog.map({ (punch: TimesheetPunchLogObject) -> String in
            punch.duration_new
        })
        arrTimes = arrTimes.filter({ $0 != "" && $0 != "-"})
        
        header.lblDifference.text = AppFunctions.sharedInstance.getTotalTime(AppFunctions.sharedInstance.getPunchLogTimeTotalDuration(times: arrTimes))
        
        /*
        if objTimesheet.arrPunchLog.count <= 0 {
            header.lblEntries.text = ""
        }
        else if objTimesheet.arrPunchLog.count == 1 {
            header.lblEntries.text = "\(objTimesheet.arrPunchLog.count) Entry"
        }
        else {
            header.lblEntries.text = "\(objTimesheet.arrPunchLog.count) Entries"
        }
        
        if self.isUserOnline == true {
            self.nextPageForTimesheetListIfNeeded(at: section)
        }
        
        header.lblDate.textColor = UIColor.init(HexCode: 0x323232)
        header.lblDifference.textColor = UIColor.init(HexCode: 0x323232)
        header.lblEntries.textColor = UIColor.init(HexCode: 0x323232)
        */
        
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrTimesheetList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objTimesheet = self.arrTimesheetList[section]
        let arrRows = objTimesheet.arrPunchLog
        return arrRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTimesheetCell", for: indexPath) as! EmployeeTimesheetCell
        
        let objTimesheet = self.arrTimesheetList[indexPath.section]
        let objPunch = objTimesheet.arrPunchLog[indexPath.row]
        
        /*
        if objPunch.objJob.job_code.isEmpty {
            cell.lblJobCode.text = "-"
        } else {
            cell.lblJobCode.text = objPunch.objJob.job_title
        }
        */
        cell.lblJobCode.text = objPunch.objJob.job_title
        
        if objPunch.note.isEmpty {
            cell.lblDescription.isHidden = true
        } else {
            cell.lblDescription.isHidden = false
            cell.lblDescription.text = objPunch.note
        }
        
//        cell.lblPunchInTime.text = objPunch.punchin_time
    
        var strPunchInOutTime: String = ""
        strPunchInOutTime = objPunch.punchin_time
        
        if objPunch.punchout_time != "Now".localized() && !objPunch.duration_new.isEmpty {
            let strDurationNew = objPunch.duration_new
            let arrTimes = strDurationNew.components(separatedBy: " ")
            
            var arrNewString = arrTimes.map { $0.replacingOccurrences(of: "h", with: "", options: .literal, range: nil) }
            arrNewString = arrNewString.map { $0.replacingOccurrences(of: "m", with: "", options: .literal, range: nil) }
            arrNewString = arrNewString.map { $0.replacingOccurrences(of: "s", with: "", options: .literal, range: nil) }
            
            let hour = arrNewString[0].convertStringToInt()
            let minute = arrNewString[1].convertStringToInt()
            let second = arrNewString[2].convertStringToInt()
            
            if (hour == 0 && minute == 0) {
                cell.lblDuration.text = String(format: "%02ds", second)
            }
            else if (hour == 0) {
                cell.lblDuration.text = String(format: "%02dm", minute)
            }
            else {
                cell.lblDuration.text = String(format: "%02dh %02dm", hour, minute)
            }
        }
        else {
            cell.lblDuration.text = objPunch.duration_new
        }
        
        if appDelegate.employeeTimesheeetStatus == 0 || objPunch.punchout_time == "Now".localized() {
//            cell.lblPunchOutTime.text = objPunch.punchout_time
            strPunchInOutTime = strPunchInOutTime + " - " + objPunch.punchout_time
        }
        else {
//            cell.lblPunchOutTime.text = objPunch.punchout_time
            strPunchInOutTime = strPunchInOutTime + " - " + objPunch.punchout_time
        }
        
        cell.lblPunchInOutTime.text = strPunchInOutTime

        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let objTimesheet = self.arrTimesheetList[indexPath.section]
        let objPunch = objTimesheet.arrPunchLog[indexPath.row]
        
        if objPunch.punchout_time != "Now".localized() && !objPunch.duration_new.isEmpty {
            let vc = AppFunctions.employeeTimesheetStoryBoard().instantiateViewController(withIdentifier: "EmployeeEditTimesheetVC") as! EmployeeEditTimesheetVC
            vc.objTimesheet = objTimesheet
            vc.objPunch = objPunch
            if appDelegate.isInternetConnected() == true {
                vc.arrJobList = self.arrJobList
            }
            else {
                vc.arrJobList = Jobs.getAllJobsInAPIModel()
                vc.arrDBTimesheet = self.arrDBTimesheet
                vc.arrTimeSheet = self.arrTimesheetList
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /*
    @objc func btnEditClick(_ sender: UIButton) {
        let objTimesheet = self.arrTimesheetList[sender.accessibilityIdentifier?.convertStringToInt() ?? 0]
        let objPunch = objTimesheet.arrPunchLog[sender.tag]
        
        let vc = AppFunctions.employeeTimesheetStoryBoard().instantiateViewController(withIdentifier: "EmployeeEditTimesheetVC") as! EmployeeEditTimesheetVC
        vc.objTimesheet = objTimesheet
        vc.objPunch = objPunch
        if appDelegate.isInternetConnected() == true {
            vc.arrJobList = self.arrJobList
        }
        else {
            vc.arrJobList = Jobs.getAllJobsInAPIModel()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnDeleteClick(_ sender: UIButton) {
        let objTimesheet = self.arrTimesheetList[sender.accessibilityIdentifier?.convertStringToInt() ?? 0]
        let objPunch = objTimesheet.arrPunchLog[sender.tag]
        
        AppFunctions.displayConfirmationAlert(self, title: "Delete Timesheet".localized(), message: "Would you like to delete this timesheet?".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "Delete".localized(), actionBlock: { (isConfirmed) in
            if isConfirmed {
                if appDelegate.isInternetConnected() == true {
                    self.isUserOnline = true
                    self.callDeleteTimesheetAPI(objTimesheet: objTimesheet, objPunch: objPunch)
                }
                else {
                    self.isUserOnline = false
                    self.callDeleteTimesheetOfflineAPI(objTimesheet: objTimesheet, objPunch: objPunch)
                }
            }
        })
    }
    */
}

//MARK:- API Call
extension EmployeeTimesheetListVC {
    func getTimesheetListData() {
        // Check Internet Available
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["limit"] = self.PAGING_LIMIT
        params["offset"] = self.OFFSET
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        self.requestState = REQUEST.started
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.EMPLOYEE_TIMESHEET, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        self.requestState = REQUEST.notStarted
                        
                        if let payloadData = response["payload"]  as? Dictionary<String, Any> {
                            
                            if let timesheet_status = payloadData["timesheet_status"] as? Int {
                                appDelegate.employeeTimesheeetStatus = timesheet_status
                                
                                if appDelegate.employeeTimesheeetStatus == 1 {
                                    self.btnAddTimesheet.isHidden = false
                                } else {
                                    self.btnAddTimesheet.isHidden = true
                                }
                            }
                            else {
                                appDelegate.employeeTimesheeetStatus = 0
                            }
                            
                            if self.OFFSET == 0 {
                                self.arrJobList.removeAll()
                                self.arrTimesheetList.removeAll()
                                
                                //JOBS LIST
                                if let jobList = payloadData["jobs"] as? [Dictionary<String, Any>] {
                                    for i in 0..<jobList.count  {
                                        let objJob = JobListObject.init(jobList[i])
                                        self.arrJobList.append(objJob)
                                    }
                                }
                            }
                            
                            //PUNCHES LIST
                            if let arrPunches = payloadData["punches"] as? [Dictionary<String, Any>] {
                                for i in 0..<arrPunches.count  {
                                    let objPunch = TimesheetListObject.init(arrPunches[i])
                                    self.arrTimesheetList.append(objPunch)
                                }
                                
                                if self.PAGING_LIMIT >= 30 {
                                    if arrPunches.count < self.PAGING_LIMIT {
                                        self.requestState = REQUEST.failedORNoMoreData
                                    }
                                }
                                
                                if self.arrTimesheetList.count > 0 {
                                    self.lblNoRecord.isHidden = true
                                } else {
                                    self.lblNoRecord.isHidden = false
                                }
                                
                                for i in 0..<self.arrTimesheetList.count  {
                                    let objTimesheet = self.arrTimesheetList[i]
                                    EmployeePunch.addPunch(objTimeSheet: objTimesheet)
                                }
                                
                                Jobs.deleteAllJobData()
                                //INSERT JOBS DATA IN DB
                                for i in 0..<self.arrJobList.count  {
                                    let objJob = self.arrJobList[i]
                                    Jobs.addJob(objJob: objJob)
                                }
                                                                
                                self.tblSheetList.isHidden = false
                                self.tblSheetList.reloadData()
                            }
                        }
                    }
                    else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        self.requestState = REQUEST.failedORNoMoreData
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
                    }
                    else {
                        self.requestState = REQUEST.failedORNoMoreData
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                    }
                }
            }
        }) { (error) in
            self.requestState = REQUEST.failedORNoMoreData
            AppFunctions.hideProgress()
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    func callDeleteTimesheetAPI(objTimesheet: TimesheetListObject, objPunch: TimesheetPunchLogObject) {
        // Check Internet Available
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["id"] = objPunch.id
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.EMPLOYEE_DELETE_MANUAL_HOURS, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        //GET LOCAL DB TIMESHEET RECORDS
                        self.arrDBTimesheet = EmployeePunch.getAllPunch()
                        
                        //DELETE SELECTED PUNCH LOG FROM LOCAL ARRAY AS WELL AS FROM DB
                        if let row = objTimesheet.arrPunchLog.firstIndex(where: {$0.id == objPunch.id}) {
                            objTimesheet.arrPunchLog.remove(at: row)
                            
                            
                            //DELETE PUNCHJOB OBJECT IF NOT USED IN PUNCHLOGS DATA
                            let arrPunchLog = EmployeePunchLogs.getAllPunchLogs()
                            let count = arrPunchLog.filter{ $0.objJob?.id == objPunch.objJob.id }.count
                            
                            if count <= 1 {
                                if let row = arrPunchLog.firstIndex(where: {$0.objJob?.id == objPunch.objJob.id}) {
                                    if let objPunchJob = arrPunchLog[row].objJob {
                                        PunchJob.deletePunch(object: objPunchJob)
                                    }
                                }
                            }
                            
                            //GET SELECTED TIMESHEET OBJECT FROM DB ARRAY & THEN FIND SELECTED PUNCH LOG OBJECT TO DELETE
                            if let row = self.arrDBTimesheet.firstIndex(where: {$0.date == objTimesheet.date}) {
                                let objTS = self.arrDBTimesheet[row]
                                if let row = objTS.arrPunchLogs.firstIndex(where: {$0.id == objPunch.id}) {
                                    //DELETE PUNCHLOG RECORD
                                    EmployeePunchLogs.deletePunchLog(object: objTS.arrPunchLogs[row])
                                }
                            }
                            
                            //DELETE MAIN TIMESHEET OBJECT FROM ARRAY AS WELL AS FROM DB IF IT DOESN'T HAVE ANY PUNCH LOG
                            if objTimesheet.arrPunchLog.count <= 0 {
                                if let row = self.arrDBTimesheet.firstIndex(where: {$0.date == objTimesheet.date}) {
                                    EmployeePunch.deletePunch(object: self.arrDBTimesheet[row])
                                }
                                
                                if let row = self.arrTimesheetList.firstIndex(where: {$0.date == objTimesheet.date}) {
                                    self.arrTimesheetList.remove(at: row)
                                }
                            }
                        }
                        
                        if self.arrTimesheetList.count > 0 {
                            self.lblNoRecord.isHidden = true
                        } else {
                            self.lblNoRecord.isHidden = false
                        }
                        
                        self.tblSheetList.reloadData()
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                    }
                    else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
                    }
                    else {
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                    }
                }
            }
        }) { (error) in
            AppFunctions.hideProgress()
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    func callDeleteTimesheetOfflineAPI(objTimesheet: TimesheetListObject, objPunch: TimesheetPunchLogObject) {
        //GET LOCAL DB TIMESHEET RECORDS
        self.arrDBTimesheet = EmployeePunch.getAllPunch()
        
        //GET SELECTED TIMESHEET OBJECT FROM DB ARRAY & THEN FIND SELECTED PUNCH LOG OBJECT TO CHAGE DELETE FLAG
        if let row = self.arrDBTimesheet.firstIndex(where: {$0.date == objTimesheet.date}) {
            let objTS = self.arrDBTimesheet[row]
            if let row = objTS.arrPunchLogs.firstIndex(where: {$0.id == objPunch.id}) {
                //DELETE PUNCHLOG FLAG
                EmployeePunchLogs.updatePunchLog(object: objTS.arrPunchLogs[row])
            }
        }
        
        //DELETE MAIN TIMESHEET OBJECT FROM ARRAY AS WELL AS FROM DB IF IT DOESN'T HAVE ANY PUNCH LOG
        if let row = self.arrDBTimesheet.firstIndex(where: {$0.date == objTimesheet.date}) {
            let count = self.arrDBTimesheet[row].arrPunchLogs.filter{ $0.is_deleted == false }.count
            if count <= 0 {
                EmployeePunch.updatePunchLog(object: self.arrDBTimesheet[row])
            }
        }
        
        self.arrTimesheetList = EmployeePunch.getAllPunchDataInAPIModel()
        
        if self.arrTimesheetList.count > 0 {
            self.lblNoRecord.isHidden = true
        } else {
            self.lblNoRecord.isHidden = false
        }
        
        self.tblSheetList.reloadData()
        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "Timesheet deleted successfully".localized())
    }
}
