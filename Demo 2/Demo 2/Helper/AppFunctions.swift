//
//  AppFunctions.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation
import Alamofire

class AppFunctions: NSObject {
    
    var objConfiguration = ConfigDataObject.init([:])
    
    struct Singleton {
        static let sharedInstance = AppFunctions()
    }
    
    var hourArray: [String] = ["00".localized(), "01".localized(), "02".localized(), "03".localized(), "04".localized(), "05".localized(), "06".localized(), "07".localized(), "08".localized(), "09".localized(), "10".localized(), "11".localized(), "12".localized(), "13".localized(), "14".localized(), "15".localized(), "16".localized(), "17".localized(), "18".localized(), "19".localized(), "20".localized(), "21".localized(), "22".localized(), "23".localized()]
    
    var minuteArray: [String] = ["00".localized(), "01".localized(), "02".localized(), "03".localized(), "04".localized(), "05".localized(), "06".localized(), "07".localized(), "08".localized(), "09".localized(), "10".localized(), "11".localized(), "12".localized(), "13".localized(), "14".localized(), "15".localized(), "16".localized(), "17".localized(), "18".localized(), "19".localized(), "20".localized(), "21".localized(), "22".localized(), "23".localized(), "24".localized(), "25".localized(), "26".localized(), "27".localized(), "28".localized(), "29".localized(), "30".localized(), "31".localized(), "32".localized(), "33".localized(), "34".localized(), "35".localized(), "36".localized(), "37".localized(), "38".localized(), "39".localized(), "40".localized(), "41".localized(), "42".localized(), "43".localized(), "44".localized(), "45".localized(), "46".localized(), "47".localized(), "48".localized(), "49".localized(), "50".localized(), "51".localized(), "52".localized(), "53".localized(), "54".localized(), "55".localized(), "56".localized(), "57".localized(), "58".localized(), "59".localized()]
    
    var arrJobs: [String] = ["Job 1".localized(), "Job 2".localized(), "Job 3".localized(), "Job 4".localized(), "Job 5".localized(), "Job 6".localized(), "Job 7".localized(), "Job 8".localized(), "Job 9".localized(), "Job 10".localized()]
    
    var arrClients: [String] = ["Client 1".localized(), "Client 2".localized(), "Client 3".localized(), "Client 4".localized(), "Client 5".localized(), "Client 6".localized(), "Client 7".localized(), "Client 8".localized(), "Client 9".localized(), "Client 10".localized()]
    
    var arrEmployee: [String] = ["Employee 1".localized(), "Employee 2".localized(), "Employee 3".localized(), "Employee 4".localized(), "Employee 5".localized(), "Employee 6".localized(), "Employee 7".localized(), "Employee 8".localized(), "Employee 9".localized(), "Employee 10".localized()]
    
    var arrDays:[String] = ["Monday".localized(), "Tuesday".localized(), "Wednesday".localized(), "Thursday".localized(), "Friday".localized(), "Saturday".localized(), "Sunday".localized()]
    
    class var sharedInstance: AppFunctions {
        return Singleton.sharedInstance
    }
    
