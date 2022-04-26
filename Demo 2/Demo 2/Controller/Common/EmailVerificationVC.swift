//
//  EmailVerificationVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyJSON
import OTPFieldView

class EmailVerificationVC: BaseVC {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var lblVerificationCode: UILabel!
    @IBOutlet weak var lblEmailDescription: UILabel!
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    
    var strEmail: String = ""
    var strPassword: String = ""
    var isFromSignUp: Bool = false
    var isOtpEntered: Bool = false
    var strOtp: String = ""
    
    var strAPIVerificationCode: String = ""
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupOtpView() {
        let fieldsCount = 6
        let separatorSpace = 10
        self.otpTextFieldView.fieldsCount = 6
        self.otpTextFieldView.fieldBorderWidth = 0
        self.otpTextFieldView.fieldFont = UIFont.init(name: Fonts.NunitoLight, size: 15.0)!
        self.otpTextFieldView.defaultBackgroundColor = .white
        self.otpTextFieldView.filledBackgroundColor = .white
        self.otpTextFieldView.defaultBorderColor = .white
        self.otpTextFieldView.filledBorderColor = .white
        self.otpTextFieldView.cursorColor = .black
        self.otpTextFieldView.displayType = .roundedCorner
        self.otpTextFieldView.fieldSize = (((Constants.ScreenSize.SCREEN_WIDTH - 30.0) / CGFloat(fieldsCount)) - 12)// CGFloat((separatorSpace * (fieldsCount - 1))))
        self.otpTextFieldView.separatorSpace = CGFloat(separatorSpace)
        self.otpTextFieldView.shouldAllowIntermediateEditing = true
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
    }
    
    // MARK:- ACTIONS -
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        if self.isFromSignUp {
            let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.isFromOnBoardingScreen = false
            let navController = UINavigationController.init(rootViewController: vc)
            appDelegate.window?.rootViewController = navController
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnVerifyTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if !self.isOtpEntered {
            AppFunctions.displayAlert("Please provide code".localized())
        }
        else {
            if self.strOtp == self.strAPIVerificationCode {
                self.callRegisterStep1API()
            }
            else {
                AppFunctions.displayAlert("Please enter correct code".localized())
            }
        }
    }
    
    @IBAction func btnResendTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.resendVerificationCodeAPI()
    }
}

//MARK:- OTPFieldViewDelegate
extension EmailVerificationVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        debugPrint("Has entered all OTP? \(hasEntered)")
        self.isOtpEntered = hasEntered
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        debugPrint("OTPString: \(otpString)")
        self.strOtp = otpString
    }
}

// MARK:- API CALL -

extension EmailVerificationVC {
    func callRegisterStep1API() {
        // Check Internet Available
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["email"] = self.strEmail
        params["password"] = self.strPassword
        params["device_name"] = "ios"
        params["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        params["device_name"] = UIDevice.current.name
        params["device_model"] = UIDevice.modelName
        params["os_version"] = UIDevice.current.systemVersion
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.REGISTER_STEP_1, params: params as [String : AnyObject], headers: nil, success: {
            (JSONResponse) -> Void in
            AppFunctions.hideProgress()
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        let payload = response["payload"] as! Dictionary<String, Any>
                        let object: User = User.initWith(dict: payload)
                        if (try? JSONEncoder().encode(object)) != nil {
                            defaults.set(object.access_token, forKey: authToken)
                            defaults.synchronize()
                            
                            let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "ProfessionalDetailVC")
                            let navController = UINavigationController.init(rootViewController: vc)
                            appDelegate.window?.rootViewController = navController
                        }
                    } else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
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
    
    
    func resendVerificationCodeAPI() {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["email"] = self.strEmail
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.SEND_VERIFICATION, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        self.otpTextFieldView.initializeUI()
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                        
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let verification_code = payload["verification_code"] as? Int {
                                self.strAPIVerificationCode = "\(verification_code)"
                                print(self.strAPIVerificationCode)
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
    /*
     func resendVerificationCodeAPI() {
     if AppFunctions.checkInternet() == false {
     AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
     return
     }
     
     var params: [String:Any] = [:]
     params["email"] = self.strEmail
     
     let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
     debugPrint(strJSONParam)
     
     AppFunctions.showProgressWithTitle(title: pleaseWait)
     AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_RESEND_EMAIL, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
     
     AppFunctions.hideProgress()
     
     if JSONResponse != JSON.null {
     if let response = JSONResponse.rawValue as? [String : Any] {
     if response["code"] as! Int == 200 {
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
     
     func verifyCode() {
     // Check Internet Available
     if AppFunctions.checkInternet() == false {
     AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
     return
     }
     
     var params: [String:Any] = [:]
     params["device_token"] = defaults.value(forKey: FCMToken)
     params["device_id"] = appDelegate.deviceUUID
     params["verification_code"] = self.strOtp
     
     let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
     debugPrint(strJSONParam)
     
     AppFunctions.showProgressWithTitle(title: pleaseWait)
     AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.VERIFY_COMPANY_EMAIL, params: params as [String : AnyObject], headers: nil, success: {
     (JSONResponse) -> Void in
     
     AppFunctions.hideProgress()
     
     if JSONResponse != JSON.null {
     if let response = JSONResponse.rawValue as? [String : Any] {
     if response["code"] as! Int == 200 {
     AppFunctions.sharedInstance.showDarkStyleToastMesage(message: response["message"] as! String)
     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
     let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
     vc.isFromOnBoardingScreen = false
     let navigationController = UINavigationController.init(rootViewController: vc)
     appDelegate.window?.rootViewController = navigationController
     }
     } else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
     AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
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
     */
}


