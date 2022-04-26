//
//  AppDelegate.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

import Firebase
import FirebaseCore
import FirebaseMessaging
import IQKeyboardManagerSwift
import SideMenuSwift
import Appirater
import AFDateHelper
import Alamofire
import Localize_Swift
import GoogleMaps
import GooglePlaces
import AVFoundation
import SwiftyJSON
import Reachability
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let drawerController = SideMenuController()
    var deviceUUID: String!
    
    var objLoggedInUser = User()
    var isUserPunchedIn: Bool = false
    var objSelectedJobForPunchIn: JobListObject!
    
    var objCompanySettings: BossSettingsObject!
    var objEmployeeSettings = EmployeeSettingsObject.init([:])
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var employeeTimesheeetStatus: Int = 0
    
    var punchInTimer : Timer?
    
    var trial_expire_day: Int = 0
    
    class func shared() -> (AppDelegate) {
        let sharedinstance = UIApplication.shared.delegate as! AppDelegate
        return sharedinstance
    }
    
    private var reachability : Reachability!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.reachability = try! Reachability()
        
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            debugPrint("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
        
        GMSServices.provideAPIKey(googleMapAPIKey)
        GMSPlacesClient.provideAPIKey(googleMapAPIKey) // Places API Key
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIView.self)
        
        SideMenuController.preferences.basic.menuWidth = (UIScreen.main.bounds.width * 0.8)
        SideMenuController.preferences.basic.statusBarBehavior = .none
        SideMenuController.preferences.basic.position = .sideBySide
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = false
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
//        SideMenuController.preferences.animation.shadowAlpha = 0.0
        SideMenuController.preferences.animation.shadowColor = .clear
        
        self.setApperance()
        
        self.getUUID()
        AppFunctions.sharedInstance.customizationSVProgressHUD()
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        defaults.set(false, forKey: isChartLoaded)
        defaults.synchronize()
        
        self.setupIAP()
        
        return true
    }
    
    //MARK:- Setup InApp Purchase
    func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            for product in products {
                
                if product.transaction.transactionState == .purchased ||
                    product.transaction.transactionState == .restored {
                    
                    if product.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                }
            }
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
            return true
        }
    }
    
    // MARK: - Apperance
    func setApperance() {
        UITabBar.appearance().itemWidth = (window?.frame.size.width)! / 5
        UITabBar.appearance().barTintColor = Colors.themeColor
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: Fonts.NunitoRegular, size: 11)!, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: Fonts.NunitoRegular, size: 11)!, NSAttributedString.Key.foregroundColor: Colors.badgeBGColor], for: .selected)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): Colors.labelColor], for: .normal)
        UITextField.appearance().tintColor = Colors.labelColor
        UITextField.appearance().placeHolderColor = Colors.textFieldPlaceHolderColor
    }
    
    func getUUID() {
        #if TARGET_IPHONE_SIMULATOR
        self.deviceUUID = fakeUDID;
        #else
        self.deviceUUID = UIDevice.current.identifierForVendor!.uuidString
        #endif
    }
    
    func logoutUser() {
        self.callLogoutAPI()
    }
    
    //MARK:- Check Internet
    
    func isInternetConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    //MARK:- Delete All Data From DB
    func delteAllDataFromDB() {
        do {
            try Database.shared.realm.write {
                Database.shared.realm.deleteAll()
            }
        } catch {
            
        }
    }
    
    //MARK:- Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        debugPrint(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debugPrint("APNs token retrieved: \(deviceToken)")
    }
}

//MARK:- USER NOTIFICATION CENTER DELEGATE

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        debugPrint(userInfo)
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        debugPrint(userInfo)
        completionHandler()
    }
}

//MARK:- Messaging Delegate
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("Firebase registration token: \(String(describing: fcmToken))")
    }
}

//MARK:- API Call
extension AppDelegate {
    func callLogoutAPI() {
        // Check Internet Available
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        params["device_name"] = UIDevice.current.name
        params["device_model"] = UIDevice.modelName
        params["os_version"] = UIDevice.current.systemVersion
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.LOGOUT, params: params as [String : AnyObject], headers: nil, success: {
            (JSONResponse) -> Void in
            AppFunctions.hideProgress()
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: response["message"] as! String)
                        self.clearDataAndMoveToLoginScreen()
                    } else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        self.clearDataAndMoveToLoginScreen()
                    } else {
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                    }
                }
            }
        }) { (error) in
            AppFunctions.hideProgress()
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    func clearDataAndMoveToLoginScreen() {
        if self.punchInTimer != nil {
            self.punchInTimer!.invalidate()
            self.punchInTimer = nil
        }
        
        defaults.removeObject(forKey: loggedInUserData)
        defaults.removeObject(forKey: authToken)
        defaults.set(false, forKey: isUserDenyLocationPermissionForOptional)
        defaults.set(nil, forKey: lastSyncTimestamp)
        defaults.set(false, forKey: isUserLoggedIN)
        defaults.set(false, forKey: IS_SUBSCRIBED_USER)
        defaults.removeObject(forKey: SUBSCRIBED_PACKAGE)
        defaults.synchronize()
        self.objSelectedJobForPunchIn = nil
        
        if appDelegate.objLoggedInUser.login_type != "Company".localized() {
            self.delteAllDataFromDB()
        }
        self.locationManager.stopUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.isFromOnBoardingScreen = false
            let navigationController = UINavigationController.init(rootViewController: vc)
            self.window?.rootViewController = navigationController
        }
    }
    
    func getEmployeeSettingsAPI() {
        if AppFunctions.checkInternet() == false {
            return
        }
        
        let params: [String:Any] = [:]
        
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.EMPLOYEE_SETTINGS, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            self.objEmployeeSettings = EmployeeSettingsObject.init(payload)
                        }
                    }
                }
            }
        }) { (error) in
        }
    }
}

