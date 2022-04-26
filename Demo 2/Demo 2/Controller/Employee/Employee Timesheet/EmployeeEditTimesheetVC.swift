//
//  EmployeeEditTimesheetVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyJSON

class EmployeeEditTimesheetVC: BaseVC {

    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var lblInTitle: UILabel!
    @IBOutlet weak var lblInValue: UILabel!
    @IBOutlet weak var lblOutTitle: UILabel!
    @IBOutlet weak var lblOutValue: UILabel!
    @IBOutlet weak var lblDifference: UILabel!
    
    @IBOutlet weak var txtPunchInDate: NoPopUpTextField!
    @IBOutlet weak var txtPunchInTime: NoPopUpTextField!
    @IBOutlet weak var txtPunchOutDate: NoPopUpTextField!
    @IBOutlet weak var txtPunchOutTime: NoPopUpTextField!
    
    @IBOutlet weak var vwSelectJob: UIView!
    @IBOutlet weak var txtSelectJob: UITextField!
    @IBOutlet weak var btnSelectJob: UIButton!
    @IBOutlet weak var txtVwNotes: KMPlaceholderTextView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var punchInTime: String = ""
    var punchOutTime: String = ""
    
    var dateFormatter = DateFormatter()
    
    var objTimesheet: TimesheetListObject!
    var objPunch: TimesheetPunchLogObject!
    
    var arrJobList: [JobListObject] = []
    var arrSelectedJob: [JobListObject] = []
    
    var arrTimeSheet: [TimesheetListObject] = []
    
    var arrDBTimesheet: [EmployeePunch] = []
    
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    

    // MARK:- ACTIONS -
    
    @objc func doneButtonClicked(_ sender: UIDatePicker) {
        if sender == self.txtPunchInDate {
            if let picker = sender.inputView as? UIDatePicker {
                self.txtPunchInDate.text = picker.date.getDateOnly()
                self.getDifference()
            }
        }
        else if sender == self.txtPunchInTime {
            if let picker = sender.inputView as? UIDatePicker {
                self.txtPunchInTime.text = picker.date.getOnlyTimeWithFormat()
                self.punchInTime = picker.date.getOnlyTimeWithFormat()
                self.lblInValue.text = self.punchInTime
                
                if self.txtPunchInTime.isEmpty() == 0 && self.txtPunchOutTime.isEmpty() == 0 {
                    self.getDifference()
                }
            }
        }
        else if sender == self.txtPunchOutDate {
            if let picker = sender.inputView as? UIDatePicker {
                self.txtPunchOutDate.text = picker.date.getDateOnly()
                self.getDifference()
            }
        }
        else if sender == self.txtPunchOutTime {
            if let picker = sender.inputView as? UIDatePicker {
                self.txtPunchOutTime.text = picker.date.getOnlyTimeWithFormat()
                self.punchOutTime = picker.date.getOnlyTimeWithFormat()
                self.lblOutValue.text = self.punchOutTime

                if self.txtPunchInTime.isEmpty() == 0 && self.txtPunchOutTime.isEmpty() == 0 {
                    self.getDifference()
                }
            }
        }
    }
    
    @objc func backAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDateTimeSelectionTapped(_ sender: UIButton) {
        if sender.accessibilityIdentifier == "PUNCH_IN_DATE" {
            self.txtPunchInDate.becomeFirstResponder()
        } else if sender.accessibilityIdentifier == "PUNCH_IN_TIME" {
            self.txtPunchInTime.becomeFirstResponder()
        } else if sender.accessibilityIdentifier == "PUNCH_OUT_DATE" {
            self.txtPunchOutDate.becomeFirstResponder()
        } else if sender.accessibilityIdentifier == "PUNCH_OUT_TIME" {
            self.txtPunchOutTime.becomeFirstResponder()
        }
    }
    
