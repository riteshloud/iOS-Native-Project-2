//
//  EmployeeDashboardVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SideMenuSwift
import SwiftyJSON
import GoogleMaps
import Reachability

class EmployeeDashboardVC: BaseVC, GMSMapViewDelegate {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblGoodStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblStartTimeValue: UILabel!
    @IBOutlet weak var lblStartTimeTitle: UILabel!
    
    @IBOutlet weak var lblStatusValue: UILabel!
    @IBOutlet weak var lblStatusTitle: UILabel!
    
    @IBOutlet weak var lblCurrentlyPunchinTime: UILabel!
    @IBOutlet weak var lblDurationTitle: UILabel!
    
    @IBOutlet weak var btnPunchInOut: UIButton!
    
    //FLAG TO IDENTIFY DAY TOTAL OR WEEK TOTAL CURRENT SELECTION
    //    var isSelectDayTotal:Bool = true
    var boldTimerFontSize = CGFloat()
    var normalTimerFontSize = CGFloat()
    
    var arrJobList: [JobListObject] = []
    
    var totalSecond = Int()
    
    var objOfflineTimesheet: TimesheetListObject = TimesheetListObject.init([:])
    
    var objDashboard: EmployeeDashboardObject = EmployeeDashboardObject.init([:])
    
    var arrSelectedJob: [JobListObject] = []
    
    var objSelectedJob: JobListObject!
    
    var isUserCurrentlyPunchedIn: Bool = false
    
    var dayHours: Int = 0
    var dayMinutes: Int = 0
    
    var weeklyHour: Int = 0
    var weeklyMinute: Int = 0
    
    
    var isWantToShowSyncingProgress: Bool = false
    
    var isWantToSyncOnLogout: Bool = false
    
