//
//  LoginVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyJSON
import LocalAuthentication

class LoginVC: BaseVC {

    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var constraintTopOfLabel: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomOfLabel: NSLayoutConstraint!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblTermsAndPrivacy: ActiveLabel!
    
    @IBOutlet weak var vwLoginWithTouchOrFace: UIView!
    @IBOutlet weak var imgVwTouchOrFace: UIImageView!
    @IBOutlet weak var lblLoginWithTouchOrFace: UILabel!
    @IBOutlet weak var btnLoginWithTounchOrFace: UIButton!
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    var isFromBoss: Bool = true
    var isFromOnBoardingScreen: Bool = false
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.txtEmail.isEmpty() == 1 {
            AppFunctions.displayAlert("Email address is required".localized())
        }
        else if !self.txtEmail.isEmail() {
            AppFunctions.displayAlert("Email address is invalid".localized())
        }
        else if self.txtPassword.isEmpty() == 1 {
            AppFunctions.displayAlert("Password is required".localized())
        }
        else {
            self.callLoginAPI(isManualLogin: true, email: self.txtEmail.text!, password: self.txtPassword.text!)
        }
    }
    
    @IBAction func btnLoginWithTouchOrFaceTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.authenticationWithTouchID()
    }
    
    //OPEN BIOMETRIC AUTHENTICATION DIALOG WHEN USER DO LOGIN WITH TOUCH ID AND CALL LOGIN API IF AUTHENTICATED SUCCESSFULLY OTHERWISE DISPLAY ERROR
    func authenticationWithTouchID() {
        let context : LAContext = LAContext()
        let myLocalizedReasonString = "Please use your Passcode".localized()
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                        self.callLoginAPI(isManualLogin: false, email: defaults.value(forKey: userEmail) as! String, password: defaults.value(forKey: userPassword) as! String)
                    }
                } else {
                    if let error = evaluateError {
                        DispatchQueue.main.async {
                            self.showErrorMessageForLAErrorCode(errorCode: (error as NSError).code)
                        }
                    }
                }
            }
        } else {
            if let error = authError {
                DispatchQueue.main.async {
                    self.showErrorMessageForLAErrorCode(errorCode: (error as NSError).code)
                }
            }
        }
    }
    
    //BIOMETRIC AUTHENTICATION ERRORS
    func showErrorMessageForLAErrorCode(errorCode: Int) {
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            debugPrint("Authentication was cancelled by application")
            
        case LAError.authenticationFailed.rawValue:
            debugPrint("The user failed to provide valid credentials")
            
        case LAError.invalidContext.rawValue:
            debugPrint("The context is invalid")
            
        case LAError.passcodeNotSet.rawValue:
            debugPrint("Passcode is not set on the device")
            
        case LAError.systemCancel.rawValue:
            debugPrint("Authentication was cancelled by the system")
            
        case LAError.biometryLockout.rawValue:
            debugPrint("Too many failed attempts.")
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "Too many failed attempts. Biometric is disabled.".localized())
            
        case LAError.biometryNotAvailable.rawValue:
            debugPrint("TouchID is not available on the device")
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "No biometric features available on this device.".localized())
            
        case LAError.biometryNotEnrolled.rawValue:
            debugPrint("TouchID is not enrolled on the device")
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "Biometric is not enrolled on the device.".localized())
            
        case LAError.userCancel.rawValue:
            debugPrint("The user did cancel")
            
        case LAError.userFallback.rawValue:
            debugPrint("The user chose to use the fallback")
            
        default:
            debugPrint("Did not find error code on LAError object")
            
        }
    }
    
    @IBAction func btnForgotPassClick(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
}

// MARK:- UITEXTFIELD DELEGATE METHOD -

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        } else if string == " " {
            if textField == self.txtEmail {
                return false
            }
        }
        return true
    }
}

