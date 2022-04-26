//
//  AddEmployeeVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftValidators
import SwiftyJSON

class AddEmployeeVC: BaseVC {

    // MARK:- PROPERTIES & OUTLETS -
        
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var txtPayRateValue: UITextField!
    @IBOutlet weak var txtTimezone: UITextField!
    @IBOutlet weak var btnTimezone: UIButton!
            
    @IBOutlet weak var lblDefaultSetting: UILabel!
    @IBOutlet weak var lblVacationHourTitle: UILabel!
    @IBOutlet weak var lblVacationHourValue: UILabel!
    @IBOutlet weak var lblSickHourTitle: UILabel!
    @IBOutlet weak var lblSickHourValue: UILabel!
    @IBOutlet weak var lblOvertimeTitle: UILabel!
    @IBOutlet weak var lblOvertimePerDayValue: UILabel!
    @IBOutlet weak var lblOvertimePerWeekValue: UILabel!
    @IBOutlet weak var lblDash: UILabel!
    @IBOutlet weak var lblAutoLunchTitle: UILabel!
    @IBOutlet weak var lblAutoLunchValue: UILabel!
    
    @IBOutlet weak var lblDefaultInfo: UILabel!

    @IBOutlet weak var btnSave: UIButton!
    
    var objCompanyDefaultSetting: CompanyDefaultSettingObject!
    var objNewlyCreatedEmployee: BossEmployeeListObject!
    
    //Closure
    var onNewEmployeeCreate: ((_ objEmployee: BossEmployeeListObject) -> Void)? = nil
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    // MARK:- ACTIONS -
        
    @objc func backAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let phonetrimmedString = self.txtPhoneNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtFullName.isEmpty() == 1 {
            AppFunctions.displayAlert("Full name is required".localized())
        }
        else if self.txtEmail.isEmpty() == 1 {
            AppFunctions.displayAlert("Email address is required".localized())
        }
        else if !self.txtEmail.isEmail() {
            AppFunctions.displayAlert("Email address is invalid".localized())
        }
        else if self.txtPhoneNo.isEmpty() == 1 {
            AppFunctions.displayAlert("Phone number is required".localized())
        }
        else if !Validator.minLength(4).apply(phonetrimmedString) {
            AppFunctions.displayAlert("Phone number is invalid".localized())
        }
        else if self.txtPayRateValue.isEmpty() == 1 {
            AppFunctions.displayAlert("Pay rate is required".localized())
        }
        else if self.txtTimezone.isEmpty() == 1 {
            AppFunctions.displayAlert("Time zone is required".localized())
        }
        else {
            self.callCreateEmployeeAPI()
        }
    }
    
    @IBAction func btnCountryCodeClick(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "CountryPopupVC") as! CountryPopupVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

}

//MARK:- Country Code Selection Delegate
extension AddEmployeeVC: SelectCountryCodeDelegate {
    func selectedCountry(countryCode: String) {
        self.lblCountryCode.text = countryCode
    }
}

// MARK:- UITEXTFIELD DELEGATE METHOD -

extension AddEmployeeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        } else if string == " " {
            if textField == self.txtEmail {
                return false
            }
        }
        
        let singleCharValue = (string as NSString).character(at: 0)
        if singleCharValue > 127 {
            return false
        }
        
        /*
        if textField == self.txtPhoneNo {
            
            if (self.txtPhoneNo.text! as NSString).length > 11 {
                return false
            }
            if string == "."{
                return false
            }
            if let range = NUMERIC.range(of: string) {
                let count = NUMERIC.distance(from: range.lowerBound, to: range.upperBound)
                if count > 0 {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else
        */
        if textField == self.txtPayRateValue {
            
            if string.count == 0 {
                return true
            }

            let userEnteredString = textField.text ?? ""
            var newString = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as NSString
            newString = newString.replacingOccurrences(of: ".", with: "") as NSString

            let centAmount : NSInteger = newString.integerValue
            let amount = (Double(centAmount) / 100.0)

            if newString.length < 9 {
                let str = String(format: "%0.2f", arguments: [amount])
                self.txtPayRateValue.text = str
            }
            
            return false
        }
        return true
    }
}

//MARK:- API Call
extension AddEmployeeVC {
    func callCreateEmployeeAPI() {
        // Check Internet Available
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params[""] = self.txtFullName.text ?? ""
        params[""] = self.txtEmail.text ?? ""
        params[""] = self.lblCountryCode.text
        params[""] = self.txtPhoneNo.text ?? ""
        params[""] = self.lblCurrency.text
        params[""] = self.txtPayRateValue.text ?? ""
        params[""] = self.txtTimezone.text ?? ""
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_CREATE_EMPLOYEE, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            let objEmployee = BossEmployeeListObject.init(payload)
                            self.objNewlyCreatedEmployee = objEmployee
                            
                            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                            
                            var dict = [String: BossEmployeeListObject]()
                            dict["employee"] = self.objNewlyCreatedEmployee
                            //FIRE POST NOTIFICATION TO ADD NEWLY ADDED INTO EMPLOYEE LIST
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: addEmployee), object: nil, userInfo: dict)
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
}