    //MARK:- App Rating
    func rateApp(id: String) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id\(id)?mt=8&action=write-review") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK:- SVProgressHUD
    func customizationSVProgressHUD() {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setForegroundColor(Colors.labelColor)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.30))
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setFont(UIFont(name: Fonts.NunitoMedium, size: 13)!)
        SVProgressHUD.setRingRadius(18)
        
        SVProgressHUD.setRingThickness(2.5)
        SVProgressHUD.setCornerRadius(10.0)
    }
    
    class func showDefaultProgress() {
        SVProgressHUD.show()
    }
    
    class func showProgressWithTitle(title: String) {
        SVProgressHUD.show(withStatus: title)
    }
        
    class func hideProgress() {
        SVProgressHUD.dismiss()
    }
    
    // MARK: - UIStoryboard -
    class func mainStoryBoard() -> UIStoryboard {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryBoard
    }
    
    class func customerSupportStoryBoard() -> UIStoryboard {
        let customerSupportStoryBoard = UIStoryboard(name: "CustomerSupport", bundle: nil)
        return customerSupportStoryBoard
    }
    
    class func bossSidemenuStoryBoard() -> UIStoryboard {
        let bossSidemenuStoryBoard = UIStoryboard(name: "BossSidemenu", bundle: nil)
        return bossSidemenuStoryBoard
    }
    
    class func bossDashboardStoryBoard() -> UIStoryboard {
        let bossDashboardStoryBoard = UIStoryboard(name: "BossDashboard", bundle: nil)
        return bossDashboardStoryBoard
    }
    
    class func bossEmployeeStoryBoard() -> UIStoryboard {
        let bossEmployeeStoryBoard = UIStoryboard(name: "BossEmployee", bundle: nil)
        return bossEmployeeStoryBoard
    }
    
    class func bossEmployeeSettingsStoryBoard() -> UIStoryboard {
        let bossEmployeeSettingsStoryBoard = UIStoryboard(name: "BossEmployeeSetting", bundle: nil)
        return bossEmployeeSettingsStoryBoard
    }
    
    class func bossTimesheetStoryBoard() -> UIStoryboard {
        let bossTimesheetStoryBoard = UIStoryboard(name: "BossTimesheet", bundle: nil)
        return bossTimesheetStoryBoard
    }
    
    class func viewOnMapStoryBoard() -> UIStoryboard {
        let viewOnMapStoryBoard = UIStoryboard(name: "BossViewOnMap", bundle: nil)
        return viewOnMapStoryBoard
    }
    
    class func bossJobStoryBoard() -> UIStoryboard {
        let bossJobStoryBoard = UIStoryboard(name: "BossJob", bundle: nil)
        return bossJobStoryBoard
    }
    
    class func bossReportStoryBoard() -> UIStoryboard {
        let bossReportStoryBoard = UIStoryboard(name: "BossReport", bundle: nil)
        return bossReportStoryBoard
    }
    
    class func bossExpenseStoryBoard() -> UIStoryboard {
        let bossExpenseStoryBoard = UIStoryboard(name: "BossExpense", bundle: nil)
        return bossExpenseStoryBoard
    }
    
    class func bossVacationSickStoryBoard() -> UIStoryboard {
        let bossVacationSickStoryBoard = UIStoryboard(name: "BossVacationSick", bundle: nil)
        return bossVacationSickStoryBoard
    }
    
    class func bossSettingMenuStoryBoard() -> UIStoryboard {
        let bossSettingMenuStoryBoard = UIStoryboard(name: "BossSettingMenu", bundle: nil)
        return bossSettingMenuStoryBoard
    }
    
    class func bossInvoiceStoryBoard() -> UIStoryboard {
        let bossInvoiceStoryBoard = UIStoryboard(name: "BossInvoice", bundle: nil)
        return bossInvoiceStoryBoard
    }
    
    class func bossFreeTrialExpiredStoryBoard() -> UIStoryboard {
        let bossFreeTrialExpiredStoryBoard = UIStoryboard(name: "BossFreeTrialExpired", bundle: nil)
        return bossFreeTrialExpiredStoryBoard
    }
    
    class func bossSubscriptionsStoryBoard() -> UIStoryboard {
        let bossSubscriptionsStoryBoard = UIStoryboard(name: "BossSubscriptions", bundle: nil)
        return bossSubscriptionsStoryBoard
    }
    
    class func bossContactSalesStoryBoard() -> UIStoryboard {
        let bossContactSalesPopupStoryBoard = UIStoryboard(name: "BossContactSalesPopup", bundle: nil)
        return bossContactSalesPopupStoryBoard
    }
    
    class func employeeDashboardStoryBoard() -> UIStoryboard {
        let employeeDashboardStoryBoard = UIStoryboard(name: "EmployeeDashboard", bundle: nil)
        return employeeDashboardStoryBoard
    }
    
    class func employeeTabBarStoryBoard() -> UIStoryboard {
        let employeeTabBarStoryBoard = UIStoryboard(name: "EmployeeTabBar", bundle: nil)
        return employeeTabBarStoryBoard
    }
    
    class func employeeTimesheetStoryBoard() -> UIStoryboard {
        let employeeTimesheetStoryBoard = UIStoryboard(name: "EmployeeTimesheet", bundle: nil)
        return employeeTimesheetStoryBoard
    }
    
    class func employeeJobStoryBoard() -> UIStoryboard {
        let employeeJobStoryBoard = UIStoryboard(name: "EmployeeJob", bundle: nil)
        return employeeJobStoryBoard
    }
    
    class func employeeExpenseStoryBoard() -> UIStoryboard {
        let employeeExpenseStoryBoard = UIStoryboard(name: "EmployeeExpense", bundle: nil)
        return employeeExpenseStoryBoard
    }
    
    class func employeeVacationSickStoryBoard() -> UIStoryboard {
        let employeeVacationSickStoryBoard = UIStoryboard(name: "EmployeeVacationSick", bundle: nil)
        return employeeVacationSickStoryBoard
    }
    
    class func employeeSettingMenuStoryBoard() -> UIStoryboard {
        let employeeSettingMenuStoryBoard = UIStoryboard(name: "EmployeeSettingMenu", bundle: nil)
        return employeeSettingMenuStoryBoard
    }

    // MARK:- CONVERT DATE TO STRING METHOD -
    
    func convertDateToString(Date date: Date, DateFormat dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    // MARK:- CONVERT STRING TO DATE METHOD -
    
    func convertStringToDate(StrDate strDate: String, DateFormat dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = dateFormat
        //according to date format your date string
        guard let date = dateFormatter.date(from: strDate) else {
            fatalError()
        }
        return date
    }
    
    func convertStringToDateInRequestedTimeZone(StrDate strDate: String, DateFormat dateFormat: String, timeZone: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: timeZone) as TimeZone?
        dateFormatter.dateFormat = dateFormat
        //according to date format your date string
        guard let date = dateFormatter.date(from: strDate) else {
            fatalError()
        }
        return date
    }
    
    // MARK:- CONVERT DATE FORMAT METHOD -
    
    func formattedDateFromString(dateString: String, InputFormat inputFormat: String, OutputFormat outputformat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
//        inputFormatter.locale = Locale(identifier: "de_DE")
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
            outputFormatter.dateFormat = outputformat
            outputFormatter.amSymbol = "am"
            outputFormatter.pmSymbol = "pm"
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    //MARK: - Get Curernt Date and Time in Particular Timezone
    func getCurrentDateInSettingTimezone() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = API_RESPONSE_DATE_TIME_FORMAT
        let strDate = dateFormatter.string(from: Date())
        let dt = AppFunctions.sharedInstance.convertStringToDate(StrDate: strDate, DateFormat: API_RESPONSE_DATE_TIME_FORMAT)
        return dt
    }
    
    func getCurrentDateInRequestedTimezone(timeZone: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: timeZone) as TimeZone?
        dateFormatter.dateFormat = API_RESPONSE_DATE_TIME_FORMAT
        let strDate = dateFormatter.string(from: Date())
        let dt = AppFunctions.sharedInstance.convertStringToDateInRequestedTimeZone(StrDate: strDate, DateFormat: API_RESPONSE_DATE_TIME_FORMAT, timeZone: timeZone)
        return dt
    }
    
    func getCurrentDateInStringSettingTimezone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = API_RESPONSE_DATE_TIME_FORMAT
        let strDate = dateFormatter.string(from: Date())
        return strDate
    }
    
    func getCurrentDateTimeInSettingTimezone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = API_RESPONSE_DATE_TIME_FORMAT
        let strDate = dateFormatter.string(from: Date())
        
        let arrDateComponent = strDate.components(separatedBy: " ")
        return arrDateComponent[1]
    }
    
    func getCurrentDateTimeInSettingTimezoneWithAMPM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = API_RESPONSE_DATE_FORMAT + " " + fullToShortTimeFormat
        let strDate = dateFormatter.string(from: Date())
        
        let strTime = self.formattedDateFromString(dateString: strDate, InputFormat: API_RESPONSE_DATE_FORMAT + " " + fullToShortTimeFormat, OutputFormat: fullToShortTimeFormat)!
        return strTime
    }
    
    func getCurrentDateTimeWithAMPMInSpecificTimezone(timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: timeZone) as TimeZone?
        dateFormatter.dateFormat = API_RESPONSE_DATE_FORMAT + " " + fullToShortTimeFormat
        let strDate = dateFormatter.string(from: Date())
        
        let strTime = self.formattedDateFromString(dateString: strDate, InputFormat: API_RESPONSE_DATE_FORMAT + " " + fullToShortTimeFormat, OutputFormat: fullToShortTimeFormat)!
        return strTime
    }
    
    func getCurrentDateInRequiredFormat() -> Date {
        let currentTime = Date().getOnlyTimeWithHMMSSFormat()
        let currentDate = AppFunctions.sharedInstance.convertDateToString(Date: Date(), DateFormat: API_RESPONSE_DATE_FORMAT)
        let str = currentDate + " " + currentTime
        let dtPunchOut: Date = AppFunctions.sharedInstance.convertStringToDate(StrDate: str, DateFormat: API_RESPONSE_DATE_TIME_FORMAT)
        
        return dtPunchOut
    }
    
    func getCurrentDateInRequiredTimeZone(timeZone: String) -> Date {
        let currentTime = Date().getOnlyTimeWithHMMSSInRequiredTimezone(timeZone: timeZone)
        let currentDate = AppFunctions.sharedInstance.convertDateToString(Date: Date(), DateFormat: API_RESPONSE_DATE_FORMAT)
        let str = currentDate + " " + currentTime
        let dtPunchOut: Date = AppFunctions.sharedInstance.convertStringToDate(StrDate: str, DateFormat: API_RESPONSE_DATE_TIME_FORMAT)
        return dtPunchOut
    }
    
    func getDateFromTimeStamp(timeStamp: Int) -> String {
        let interval: TimeInterval = TimeInterval(timeStamp)
        
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = "dd MMMM, EEE" + " " + globalTimeFormat
        
        let strLastSyncDate = dateFormatter.string(from: date)
        return strLastSyncDate
        
//        if  let strTime = self.changeFormat(dateString: strLastSyncDate, InputFormat: "dd MMMM, EEE hh:mm a", OutputFormat: "dd MMMM, EEE" + " " + globalTimeFormat) {
//            return strTime
//        }
//        else {
//             return "-"
//        }
    }
    
    //MARK: - Convert Param To JSON
    func convertParameter(inJSONString dict: [AnyHashable: Any]) -> String {
        var jsonString = ""
        
        defer {
        }
        
        do{
            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: [])
            if jsonData == nil {
                debugPrint("Error While converting Dictionary tp JSON String.")
                throw MyError.FoundNil("xmlDict")
            }
            else {
                jsonString = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
            }
        } catch {
            debugPrint("error getting xml string: \(error)")
        }
        return jsonString
    }
    
    func convertStringtoAttributedText(strFirst: String, strFirstFont: UIFont, strFirstColor: UIColor, strSecond: String, strSecondFont: UIFont, strSecondColor: UIColor) -> NSMutableAttributedString {
        let attrs1 = [NSAttributedString.Key.font : strFirstFont, NSAttributedString.Key.foregroundColor : strFirstColor]
        let attrs2 = [NSAttributedString.Key.font : strSecondFont, NSAttributedString.Key.foregroundColor : strSecondColor]

        let attributedString1 = NSMutableAttributedString(string:strFirst.localized(), attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:strSecond.localized(), attributes:attrs2)

        attributedString1.append(attributedString2)
        return attributedString1
    }
    
    // MARK:- RELOAD TABLEVIEW -
    
    func reloadTableView(tableView: UITableView) {
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    // MARK:- RELOAD COLLECTIONVIEW -
    
    func reloadCollectionView(collectionView: UICollectionView) {
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
    }
    
    //MARK:- GET HOUR/MINUTE VALUE
    
    func checkHourValue(TotalHour totalHour: Int) -> String {
        if totalHour > 0 { return totalHour > 9 ? "\(totalHour)" : "\(totalHour)" }
        return "0"
    }
    
    func checkMinuteValue(TotalMinute totalMinute: Int) -> String {
        if totalMinute > 0 { return totalMinute > 9 ? "\(totalMinute)" : "0\(totalMinute)" }
        return "00"
    }
    
    // MARK:- CHECK USER DEFAULT KEY EXISTS -
    
    func containsUserDefaultKey(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    //MARK:- GET TOTAL DURATION
    func getTotalTime(_ array: [String]) -> String {
        // getting the summation of minutes and seconds
        var hourSummation = 0
        var minutesSummation = 0
        var secondsSummation = 0

        array.forEach { string in
            hourSummation += Int(string.components(separatedBy: ":")[0] )!
            minutesSummation += Int(string.components(separatedBy: ":")[1] )!
            secondsSummation += Int(string.components(separatedBy: ":")[2] )!
        }

        var totalMin = 0
        
        totalMin += (hourSummation * 60)
        totalMin += minutesSummation
        totalMin += (secondsSummation / 60)
        
        debugPrint(totalMin)
        return self.secondsToHoursMinutesSeconds(seconds: (totalMin * 60))
        
        /*
        // converting seconds to minutes
        let minutesInSeconds = secondsToMinutes(seconds: secondsSummation).0
//        let restOfSeconds = secondsToMinutes(seconds: secondsSummation).1

//         return "\(minutesSummation + minutesInSeconds)h \(restOfSeconds)m"
//        return "\(hourSummation)h \(minutesSummation + minutesInSeconds)m"
        return String(format: "%02dh %02dm", hourSummation,(minutesSummation + minutesInSeconds))
        */
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        return String(format: "%02dh %02dm", seconds / 3600,(seconds % 3600) / 60)
    }
    
    func secondsToMinutes (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func findTimeDifference(time1: Date, time2: Date) -> String {
        let elapsedTime = time1.timeIntervalSince(time2)
        
        let interval = Int(elapsedTime)
        let hour = (interval / 3600)
        let minute = (interval / 60) % 60
        let second = interval % 60
        return String(format: "%02dh %02dm %02ds", abs(hour), abs(minute), abs(second))
    }
    
    //MARK:- CHECK MORNING, AFTERNOON, NIGHT
    func getdayTypeLikeMorningEveningNight() -> String {
        let hour = Calendar.current.component(.hour, from: self.getCurrentDateInSettingTimezone())
        
        switch hour {
        case 6..<12 :
            return "Good Morning".localized()
        case 12 :
            return "Good Noon".localized()
        case 13..<17 :
            return "Good Afternoon".localized()
        case 17..<22 :
            return "Good Evening".localized()
        default:
            return "Good Night".localized()
        }
    }
    
    //MARK:- Generate Random Number
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    //MARK:- Toast
    func showLightStyleToastMesage(message :String) {
        var style = ToastStyle()
        style.backgroundColor = .white
        style.messageColor = .black
        appDelegate.window?.makeToast(message, duration: 2.0, position: .bottom, title: nil, image: nil, style: style, completion: nil)
    }
    
    func showDarkStyleToastMesage(message :String) {
        var style = ToastStyle()
        style.backgroundColor = .black
        style.messageColor = .white
        appDelegate.window?.makeToast(message, duration: 2.0, position: .bottom, title: nil, image: nil, style: style, completion: nil)
    }
    
    //MARK:- Check Location Status
    func checkLocationStatus() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        } else {
            return false
        }
    }
    
    //MARK:- Find Percentage betwwen 2 Number
    func calculatePercentage(totalValue:Double,currentValue:Double) -> Double {
        let calculateTime = ceil((currentValue/totalValue)*100)
        let finalTime = calculateTime/100
        return finalTime
    }
    
    //MARK:- Device Timezom and Timezon code
    func getDeviceTimeZone() -> String {
        return TimeZone.current.identifier
    }
    
    //MARK:- Hour Minute Extraction
    func getPunchLogTimeTotalDuration(times: [String]) ->  [String] {
        var arrTimes = times
        if let row = arrTimes.firstIndex(where: {$0 == "-"}) {
            arrTimes.remove(at: row)
        }
        
        var arrNewString = arrTimes.map { $0.replacingOccurrences(of: "h", with: "", options: .literal, range: nil) }
        arrNewString = arrNewString.map { $0.replacingOccurrences(of: "m", with: "", options: .literal, range: nil) }
        arrNewString = arrNewString.map { $0.replacingOccurrences(of: "s", with: "", options: .literal, range: nil) }
        arrNewString = arrNewString.map { $0.replacingOccurrences(of: " ", with: ":", options: .literal, range: nil) }
        
        return arrNewString
    }
    
    func converStringTimeToHHMM(strTime: String) -> [String] {
        let arrHHMM = strTime.components(separatedBy: " ")
        var arrNewString = arrHHMM.map { $0.replacingOccurrences(of: "h", with: "", options: .literal, range: nil) }
        arrNewString = arrNewString.map { $0.replacingOccurrences(of: "m", with: "", options: .literal, range: nil) }
        arrNewString = arrNewString.map { $0.replacingOccurrences(of: " ", with: ":", options: .literal, range: nil) }
        
        return arrNewString
    }
    
    //MARK:- Get Hours and Minutes from Minutes Only
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    //MARK:- Set Global Date Format
    func setGlobalDateFormat(strFormat: String) {
        if strFormat == "MM-DD-YYYY".localized() {
            globalDateFormat = "MM/dd/yyyy"
        }
        else if strFormat == "DD-MM-YYYY".localized() {
            globalDateFormat = "dd/MM/yyyy"
        }
    }
    
    //MARK:- Set Global Time Format
    func setGlobalTimeFormat(strFormat: String) {
        if strFormat == "12hours".localized() {
            globalTimeFormat = twelveHoursTimeFormat
        }
        else if strFormat == "24hours".localized() {
            globalTimeFormat = twentryFourHoursTimeFormat
        }
    }
    
    func setGlobalTimeZone(strTimezone: String) {
        globalTimezone = strTimezone
    }
}

