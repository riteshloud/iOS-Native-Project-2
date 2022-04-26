//
//  Constant.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let defaults = UserDefaults.standard

let fullDateToShortDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
let fullToShortTimeFormat = "hh:mm:ss a"

let twelveHoursTimeFormat = "hh:mm a"
let twentryFourHoursTimeFormat = "HH:mm"

var headerDateFormat = "dd, MMM yyyy"
var globalDateFormat = "dd/MM/yyyy"
var globalTimeFormat = "hh:mm a"
var globalTimezone = ""

let API_REQUEST_DATE_FORMAT = "dd/MM/yyyy"
let API_REQUEST_TIME_FORMAT = "HH:mm:ss"
let API_RESPONSE_DATE_FORMAT = "yyyy-MM-dd"
let API_RESPONSE_DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss"

let SUBSCRIPTION_DATE_INPUT_FORMAT = "yyyy-MM-dd HH:mm:ss"
let SUBSCRIPTION_DATE_OUTPUT_FORMAT = "MMM dd, yyyy"

let ALPHA_NUMERIC: String = " ,-.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
let NUMERIC: String = ".1234567890"

let INTERNET_UNAVAILABLE = "Please check your internet connection and try again.".localized()
let NETWORK_ERROR = "Sorry we are unable to connect with the server, please try again later".localized()
let pleaseWait = "Please Wait".localized()
let DEVICE_TYPE = "ios"

let googleMapAPIKey = ""

let kAppID = ""

//DEV SERVER
let BASE_URL = ""
var termsURL = ""
var privacyURL = ""
var helpURL = ""

struct Constants {
    
    struct URLS {
        static let GET_COMMON_LIST = ""
        static let LOGIN = ""
        static let REGISTER_STEP_1 = ""
        static let REGISTER_STEP_2 = ""
        static let FORGOT_PASSWORD = ""
        
        //BOSS DASHBOARD
        static let BOSS_DASHBOARD = ""
        
        //BOSS EMPLOYEE
        static let BOSS_EMPLOYEE_LIST = ""
        static let BOSS_CREATE_EMPLOYEE = ""
        static let BOSS_UPDATE_EMPLOYEE = ""
        static let BOSS_DELETE_EMPLOYEE = ""
        static let BOSS_EMPLOYEE_TIMESHEET = ""
        static let BOSS_EMPLOYEE_BALANCE = ""
        static let BOSS_EMPLOYEE_LOCATION = ""
        static let BOSS_EMPLOYEE_LUNCHBREAK = ""
        static let BOSS_EMPLOYEE_OVERTIME = ""
        static let BOSS_EMPLOYEE_NOTIFICATION = ""
        static let BOSS_EMPLOYEE_SETTINGS = ""
        static let BOSS_EMPLOYEE_RESET_PASSWORD = ""
        static let BOSS_RESTORE_EMPLOYEE = ""
        static let BOSS_PERMANENT_DELETE_EMPLOYEE = ""
        
        static let BOSS_SETTINGS = ""
        static let BOSS_SETTINGS_UPDATE = ""
        static let BOSS_TIMESHEET_SETTING = ""
        static let BOSS_TIMEOFF = ""
        static let BOSS_DATETIME_SETTING = ""
        static let BOSS_LUNCHBREAK = ""
        static let BOSS_OVERTIME = ""
        static let BOSS_NOTIFICATION = ""
        static let BOSS_LOCATION = ""
        static let BOSS_CHANGE_PASSWORD = ""
        static let BOSS_GEO_FENCING_SETTING = ""
        
        static let BOSS_JOBLIST = ""
        static let BOSS_ADD_JOB = ""
        static let BOSS_EDIT_JOB = ""
        static let BOSS_DELETE_JOB = ""
        static let BOSS_COMPLETE_JOB = ""
        
        static let EMPLOYEE_JOBLIST = ""
        static let EMPLOYEE_ADD_JOB = ""
        static let EMPLOYEE_EDIT_JOB = ""
        static let EMPLOYEE_DELETE_JOB = ""
        
        static let BOSS_EXPENSE_LIST = ""
        static let BOSS_EDIT_EXPENSE = ""
        static let BOSS_DELETE_EXPENSE = ""
        