    @IBAction func btnUpdateTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtPunchInDate.isEmpty() == 1 {
            AppFunctions.displayAlert("Punch in date is required".localized())
        }
        else if self.txtPunchInTime.isEmpty() == 1 {
            AppFunctions.displayAlert("Punch in time is required".localized())
        }
        else if self.txtPunchOutDate.isEmpty() == 1 {
            AppFunctions.displayAlert("Punch out date is required".localized())
        }
        else if self.txtPunchOutTime.isEmpty() == 1 {
            AppFunctions.displayAlert("Punch out time is required".localized())
        }
        else {
            let empInDate:Date = Date.getDateWithTimeFromString(self.txtPunchInDate.text!+" "+self.txtPunchInTime.text!)
            let empOutDate:Date = Date.getDateWithTimeFromString(self.txtPunchOutDate.text!+" "+self.txtPunchOutTime.text!)
            
            let currentDate = AppFunctions.sharedInstance.getCurrentDateInSettingTimezone()
            
            if empInDate.isGreaterThanDate(currentDate) || empOutDate.isGreaterThanDate(currentDate) {
                AppFunctions.displayAlert("You're not allowed to create hours in the future.".localized())
            }
            else if empInDate.isGreaterThanDate(empOutDate) {
                AppFunctions.displayAlert("Punched Out date must be greater than Punched In date".localized())
            }
            else {
                self.callEditManualHoursAPI()
            }
        }
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        AppFunctions.displayConfirmationAlert(self, title: "Delete Timesheet".localized(), message: "Would you like to delete this timesheet?".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "Delete".localized(), actionBlock: { (isConfirmed) in
            if isConfirmed {
                if appDelegate.isInternetConnected() == true {
                    self.callDeleteTimesheetAPI(objTimesheet: self.objTimesheet, objPunch: self.objPunch)
                }
                else {
                    self.callDeleteTimesheetOfflineAPI(objTimesheet: self.objTimesheet, objPunch: self.objPunch)
                }
            }
        })
    }
    
    @IBAction func btnSelectJobTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let vc = AppFunctions.employeeTimesheetStoryBoard().instantiateViewController(withIdentifier: "TimesheetJobSelectionPopupVC") as! TimesheetJobSelectionPopupVC
        vc.arrJobs = self.arrJobList
        vc.arrSelectedJob = self.arrSelectedJob
        
        let arrIDs = self.arrSelectedJob.map({ (job: JobListObject) -> Int in
            job.id
        })
        vc.arrSelectedJobIDs = arrIDs
        
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK:- Filter JOB
extension EmployeeEditTimesheetVC: jobSingleSelectionDelegate {
    func getSignleSelectedJob(_ arrSelectedJob: [JobListObject]) {
        self.arrSelectedJob = arrSelectedJob
        
        if self.arrSelectedJob.count > 0 {
            self.txtSelectJob.text = self.arrSelectedJob[0].job_title
        }
    }
}

// MARK:- UITEXTFIELD DELEGATE METHOD -

extension EmployeeEditTimesheetVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtPunchInDate {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
            datePicker.maximumDate = Date()
//            if self.txtPunchOutDate.text != "" {
//                datePicker.maximumDate = self.dateFormatter.date(from: self.txtPunchOutDate.text ?? "")
//            }
            datePicker.date = Date.getSelectedDateFromString(self.txtPunchInDate.text ?? Date.getDateOnly())
            datePicker.addTarget(self, action: #selector(updatePunchInDateField(sender:)), for: .valueChanged)
            
            if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            self.txtPunchInDate.inputView = datePicker
        } else if textField == self.txtPunchInTime {
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            
            //I HAVE PUT THIS CONDITION TO SHOW TIME PICKER IN 12 HOURS AND 24 HOURS AS PER SETTINGS
            if !globalTimeFormat.contains("a") {
                timePicker.locale = Locale(identifier: "NL")
            }
            
            timePicker.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
            timePicker.date = Date.getHourMinSecondswithDate(self.txtPunchInTime.text!)
            timePicker.addTarget(self, action: #selector(updatePunchInTimeField(sender:)), for: .valueChanged)
            var cal = Calendar.current
            cal.timeZone = NSTimeZone(name: globalTimezone) as TimeZone? ?? TimeZone.init(abbreviation: AppFunctions.sharedInstance.getDeviceTimeZone())!
            var comp = DateComponents()
            let array = (self.txtPunchInTime.text?.components(separatedBy: "."))! as NSArray
            if array.count >= 2 {
                comp.hour = (array.object(at: 0) as AnyObject).intValue
                comp.minute = (array.object(at: 1) as AnyObject).intValue
                comp.minute = AppFunctions.getSecondsFromHours(comp.minute!)
                let date1 = cal.date(from: comp)
                timePicker.setDate(date1!, animated: true)
            }
            
            if #available(iOS 14, *) {
                timePicker.preferredDatePickerStyle = .wheels
            }
            self.txtPunchInTime.inputView = timePicker
        } else if textField == self.txtPunchOutDate {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
            
            let punchInDate = AppFunctions.sharedInstance.convertStringToDate(StrDate: self.txtPunchInDate.text ?? "", DateFormat: globalDateFormat)
            datePicker.minimumDate = punchInDate
            datePicker.maximumDate = Date()
            datePicker.date = Date.getSelectedDateFromString(self.txtPunchOutDate.text ?? Date.getDateOnly())
            datePicker.addTarget(self, action: #selector(updatePunchOutDateField(sender:)), for: .valueChanged)
            
            if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            self.txtPunchOutDate.inputView = datePicker
        } else if textField == self.txtPunchOutTime {
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            
            //I HAVE PUT THIS CONDITION TO SHOW TIME PICKER IN 12 HOURS AND 24 HOURS AS PER SETTINGS
            if !globalTimeFormat.contains("a") {
                timePicker.locale = Locale(identifier: "NL")
            }
            
            timePicker.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
            timePicker.date = Date.getHourMinSecondswithDate(self.txtPunchOutTime.text!)
            timePicker.addTarget(self, action: #selector(updatePunchOutTimeField(sender:)), for: .valueChanged)
            var cal = Calendar.current
            cal.timeZone = NSTimeZone(name: globalTimezone) as TimeZone? ?? TimeZone.init(abbreviation: AppFunctions.sharedInstance.getDeviceTimeZone())!
            var comp = DateComponents()
            let array = (self.txtPunchOutTime.text?.components(separatedBy: "."))! as NSArray
            if array.count >= 2 {
                comp.hour = (array.object(at: 0) as AnyObject).intValue
                comp.minute = (array.object(at: 1) as AnyObject).intValue
                comp.minute = AppFunctions.getSecondsFromHours(comp.minute!)
                let date1 = cal.date(from: comp)
                timePicker.setDate(date1!, animated: true)
            }
            
            if #available(iOS 14, *) {
                timePicker.preferredDatePickerStyle = .wheels
            }
            self.txtPunchOutTime.inputView = timePicker
        }
        return true
    }
    
    @objc func updatePunchInDateField(sender: UIDatePicker) {
        self.txtPunchInDate.text = sender.date.getDateOnly()
        self.getDifference()
    }
    
    @objc func updatePunchInTimeField(sender: UIDatePicker) {
        self.txtPunchInTime.text = sender.date.getOnlyTimeWithFormat()
        self.punchInTime = sender.date.getOnlyTimeWithFormat()
        self.lblInValue.text = self.punchInTime
        self.getDifference()
    }
    
    @objc func updatePunchOutDateField(sender: UIDatePicker) {
        self.txtPunchOutDate.text = sender.date.getDateOnly()
        self.getDifference()
    }
    
    @objc func updatePunchOutTimeField(sender: UIDatePicker) {
        self.txtPunchOutTime.text = sender.date.getOnlyTimeWithFormat()
        self.punchOutTime = sender.date.getOnlyTimeWithFormat()
        self.lblOutValue.text = self.punchOutTime
        self.getDifference()
    }
    