enum MyError: Error {
    case FoundNil(String)
}

extension AppFunctions {
    class func checkInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func showToastMessage(message :String) {
        AppDelegate.shared().window?.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    class func displayAlert(_ msg: String!, title: String = "Alert".localized()) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        UIApplication.shared.topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func displayInvalidTokenAlert(_ msg: String!, title: String = "Alert".localized()) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: { action in
            appDelegate.logoutUser()
        })
        alertController.addAction(defaultAction)
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func displayConfirmationAlert(_ parent: UIViewController, title: String, message: String, btnTitle1: String, btnTitle2: String, actionBlock: @escaping (_ isConfirmed:Bool)->Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: btnTitle1, style: .cancel) { (action) in
            actionBlock(false)
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: btnTitle2, style: .default) { (action) in
            actionBlock(true)
        }
        alertController.addAction(okAction)
        parent.present(alertController, animated: true, completion: nil)
    }
    
    class func displayAlertWithOkAction(_ parent: UIViewController, title: String, message: String, btnTitle: String, actionBlock: @escaping (_ isOK:Bool)->Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: btnTitle, style: .default) { (action) in
            actionBlock(true)
        }
        alertController.addAction(okAction)
        parent.present(alertController, animated: true, completion: nil)
    }
    
    class func getSecondsFromHours(_ interval:Int)->Int{
        
        var minutes = 0
        
        switch (interval) {
        case 0:
            minutes = 0
        case 25:
            minutes = 8
        case 50:
            minutes = 23
        case 75:
            minutes = 38
        case 100:
            minutes = 0
        default:
            break
        }
        return minutes
    }
}