        static let CATEGORY_LIST = ""
        static let ADD_CATEGORY = ""
        static let EDIT_CATEGORY = ""
        static let DELETE_CATEGORY = ""
        
        static let EMPLOYEE_EXPENSE_LIST = ""
        static let EMPLOYEE_ADD_EXPENSE = ""
        static let EMPLOYEE_EDIT_EXPENSE = ""
        static let EMPLOYEE_DELETE_EXPENSE = ""
        
        //EMPLOYEE COMP TIME
        static let EMPLOYEE_COMPTIME_LIST = ""
        static let EMPLOYEE_COMPTIME_CREATE = ""
        static let EMPLOYEE_COMPTIME_UPDATE = ""
        static let EMPLOYEE_COMPTIME_DELETE = ""
        
        //BOSS COMP TIME
        static let BOSS_COMPTIME_LIST = ""
        static let BOSS_COMPTIME_CREATE = ""
        static let BOSS_COMPTIME_UPDATE = ""
        static let BOSS_COMPTIME_DELETE = ""
        
        //BOSS VACATION/SICK
        static let BOSS_VACATION_SICK_LIST = ""
        static let BOSS_VACATION_SICK_CREATE = ""
        static let BOSS_VACATION_SICK_UPDATE = ""
        static let BOSS_VACATION_SICK_DELETE = ""
        
        //EMPLOYEE VACATION/SICK
        static let EMPLOYEE_VACATION_SICK_LIST = ""
        static let EMPLOYEE_VACATION_SICK_CREATE = ""
        static let EMPLOYEE_VACATION_SICK_UPDATE = ""
        static let EMPLOYEE_VACATION_SICK_DELETE = ""
        
        //EMPLOYEE SETTINGS
        static let EMPLOYEE_CHANGE_PASSWORD = ""
        static let EMPLOYEE_SETTINGS = ""
        static let EMPLOYEE_UPDATE_SETTINGS = ""
        
        //BOSS INVOICES
        static let BOSS_INVOICE_LIST = ""
        static let BOSS_INVOICE_DELETE = ""
        static let BOSS_INVOICE_CLIENT_JOB_LIST = ""
        static let BOSS_INVOICE_SAVE = ""
        static let BOSS_INVOICE_VIEW = ""
        static let BOSS_INVOICE_EDIT = ""
        
        //BOSS CLIENT LIST
        static let BOSS_CLIENT_LIST = ""
        static let BOSS_CLIENT_CREATE = ""
        static let BOSS_CLIENT_UPDATE = ""
        static let BOSS_CLIENT_DELETE = ""
        
        //EMPLOYEE TIMESHEET
        static let EMPLOYEE_TIMESHEET = ""
        static let EMPLOYEE_ADD_MANUAL_HOURS = ""
        static let EMPLOYEE_EDIT_MANUAL_HOURS = ""
        static let EMPLOYEE_DELETE_MANUAL_HOURS = ""
        
        //BOSS TIMESHEET
        static let BOSS_TIMESHEET = ""
        static let BOSS_ADD_MANUAL_HOURS = ""
        static let BOSS_EDIT_MANUAL_HOURS = ""
        static let BOSS_DELETE_MANUAL_HOURS = ""
        
        //EMPLOYEE DASHBOARD
        static let EMPLOYEE_DASHBOARD = ""
        static let EMPLOYEE_PUNCH_IN = ""
        static let EMPLOYEE_PUNCH_OUT = ""
        
        //CUSTOMER SUPPORT
        static let TICKET_LIST = ""
        static let TICKET_CREATE = ""
        static let VIEW_TICKET = ""
        static let REPLY_TICKET = ""
        
        //SYNC
        static let SYNC_DATA = ""
        
        //
        static let EMPLOYEE_JOB_LIST = ""
        static let PUNCH_IN_OUT_DATA = ""
        
        static let COMPANY_EMPLOYEE_LIST = ""
        static let COMPANY_LOCATION_IN_MAP = ""
        
        //BOSS REPORT
        static let BOSS_REPORT_SUMMARY = ""
        static let BOSS_REPORT_PAYROLL = ""
        static let BOSS_REPORT_EXPENSES = ""
        
        static let LOGOUT = ""
        