    //GET DIFFERNECE BETWEEN PUNCH IN/OUT DATE
    func getDifference() {
        if self.txtPunchInDate.text != "" && self.txtPunchInTime.text != "" && self.txtPunchOutDate.text != "" && self.txtPunchOutTime.text != "" {
            let empInDate:Date = Date.getDateWithTimeFromString(self.txtPunchInDate.text!+" "+self.txtPunchInTime.text!)
            let empOutDate:Date = Date.getDateWithTimeFromString(self.txtPunchOutDate.text!+" "+self.txtPunchOutTime.text!)
            
            let cal = Calendar.current
            let components = cal.dateComponents([.hour, .minute], from: empInDate, to: empOutDate)
//            let totalDay = components.day
            let totalHour = components.hour
            let totalMinute = components.minute
                        
            var finalString = ""
//            if totalDay != 0 {
//                finalString = "\(abs(totalDay ?? 0))d "
//            }
            
            let finalHour = String.init(format: "%02d", abs(totalHour!))
            finalString = finalString + "\(finalHour)h "
            let finalMinute = AppFunctions.sharedInstance.checkMinuteValue(TotalMinute: abs(totalMinute!))
            finalString = finalString + "\(finalMinute)m"
            
            self.lblDifference.text = finalString
        }
    }
}

// MARK:- UITEXTVIEW DELEGATE METHOD -

extension EmployeeEditTimesheetVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.tintColor = UIColor.init(HexCode: 0x3C3B6E)
        return true
    }
}

//MARK:- API Call
extension EmployeeEditTimesheetVC {
    func callEditManualHoursAPI() {
        // Check Internet Available
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["punchin_date"] = AppFunctions.sharedInstance.formattedDateFromString(dateString: self.txtPunchInDate.text ?? "", InputFormat: globalDateFormat, OutputFormat: API_REQUEST_DATE_FORMAT)
        params["punchout_date"] = AppFunctions.sharedInstance.formattedDateFromString(dateString: self.txtPunchOutDate.text ?? "", InputFormat: globalDateFormat, OutputFormat: API_REQUEST_DATE_FORMAT)
        
        if self.lblDifference.text == ("00" + "h ".localized() + "00" + "m".localized()) {
            
        } else {
            params["punchin_time"] = AppFunctions.sharedInstance.formattedDateFromString(dateString: self.txtPunchInTime.text ?? "", InputFormat: globalTimeFormat, OutputFormat: API_REQUEST_TIME_FORMAT)
            params["punchout_time"] = AppFunctions.sharedInstance.formattedDateFromString(dateString: self.txtPunchOutTime.text ?? "", InputFormat: globalTimeFormat, OutputFormat: API_REQUEST_TIME_FORMAT)
        }
        
        if self.arrSelectedJob.count > 0 {
            params["job_id"] = self.arrSelectedJob[0].id
        }
        params["punch_via"] = 2 //0:web,1:android,2:ios
        params["note"] = self.txtVwNotes.text
        params["id"] = self.objPunch.id
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.EMPLOYEE_EDIT_MANUAL_HOURS, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? [Dictionary<String, Any>] {
                            
                            for i in 0..<payload.count  {
                                let objPunch = TimesheetListObject.init(payload[i])
                                self.arrTimeSheet.append(objPunch)
                            }
                            
                            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                            
                            var dict = [String: [TimesheetListObject]]()
                            dict["timesheet"] = self.arrTimeSheet
                            //FIRE POSE NOTIFICATION TO UPDATE PUNCH LOG LIST
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: updateEmployeeTimesheet), object: nil, userInfo: dict)
                            self.navigationController?.popViewController(animated: true)
                        }
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
                                
                                if let row = self.arrTimeSheet.firstIndex(where: {$0.date == objTimesheet.date}) {
                                    self.arrTimeSheet.remove(at: row)
                                }
                            }
                        }
                        
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: deleteEmployeeTimesheet), object: nil, userInfo: nil)
                        self.navigationController?.popViewController(animated: true)
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
        
        self.arrTimeSheet = EmployeePunch.getAllPunchDataInAPIModel()
        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "Timesheet deleted successfully".localized())
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: deleteEmployeeTimesheet), object: nil, userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