//MARK:- API Call
extension LoginVC {
    func callLoginAPI(isManualLogin: Bool, email: String, password: String) {
        // Check Internet Available
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["email"] = email
        params["login_via"] = "2"
        params["device_token"] = defaults.value(forKey: FCMToken)
        params["device_id"] = appDelegate.deviceUUID
        params["password"] = password
        params["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        params["device_name"] = UIDevice.current.name
        params["device_model"] = UIDevice.modelName
        params["os_version"] = UIDevice.current.systemVersion
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.LOGIN, params: params as [String : AnyObject], headers: nil, success: {
            (JSONResponse) -> Void in
            AppFunctions.hideProgress()
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        self.loginSuccessfully(response: response, isManualLogin: isManualLogin, email: email, password: password)
                    } else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
                    } else if response["code"] as! Int == 422 {
                        if let payload = response["payload"] as? Dictionary<String, Any>, payload.count > 0, let company_info = payload["company_info"] as? Dictionary<String, Any>, company_info.count > 0 {//, payload["plan_detail"] == nil
                            self.loginSuccessfully(response: response, isManualLogin: isManualLogin, email: email, password: password)
                        } else {
                            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                        }
                    } else if response["code"] as! Int == 423 {
                        if let payload = response["payload"] as? Dictionary<String, Any>, payload.count > 0, let company_info = payload["company_info"] as? Dictionary<String, Any>, company_info.count > 0 {//, payload["plan_detail"] == nil
                            //Subscription is expired, go to dashboard and show popup to subscribe
                            self.loginSuccessfully(response: response, isManualLogin: isManualLogin, email: email, password: password)
                        } else {
                            let controller = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "InactiveOrExpiredAccountVC") as! InactiveOrExpiredAccountVC
                            controller.isFromLoginScreen = true
                            controller.modalPresentationStyle = .overCurrentContext
                            self.present(controller, animated: true, completion: nil)
                        }
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
    
    func loginSuccessfully(response: [String:Any], isManualLogin: Bool, email: String, password: String) {
        let payload = response["payload"] as! Dictionary<String, Any>
        
        var isVerifiedUser: Bool = false
        if let verify_email = payload["verify_email"] as? Bool {
            isVerifiedUser = verify_email
        }
        
        let object: User = User.initWith(dict: payload)
        defaults.set(object.access_token, forKey: authToken)
        defaults.synchronize()
        
        if object.login_type == "Company".localized() && !isVerifiedUser {
            debugPrint("BOSS EMAIL NOT VERIFIED")
            let controller = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
            controller.isFromSignUp = false
            controller.strEmail = object.email
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            if let data = try? JSONEncoder().encode(object) {
                if isManualLogin == true {
                    defaults.set(email, forKey: userEmail)
                    defaults.set(password, forKey: userPassword)
                }
                defaults.set(data, forKey: loggedInUserData)
                defaults.set(object.access_token, forKey: authToken)
                defaults.set(true, forKey: isUserLoggedIN)
                defaults.synchronize()
                
                appDelegate.objLoggedInUser = object
                appDelegate.employeeTimesheeetStatus = appDelegate.objLoggedInUser.objEmployeeInfo.objEmployeeSetting.timesheet_status
                
                //UPDATE GLOBAL DATE FORMAT AND TIME FORMAT
                if appDelegate.objLoggedInUser.login_type == "Company".localized() {
                    AppFunctions.sharedInstance.setGlobalDateFormat(strFormat: appDelegate.objLoggedInUser.objCompanyInfo.date_format)
                    AppFunctions.sharedInstance.setGlobalTimeFormat(strFormat: appDelegate.objLoggedInUser.objCompanyInfo.time_format)
                    AppFunctions.sharedInstance.setGlobalTimeZone(strTimezone: appDelegate.objLoggedInUser.objCompanyInfo.time_zone)
                }
                else {
                    AppFunctions.sharedInstance.setGlobalDateFormat(strFormat: appDelegate.objLoggedInUser.objEmployeeInfo.date_format)
                    AppFunctions.sharedInstance.setGlobalTimeFormat(strFormat: appDelegate.objLoggedInUser.objEmployeeInfo.time_format)
                    AppFunctions.sharedInstance.setGlobalTimeZone(strTimezone: appDelegate.objLoggedInUser.objEmployeeInfo.objEmployeeSetting.timezone)
                }
                
                //CHECK IF LOGGED IN USER HAS ANY ACTIVE PUNCH LOG THEN INSERT IT INTO DATABASE
                if appDelegate.objLoggedInUser.objEmployeeInfo.arrCurrentPunch.count > 0 {
                    let objCurrentPunchLog = appDelegate.objLoggedInUser.objEmployeeInfo.arrCurrentPunch[0]
                    
                    //INSERT PUNCHLOG DATA IN DB
                    EmployeePunch.addPunch(objTimeSheet: objCurrentPunchLog)
                    appDelegate.isUserPunchedIn = true
                }
                
                Jobs.deleteAllJobData()
                //INSERT JOBS DATA IN DB
                for i in 0..<appDelegate.objLoggedInUser.objEmployeeInfo.arrJobs.count  {
                    let objJob = appDelegate.objLoggedInUser.objEmployeeInfo.arrJobs[i]
                    Jobs.addJob(objJob: objJob)
                }
                
                //SAVE EMPLOYEE DASHBOARD DATA IN USERDEFAULT FOR FURTHER USE
                if let data = try? JSONEncoder().encode(appDelegate.objLoggedInUser.objEmployeeInfo) {
                    defaults.set(data, forKey:employeeDashboardData)
                    defaults.synchronize()
                }
                
                if appDelegate.objLoggedInUser.reg_status_two == true {
                    if appDelegate.objLoggedInUser.login_type == "Company" {
                        let leftMenuVC = AppFunctions.bossSidemenuStoryBoard().instantiateViewController(withIdentifier: "BossLeftMenuVC") as! BossLeftMenuVC
                        leftMenuVC.strSelectedItem = "Dashboard".localized()
                        let vc = AppFunctions.bossDashboardStoryBoard().instantiateViewController(withIdentifier: "BossDashboardVC") as! BossDashboardVC
                        let navController = UINavigationController.init(rootViewController: vc)
                        appDelegate.drawerController.contentViewController = navController
                        appDelegate.drawerController.menuViewController = leftMenuVC
                        appDelegate.window?.rootViewController = appDelegate.drawerController
                    } else {
                        
                        let controller = AppFunctions.employeeTabBarStoryBoard().instantiateViewController(withIdentifier: "EmployeeTabBarVC") as! EmployeeTabBarVC
                        controller.isEmployeeLoginForFirstTime = true
                        appDelegate.window?.rootViewController = controller
                    }
                } else {
                    let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "ProfessionalDetailVC")
                    let navController = UINavigationController.init(rootViewController: vc)
                    appDelegate.window?.rootViewController = navController
                }
            }
        }
    }
}