        static let BOSS_GEO_LIST = ""
        static let BOSS_ADD_GEO_SITE = ""
        static let BOSS_EDIT_GEO_SITE = ""
        static let BOSS_DELETE_GEO_SITE = ""
        static let BOSS_EMPLOYEE_UPDATE_GEO_SITE = ""
        static let SET_AS_DEFAULT_GEO_SITE = ""
        
        static let BOSS_ACTIVE_EMPLOYEE = ""
        static let BOSS_RESEND_EMAIL = ""
        static let VERIFY_COMPANY_EMAIL = ""
        static let SEND_VERIFICATION = ""
        
        //BOSS SUBSCRIPTION
        static let BOSS_CHECK_SUBSCRIPTION = ""
        static let BOSS_SUBSCRIPTION_CREATE = ""
        
        //CONTACT SALES
        static let BOSS_CONTACT_SALES = ""
    }
    
    struct ScreenSize {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType {
        static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
        static let IS_IPHONE_11_PRO_MAX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
        static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    }
}

//MARK:- COLOR
struct Colors {
    static let themeColor = UIColor.init(hexString: "072156")!
    static let pageCurrentColor = UIColor.init(hexString: "4D6AE1")!
    static let pageDisableColor = UIColor.init(hexString: "E4E7F3")!
    static let labelColor = UIColor.init(hexString: "414141")!
    
    static let activeOrCompletedOrApprovedColor = UIColor.init(hexString: "25AC20")!
    static let archiveOrDeletedOrCanceledColor = UIColor.init(hexString: "EE2350")!
    static let ActiveArchiveNormalColor = UIColor.init(hexString: "7B7B7B")!
    
    static let optionSelectedColor = UIColor.init(hexString: "F2F3F3")!
    static let searchBarPlaceholderColor = UIColor.init(hexString: "858585")!
    static let searchBarBackgroundColor = UIColor.init(hexString: "F3F3F3")!
    
    static let badgeBGColor = UIColor.init(hexString: "FF900C")!
    static let viewBGColor = UIColor.init(hexString: "F4F5F7")!
    
    static let activeOrPendingColor = UIColor.init(hexString: "FC861C")!
    static let completedJobColor = UIColor.init(hexString: "4758F1")!
    
    static let setAsDefaultColor = UIColor.init(hexString: "B4B4B4")!
    static let textFieldPlaceHolderColor = UIColor.init(hexString: "8B8B8B")!
    
    static let sidemenuSelectedOptionBgColor = UIColor.init(hexString: "E6EAF2")!
    
    static let ticketOpenColor = UIColor.init(hexString: "59E396")!
    static let ticketDiscussionColor = UIColor.init(hexString: "FAC73C")!
    static let ticketResolvedColor = UIColor.init(hexString: "E53B3B")!

    static let BossDashboardOptionSelectedColor = UIColor.init(hexString: "457CEE")!
    static let gridLineColor = UIColor.init(hexString: "EEEEEE")!
    
    static let punchInBGColor = UIColor.init(hexString: "00B70C")!
    static let punchOutBGColor = UIColor.init(hexString: "EB3049")!
    
    //PACKAGE
    static let sliderMaxColor = UIColor.init(hexString: "5889F0")!
    static let cancelPlanButtonColor = UIColor.init(hexString: "E11F2C")!
    static let planDetailsBGColor = UIColor.init(hexString: "3B74EB")!
}

//MARK:- FONT
struct Fonts {
    