    var isUserInGeoFencingLocation: Bool = false
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ADDED NOTIFICATION OBSERVER TO NOTIFY US WHEN APP COMES IN FOREGROUND STATE
        NotificationCenter.default.addObserver(self, selector: #selector(self.appCameToForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //ADDED NOTIFICATION OBSERVER TO STOP RUNNIG TIMER WHEN APP GOES IN BACKGROUND STATE
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        self.lblGoodStatus.text = AppFunctions.sharedInstance.getdayTypeLikeMorningEveningNight()
        
        self.checkIfAnyActivePunchInDB()
        if appDelegate.isInternetConnected() {
            self.callEmployeeDashboardAPI()
        }
        else {
            // self.checkIfAnyActivePunchInDB()
        }
        
        if !self.isWantToSyncOnLogout {
            //CHECK DASHBOARD DATA AND EMPLOYEE SETTINGS FROM LOCALLY SAVED
            if let data = defaults.value(forKey: employeeDashboardData) as? Data,
                let dashboardData = try? JSONDecoder().decode(EmployeeDashboardObject.self, from: data) {
                self.objDashboard = dashboardData
                AppFunctions.sharedInstance.setGlobalTimeZone(strTimezone: "")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    
    //THIS FUNCTION WILL CALL WHEN INTERNET CONNECTION IS ON/OFF
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular:
            debugPrint("Network available via Cellular Data.")
                self.isWantToShowSyncingProgress = true
                self.callSyncAPI()
            break
        case .wifi:
            debugPrint("Network available via WiFi.")
                self.isWantToShowSyncingProgress = true
                self.callSyncAPI()
            break
        case .unavailable:
            debugPrint("Network is  unavailable.")
            break
        case .none:
            break
        }
    }
    
    //THIS FUNCTION WILL CALL WHEN APP GOES IN BACKGROUND STATE
    @objc private func appMovedToBackground() {
        if appDelegate.objLoggedInUser.login_type != "Company".localized() {
            self.stopPunchInTimer()
        }
    }
    
    //THIS FUNCTION WILL CALL WHEN APP COMES IN FORGROUND STATE
    @objc private func appCameToForeground(_ notification: NSNotification) {
        if appDelegate.objLoggedInUser.login_type != "Company".localized() {
            if appDelegate.isInternetConnected() == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.callSyncAPI()
                }
                
            }
            
            self.checkIfAnyActivePunchInDB()
        }
    }
    
    //THIS FUNCTION IS USED TO CHECK ANY ACTIVE PUNCH IN AVAILABLE IN DATABASE, IF AVAILABLE THEN
    func checkIfAnyActivePunchInDB() {
        if appDelegate.objSelectedJobForPunchIn != nil {
            self.objSelectedJob = appDelegate.objSelectedJobForPunchIn
            self.arrSelectedJob.removeAll()
            self.arrSelectedJob.append(self.objSelectedJob)
            self.btnPunchInOut.setTitle(String.init(format: "%@ %@", "Punch in for".localized(), self.objSelectedJob.job_title), for: [])
        }
        else {
            self.objSelectedJob = nil
            appDelegate.objSelectedJobForPunchIn = nil
            self.arrSelectedJob.removeAll()
            
            self.btnPunchInOut.setTitle("Punch in".localized(), for: [])
        }
        
        //GET LOCALLY SAVED JOBS DATA
        self.arrJobList = Jobs.getAllJobsInAPIModel()
        
        //CHECK IS EMPLOYEE HAS ANY ACTIVE PUNCH IN
        let arrDBPunch = EmployeePunch.getAllPunch()
        if arrDBPunch.count > 0 {
            //FIND ACTIVE PUNCH LOG TIMESHEET OBJECT AND CHANGE BUTTON STATE AND SET TIME VALUE AS PER DATA
        }
        
        self.setupPunnchInButton()
    }
    
    func updateIfPunchedIN() {
        self.lblStatusValue.text = "IN".localized()
        self.lblStatusValue.textColor = Colors.punchInBGColor
    }
    
    func updateIfNotPunchedIN() {
        self.lblStartTimeValue.text = "-"
        self.lblStatusValue.text = "OUT".localized()
        self.lblStatusValue.textColor = Colors.punchOutBGColor
    }
    
    
    //THIS FUNCTION CHANGE PUNCH BUTTON GRADIENT COLOR AS PER PUNCH IN/OUT LOGIC
    func setupPunnchInButton() {
        if self.isUserCurrentlyPunchedIn == false {
            self.btnPunchInOut.backgroundColor = Colors.punchInBGColor
        }
        else {
            self.btnPunchInOut.backgroundColor = Colors.punchOutBGColor
        }
    }
    
    //MARK:- Punch In/Out Timer
    func startPunchInTimer() {
        if appDelegate.punchInTimer == nil {
            appDelegate.punchInTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(calculatePunchInTimeDifference), userInfo: nil, repeats: true)
        }
    }
    
    func stopPunchInTimer() {
        if appDelegate.punchInTimer != nil {
            totalSecond = 0
            appDelegate.punchInTimer!.invalidate()
            appDelegate.punchInTimer = nil
        }
        self.lblCurrentlyPunchinTime.text = "-"
//        self.lblDurationTitle.text = "EARNINGS".localized()
    }
    
    //MARK:- Calculate and show Punch In/Out time difference
    @objc func calculatePunchInTimeDifference() {
        var hours: Int
        var minutes: Int
        var seconds: Int
        
        totalSecond = abs(totalSecond + 1)
        hours = totalSecond / 3600
        minutes = (totalSecond % 3600) / 60
        seconds = (totalSecond % 3600) % 60
        
        DispatchQueue.main.async() {
            self.lblDurationTitle.text = "DURATION".localized()
            self.lblCurrentlyPunchinTime.text = String.init(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    // MARK:- HELPER -

    //THIS FUNCTION IS USED TO REDIRECT USER TO CHANGE LOCATION SETTINGS
    func showGotoSettingDialog(actionBlock: @escaping (_ isCancelTapped:Bool)->Void) {
        let alert = UIAlertController(title: "Allow Location Access".localized(), message: "Location Services Disabled\nTo re-enable, please go to Settings and turn on Location Service for this app.".localized(), preferredStyle: UIAlertController.Style.alert)
        
        // Button to Open Settings
        alert.addAction(UIAlertAction(title: "Settings".localized(), style: UIAlertAction.Style.default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    debugPrint("Settings opened: \(success)")
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default, handler: { action in
            actionBlock(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- ACTIONS -
    @objc func profileAction() {
        let objEmployeeSettings = EmployeeSettingsObject.init([:])
        objEmployeeSettings.name = appDelegate.objEmployeeSettings.name
        objEmployeeSettings.email = appDelegate.objEmployeeSettings.email
        objEmployeeSettings.country_code = appDelegate.objEmployeeSettings.country_code
        objEmployeeSettings.phone = appDelegate.objEmployeeSettings.phone
    }
    
    @objc func syncAction() {
        self.isWantToShowSyncingProgress = true
        self.isWantToSyncOnLogout = false
        
        self.callSyncAPI()
    }

    @IBAction func btnPunchInOutClick(_ sender: UIButton) {
        //Do Punch In/OUT
    }
    
    func presentJobSelectionController() {
        let controller = AppFunctions.employeeDashboardStoryBoard().instantiateViewController(withIdentifier: "SelectJobPopupVC") as! SelectJobPopupVC
        controller.arrJobs = self.arrJobList
        controller.arrSelectedJob = self.arrSelectedJob
        
        let arrIDs = self.arrSelectedJob.map({ (job: JobListObject) -> Int in
            job.id
        })
        controller.arrSelectedJobIDs = arrIDs
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)
    }
    
    //MARK: ADD PUNCH DATA INTO DB
    func addPunchLogOffline() {
        self.startPunchInTimer()
        //ADD DATA INTO DB
    }
    
    //UPDATE EXISTING PUNCH DATA INTO DB
    func updatePunchLogOffline() {
       //UPDATE PUNCH IN OBJECT DATA AND STOP TIMER
        self.stopPunchInTimer()
    }
}

//MARK:- CLLocationManager Delegate
extension EmployeeDashboardVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            appDelegate.locationManager.startUpdatingLocation()
        }
        else if status == .denied || status == .notDetermined || status == .restricted {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        appDelegate.currentLocation = userLocation
        if userLocation != nil {
            debugPrint(userLocation!.coordinate.latitude)
            debugPrint(userLocation!.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
      debugPrint("Monitoring failed for region with identifier: \(region!.identifier)")
    }

    //GEO FENCING MONITORING DELEGATE
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.isUserInGeoFencingLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            self.isUserInGeoFencingLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == CLRegionState.inside {
            self.isUserInGeoFencingLocation = true
        }
        else {
            self.isUserInGeoFencingLocation = false
        }
    }
    
    //REGISTER GEO FENCING WHEN EMPLOYEE ENTER/EXIT GEOFENCE REGION
    func registerGeoFance(obj: GeoFenceObject) {
        let centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(obj.latitude, obj.longitude)
        let region = CLCircularRegion(center: centerCoordinate, radius: CLLocationDistance(obj.radius), identifier: "\(obj.id)") // provide radius in meter. also provide uniq identifier for your region.
        region.notifyOnEntry = true // based on your requirements
        region.notifyOnExit = true
        
        appDelegate.locationManager.startMonitoring(for: region) // to star monitor region
//        appDelegate.locationManager.requestState(for: region) // that will check if user is already inside location then it will fire notification instantly.
    }
}

// MARK:- API CALL -

extension EmployeeDashboardVC {
    // DASHBOARD API
    func callEmployeeDashboardAPI() {
        if AppFunctions.checkInternet() == false {
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: INTERNET_UNAVAILABLE)
            AppFunctions.hideProgress()
            return
        }
        
        var params: [String:Any] = [:]
        
        let arrIDs = EmployeePunchLogs.getAllActivePunchLogs().map({ (punchLog: EmployeePunchLogs) -> Int in
            punchLog.id
        })
        
        params["active_punch_ids"] = (arrIDs.map{String($0)}).joined(separator: ",")
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.EMPLOYEE_DASHBOARD, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    //                    self.view.isUserInteractionEnabled = true
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            self.objDashboard = EmployeeDashboardObject.init(payload)
                            
                            if let setting = payload["setting"] as? Dictionary<String, Any> {
                                if let user_employee = setting["user_employee"] as? Dictionary<String, Any> {
                                    let objEmployeeSetting = EmployeeSettingsObject.init(user_employee)
                                    appDelegate.objEmployeeSettings = objEmployeeSetting
                                }
                            }
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
    
    func setDashboardData() {
        self.lblName.text = ""
        
        if self.objDashboard.arrCurrentPunch.count > 0 {
            self.objOfflineTimesheet = self.objDashboard.arrCurrentPunch[0]
            
            if self.objOfflineTimesheet.arrPunchLog[0].objJob.id > 0 {
                if self.isUserCurrentlyPunchedIn {
                    self.arrSelectedJob.removeAll()
                    self.objSelectedJob = self.objOfflineTimesheet.arrPunchLog[0].objJob
                    self.arrSelectedJob.append(self.objSelectedJob)
                } else {
                    self.arrSelectedJob.removeAll()
                    self.objSelectedJob = nil
                    appDelegate.objSelectedJobForPunchIn = nil
                }
            } else {
                self.arrSelectedJob.removeAll()
                self.objSelectedJob = nil
                appDelegate.objSelectedJobForPunchIn = nil
            }
            
            //INSERT PUNCHLOG DATA IN DB
            EmployeePunch.addPunch(objTimeSheet: self.objOfflineTimesheet)
            debugPrint(self.objOfflineTimesheet)
            
            appDelegate.isUserPunchedIn = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkIfAnyActivePunchInDB()
        }
        
        self.lblDate.text = AppFunctions.sharedInstance.formattedDateFromString(dateString: AppFunctions.sharedInstance.getCurrentDateInStringSettingTimezone(), InputFormat: API_RESPONSE_DATE_TIME_FORMAT, OutputFormat: "EEEE, MMM dd, yyyy")
    }
    
    // PUNCH IN API
    func employeePunchInAPI(isWantToSendLocation: Bool) {
        if AppFunctions.checkInternet() == false {
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: INTERNET_UNAVAILABLE)
            AppFunctions.hideProgress()
            return
        }
        
        var params: [String:Any] = [:]
        params["punch_via"] = 2 //0=Web,1=Android,2=IOS
        
        if self.objSelectedJob != nil {
            params["job_id"] = self.objSelectedJob.id
        }
        
        if isWantToSendLocation == true {
            params["punch_latitude"] = appDelegate.currentLocation.coordinate.latitude
            params["punch_longitude"] = appDelegate.currentLocation.coordinate.longitude
        }
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.EMPLOYEE_PUNCH_IN, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    self.view.isUserInteractionEnabled = true
                    if response["code"] as! Int == 200 {
                        
                        if let payloadData = response["payload"]  as? Dictionary<String, Any> {
                            
                            self.arrJobList.removeAll()
                            
                            //JOBS LIST
                            if let jobList = payloadData["jobs"] as? [Dictionary<String, Any>] {
                                for i in 0..<jobList.count  {
                                    let objJob = JobListObject.init(jobList[i])
                                    self.arrJobList.append(objJob)
                                }
                            }
                            
                            //PUNCHES OBJECT
                            if let arrPunches = payloadData["punches"] as? [Dictionary<String, Any>] {
                                self.objOfflineTimesheet = TimesheetListObject.init(arrPunches[0])
                                //INSERT PUNCHLOG DATA IN DB
                                EmployeePunch.addPunch(objTimeSheet: self.objOfflineTimesheet)
                            }
                            
                            Jobs.deleteAllJobData()
                            //INSERT JOBS DATA IN DB
                            for i in 0..<self.arrJobList.count  {
                                let objJob = self.arrJobList[i]
                                Jobs.addJob(objJob: objJob)
                            }
                        }
                        
                        self.startPunchInTimer()
                        
                        self.isUserCurrentlyPunchedIn = true
                        appDelegate.isUserPunchedIn = true
                        
                        //self.hideDeleteJobButton()
                        if self.objSelectedJob != nil {
                            self.btnPunchInOut.setTitle(String.init(format: "%@ %@", "Punch out for".localized(), self.objSelectedJob.job_title), for: [])
                        }
                        else {
                            self.btnPunchInOut.setTitle("Punch out".localized(), for: [])
                        }
                        self.setupPunnchInButton()
                        
                        let strPunchInTime = self.objOfflineTimesheet.arrPunchLog[0].punchin_time
                        
                        //**************************************************
                        self.lblStartTimeValue.text = strPunchInTime
                        self.updateIfPunchedIN()
                        //**************************************************
                    }
                    else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
                    }
                    else {
//                        self.checkIfAnyActivePunchInDB()
                        if self.arrJobList.count <= 0 {
                            self.callEmployeeDashboardAPI()
                        }
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                    }
                }
            }
        }) { (error) in
            AppFunctions.hideProgress()
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    // PUNCH OUT API
    func employeePunchOutAPI(isWantToSendLocation: Bool) {
        if AppFunctions.checkInternet() == false {
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: INTERNET_UNAVAILABLE)
            AppFunctions.hideProgress()
            return
        }
        
        var params: [String:Any] = [:]
        params["punch_via"] = 2 //0=Web,1=Android,2=IOS
        
        if self.objSelectedJob != nil {
            params["job_id"] = self.objSelectedJob.id
        }
        
        if isWantToSendLocation == true {
            params["punch_latitude"] = appDelegate.currentLocation.coordinate.latitude
            params["punch_longitude"] = appDelegate.currentLocation.coordinate.longitude
        }
        
        let arrIDs = EmployeePunchLogs.getAllActivePunchLogs().map({ (punchLog: EmployeePunchLogs) -> Int in
            punchLog.id
        })
        params["active_punch_ids"] = (arrIDs.map{String($0)}).joined(separator: ",")
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.EMPLOYEE_PUNCH_OUT, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        
                         if let payloadData = response["payload"]  as? Dictionary<String, Any> {
                            
                            self.arrJobList.removeAll()
                            
                            //JOBS LIST
                            if let jobList = payloadData["jobs"] as? [Dictionary<String, Any>] {
                                for i in 0..<jobList.count  {
                                    let objJob = JobListObject.init(jobList[i])
                                    self.arrJobList.append(objJob)
                                }
                            }
                            
                            //PUNCHES OBJECT
                            if let arrPunches = payloadData["punches"] as? [Dictionary<String, Any>] {
                                if arrPunches.count > 0 {
                                    self.objOfflineTimesheet = TimesheetListObject.init(arrPunches[0])
                                }
                                
                                //INSERT PUNCHLOG DATA IN DB
                                for i in 0..<arrPunches.count  {
                                    let objTimesheet = TimesheetListObject.init(arrPunches[i])
                                    EmployeePunch.addPunch(objTimeSheet: objTimesheet)
                                }
                            }
                            
                            Jobs.deleteAllJobData()
                            //INSERT JOBS DATA IN DB
                            for i in 0..<self.arrJobList.count  {
                                let objJob = self.arrJobList[i]
                                Jobs.addJob(objJob: objJob)
                            }
                        }
                        
                        self.stopPunchInTimer()
                    }
                    else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
                    }
                    else {
                        self.checkIfAnyActivePunchInDB()
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                    }
                }
            }
        }) { (error) in
            AppFunctions.hideProgress()
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    
    //SYNC API
    func callSyncAPI() {
        if AppFunctions.checkInternet() == false {
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: INTERNET_UNAVAILABLE)
            AppFunctions.hideProgress()
            return
        }
        
        var params: [String:Any] = [:]
        
        if defaults.string(forKey: lastSyncTimestamp) != nil {
            params["lastsync"] = defaults.string(forKey: lastSyncTimestamp)
        }
        else {
            params["lastsync"] = ""
        }
        params["punch_via"] = 2 //0:web,1:android,2:ios
        
        //ADDED
        var dictData = Dictionary<String, Any>()
        dictData["added"] = EmployeePunch.getNewlyAddedPunchesData()
        
        //UPDATED
        dictData["updated"] = EmployeePunch.getUpdatedPunchesData()
        
        //DELETED
        dictData["deleted"] = EmployeePunch.getDeletedPunchesData()
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dictData, options: [])
        let strJSONData = String(data: jsonData, encoding: .utf8)!
        
        params["data"] = strJSONData
        
        if let lastSyncTimeStamp = defaults.string(forKey: lastSyncTimestamp) {
            debugPrint(lastSyncTimeStamp)
            if self.isWantToShowSyncingProgress || self.isWantToSyncOnLogout {
                AppFunctions.showProgressWithTitle(title: "Syncing Timesheet".localized())
            }
        }
        else {
            AppFunctions.showProgressWithTitle(title: "Syncing Timesheet".localized())
        }
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.SYNC_DATA, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    self.view.isUserInteractionEnabled = true
                    if response["code"] as! Int == 200 {
                        if let payloadData = response["payload"]  as? Dictionary<String, Any> {
                            
                            self.arrJobList.removeAll()
                            //JOBS LIST
                            if let jobList = payloadData["jobs"] as? [Dictionary<String, Any>] {
                                for i in 0..<jobList.count  {
                                    let objJob = JobListObject.init(jobList[i])
                                    self.arrJobList.append(objJob)
                                }
                            }
                            
                            Jobs.deleteAllJobData()
                            //INSERT JOBS DATA IN DB
                            for i in 0..<self.arrJobList.count  {
                                let objJob = self.arrJobList[i]
                                Jobs.addJob(objJob: objJob)
                            }
                            
                            if let lastSync = payloadData["lastsync"] as? Int {
                                defaults.set(String(lastSync), forKey: lastSyncTimestamp)
                                defaults.synchronize()
                            }
                            
                            if let data = payloadData["data"] as? Dictionary<String, Any> {
                                //ADDED
                                if let arrAdded = data["added"] as? [Dictionary<String, Any>] {
                                    //INSERT PUNCHLOG DATA IN DB
                                    for i in 0..<arrAdded.count  {
                                        let objTimesheet = TimesheetListObject.init(arrAdded[i])
                                        EmployeePunch.addNewlyAddedDataInRealm(objTimesheet: objTimesheet)
                                    }
                                }
                                
                                //UPDATED
                                if let arrUpdated = data["updated"] as? [Dictionary<String, Any>] {
                                    //UPDATE PUNCHLOG DATA IN DB
                                    for i in 0..<arrUpdated.count  {
                                        let objTimesheet = TimesheetListObject.init(arrUpdated[i])
                                        EmployeePunch.addPunch(objTimeSheet: objTimesheet)
                                    }
                                }
                                
                                //DELETED
                                if let arrDeleted = data["deleted"] as? [Dictionary<String, Any>] {
                                    //DELETE PUNCHLOG DATA FROM DB
                                    for i in 0..<arrDeleted.count  {
                                        let objDBTimesheet = TimesheetListObject.init(arrDeleted[i])
                                        EmployeePunch.deleteRecordsFromRealm(objTimeSheet: objDBTimesheet)
                                    }
                                }
                                
                                if self.isWantToSyncOnLogout {
                                    appDelegate.logoutUser()
                                }
                                else {
                                    self.checkIfAnyActivePunchInDB()
                                }
                            }
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
}