    static let NunitoRegular = "Nunito-Regular"
    static let NunitoBold = "Nunito-Bold"
    static let NunitoLight = "Nunito-Light"
    static let NunitoMedium = "Nunito-Medium"
}

let webViewSource: String = "var meta = document.createElement('meta');" +
"meta.name = 'viewport';" +
"meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
"var head = document.getElementsByTagName('head')[0];" +
"head.appendChild(meta);"

struct Document {
    let uploadParameterKey: String
    let data: Data
    let name: String
    let fileName: String
    let mimeType: String
    var image: UIImage?
}

//MARK:- UserDefault Keys
//BOSS EMPLOYEE
let addEmployee = "addEmployee"
let updateEmployee = "updateEmployee"
let deleteEmployee = "deleteEmployee"

//BOSS JOB
let addBossJob = "addBossJob"
let updateBossJob = "updateBossJob"
let deleteBossJob = "deleteBossJob"

//EMPLOYEE JOB
let addEmployeeJob = "addEmployeeJob"
let updateEmployeeJob = "updateEmployeeJob"
let deleteEmployeeJob = "deleteEmployeeJob"

//EMPLOYEE EXPENSE
let addEmployeeExpense = "addEmployeeExpense"
let updateEmployeeExpense = "updateEmployeeExpense"
let deleteEmployeeExpense = "deleteEmployeeExpense"
let updateBossExpense = "updateBossExpense"
let deleteBossExpense = "deleteBossExpense"

//CATEGORY
let addCategory = "addCategory"
let updateCategory = "updateCategory"
let deleteCategory = "deleteCategory"

//EMPLOYEE COMP TIME
let addEmployeeCompTime = "addEmployeeCompTime"
let updateEmployeeCompTime = "updateEmployeeCompTime"

//BOSS COMP TIME
let addBossCompTime = "addBossCompTime"
let updateBossCompTime = "updateBossCompTime"

//BOSS VACATION SICK
let addBossVacationSick = "addBossVacationSick"
let updateBossVacationSick = "updateBossVacationSick"
let deleteBossVacationSick = "deleteBossVacationSick"

//EMPLOYEE VACATION SICK
let addEmployeeVacationSick = "addEmployeeVacationSick"
let updateEmployeeVacationSick = "updateEmployeeVacationSick"
let deleteEmployeeVacationSick = "deleteEmployeeVacationSick"

//BOSS INVOICE
let addBossInvoice = "addBossInvoice"
let updateBossInvoice = "updateBossInvoice"
let deleteBossInvoice = "deleteBossInvoice"

//CUSTOMER SUPPORT
let addTicket = "addTicket"

//BOSS MANAGE CLIENT
let addBossClient = "addBossClient"
let updateBossClient = "updateBossClient"
let deleteBossClient = "deleteBossClient"

//BOSS TIMESHEET
let addBossTimesheet = "addBossTimesheet"
let updateBossTimesheet = "updateBossTimesheet"
let deleteBossTimesheet = "deleteBossTimesheet"

//EMPLOYEE TIMESHEET
let addEmployeeTimesheet = "addEmployeeTimesheet"
let updateEmployeeTimesheet = "updateEmployeeTimesheet"
let deleteEmployeeTimesheet = "deleteEmployeeTimesheet"

// EMPLOYEE UPDATE SETTING
let updateEmployeeSetting = "updateEmployeeSetting"

//LANGUAGE
let currentLanguage = "userLanguage"

let authToken = "_token"
let loggedInUserData = "loggedInUserData"
let isUserLoggedIN = "isUserLoggedIN"
let isUserDenyLocationPermissionForOptional = "isUserDenyLocationPermissionForOptional"
let lastSyncTimestamp = "lastsync"
let configurationData = "configData"
let FCMToken = "FCMToken"
let isOnBoradingScreenDisplayed = "isOnBoradingScreenDisplayed"


let userEmail = "loggedInUserEmail"
let userPassword = "loggedInUserPassword"

let employeeDashboardData = "employeeDashboardData"
let fingerprintLockEnabled = "fingerprintLockEnabled"

let isChartLoaded = "isChartLoaded"

let IS_SUBSCRIBED_USER = "isSubscribeUser"
let SUBSCRIBED_PACKAGE = "subscribed_package"

//IN APP PURCHASE
let cancelSubscriptionURL = ""
let IAP_SHARED_SECRET: String = ""
struct PACKAGES {
    static let EXTRASMALL_MONTHLY = ""
    static let SMALL_MONTHLY = ""
    static let MEDIUM_MONTHLY = ""
    static let LARGE_MONTHLY = ""
    static let EXTRALARGE_MONTHLY = ""
    static let SAPPHIRE_MONTHLY = ""
    static let RUBY_MONTHLY = ""
    static let EMERALD_MONTHLY = ""
    static let PEARL_MONTHLY = ""
    static let OPAL_MONTHLY = ""
    static let PREMIUM_MONTHLY = ""
    static let DELUX_MONTHLY = ""
    static let PLATINUM_MONTHLY = ""
}
