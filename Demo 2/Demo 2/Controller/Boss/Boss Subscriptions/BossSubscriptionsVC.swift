//
//  BossSubscriptionsVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import SwiftyJSON

protocol BossSubscriptionsDelegate {
    func productPurchased(productPurchased: String)
}

class BossSubscriptionsVC: BaseVC {

    @IBOutlet weak var vwMainBg: UIView!
    @IBOutlet weak var vwPackageDetail: UIView!
    @IBOutlet weak var stckVwPackageDetail: UIStackView!
    @IBOutlet weak var lblPackagePrice: UILabel!
    @IBOutlet weak var lblNoOfUsers: UILabel!
    @IBOutlet weak var lblUsersPerMonth: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var vwSlider: UIView!
    @IBOutlet weak var sldUsers: CustomSlider!
    @IBOutlet weak var lblSliderValue: UILabel!
    @IBOutlet weak var lblLookForMoreUsers: UILabel!
    @IBOutlet weak var btnContactSales: UIButton!
    
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var tblInfo: ContentSizedTableView!
    @IBOutlet weak var lblSubscriptionTerms: UILabel!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnTermsOfService: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var btnSubscribe: UIButton!
    
    var arrInfo: [String] = ["Punch in/out from anywhere", "Free admin account", "Log your expenses", "Vacation / Sick tracking", "Notifications", "Timesheet management", "Time tracking activity log with GPS", "Payroll Reporting", "Job invoicing", "Comp Time tracking", "Realtime reporting", "Expedited support", "Time sheet editing"]
    var arrPackagesMonthly: [BossSubscriptionObject] = []
    var currentSelectedPackage: String = PACKAGES.EXTRASMALL_MONTHLY
    var delegate: BossSubscriptionsDelegate?
    
    var isFromSideMenu: Bool = false
    var isFromFreeTrialExpired: Bool = false
    
    var RestorePurchaseTryCount : Int = 0
    
    var active_employee: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    fileprivate func setDowngradeButton() {
        self.btnSubscribe.setTitle("Downgrade".localized(), for: .normal)
    }
    
    fileprivate func setUpgradeButton() {
        self.btnSubscribe.setTitle("Upgrade".localized(), for: .normal)
    }
    
    fileprivate func setTrialPeriod() {
        if !self.isFromFreeTrialExpired {
            self.lblPackagePrice.text = "Trial Period".localized()
            self.lblUsersPerMonth.text = "\(self.active_employee)" + " " + "users".localized()
            self.lblValidity.text = "Expires in".localized() + " " + appDelegate.trial_expire_day.string! + " " + "days".localized()
            self.btnCancel.superview?.isHidden = true
        } else {
            //self.lblPackagePrice.text = (self.arrPackagesMonthly.count > 0) ? self.arrPackagesMonthly[0].packagePrice : "$14.99"
            self.lblPackagePrice.text = "Your plan is expired. Please purchase new one."
            self.lblUsersPerMonth.text = ""
            self.lblValidity.text = ""
            self.btnCancel.superview?.isHidden = true
            self.btnSubscribe.isHidden = true
        }
        self.sldUsers.value = 5
        self.lblSliderValue.text = "\(Int(self.sldUsers.value))"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.lblSliderValue.center = self.setUISliderThumbValueWithLabel(slider: self.sldUsers)
        }
        self.currentSelectedPackage = PACKAGES.EXTRASMALL_MONTHLY
    }
    
    fileprivate func setSubscribeButton() {
        self.btnSubscribe.setTitle("Subscribe".localized(), for: [])
    }
    
    //MARK:- GET PRODUCT INFORMATION -
    
    func retrieveProductInfo() {
        self.sldUsers.isUserInteractionEnabled = false
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        
        let reqForProd = NSSet(array: [PACKAGES.EXTRASMALL_MONTHLY, PACKAGES.SMALL_MONTHLY, PACKAGES.MEDIUM_MONTHLY, PACKAGES.LARGE_MONTHLY, PACKAGES.EXTRALARGE_MONTHLY, PACKAGES.SAPPHIRE_MONTHLY, PACKAGES.RUBY_MONTHLY, PACKAGES.EMERALD_MONTHLY, PACKAGES.PEARL_MONTHLY, PACKAGES.OPAL_MONTHLY, PACKAGES.PREMIUM_MONTHLY, PACKAGES.DELUX_MONTHLY, PACKAGES.PLATINUM_MONTHLY])
        SwiftyStoreKit.retrieveProductsInfo(reqForProd as! Set<String>) { result in
            
            self.arrPackagesMonthly.removeAll()
            
            AppFunctions.hideProgress()
            for product in result.retrievedProducts {
                if product.productIdentifier == PACKAGES.EXTRASMALL_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "00"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 5
                    objSubscription.packageId = PACKAGES.EXTRASMALL_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.SMALL_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "01"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 10
                    objSubscription.packageId = PACKAGES.SMALL_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.MEDIUM_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "02"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 15
                    objSubscription.packageId = PACKAGES.MEDIUM_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.LARGE_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "03"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 20
                    objSubscription.packageId = PACKAGES.LARGE_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.EXTRALARGE_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "04"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 25
                    objSubscription.packageId = PACKAGES.EXTRALARGE_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.SAPPHIRE_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "05"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 30
                    objSubscription.packageId = PACKAGES.SAPPHIRE_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.RUBY_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "06"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 35
                    objSubscription.packageId = PACKAGES.RUBY_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.EMERALD_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "07"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 40
                    objSubscription.packageId = PACKAGES.EMERALD_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.PEARL_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "08"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 45
                    objSubscription.packageId = PACKAGES.PEARL_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.OPAL_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "09"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 50
                    objSubscription.packageId = PACKAGES.OPAL_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.PREMIUM_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "10"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 55
                    objSubscription.packageId = PACKAGES.PREMIUM_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.DELUX_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "11"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 100
                    objSubscription.packageId = PACKAGES.DELUX_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                } else if product.productIdentifier == PACKAGES.PLATINUM_MONTHLY {
                    let objSubscription: BossSubscriptionObject = BossSubscriptionObject([:])
                    objSubscription.id = "12"
                    objSubscription.packageName = "Monthly".localized()
                    objSubscription.userLimit = 150
                    objSubscription.packageId = PACKAGES.PLATINUM_MONTHLY
                    objSubscription.packagePrice = product.localizedPrice ?? ""
                    self.arrPackagesMonthly.append(objSubscription)
                }
            }
            
            //SORTED ARRAY BY ID
//            self.arrPackagesMonthly = (self.arrPackagesMonthly).sorted {
//                ($0.id) < ($1.id)
//            }
            self.arrPackagesMonthly.sort(by: { $0.id < $1.id })
            self.sldUsers.isUserInteractionEnabled = true
            
            if result.retrievedProducts.count == reqForProd.count {
                debugPrint(result.retrievedProducts)
                //self.collectionView.reloadData()
                self.callCheckSubscription()
            } else {
                //debugPrint("Error: \(result.error!)")//Change - comment this
            }
        }
    }
    
    // MARK:- HELPER -
    
    //PACKAGE
    func subscribePackage(packageId: String) {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        SwiftyStoreKit.purchaseProduct(packageId) { result in
            AppFunctions.hideProgress()
            
            switch result {
            case .success( _):
                let receiptUrl = Bundle.main.appStoreReceiptURL
                var receipt : Data!
                do {
                    receipt = try Data(contentsOf: receiptUrl!, options: NSData.ReadingOptions())
                } catch {
                    debugPrint("Unresolved error")
                }
                let receiptdata: String = receipt.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
                self.callUserSubscription(ReceiptData: receiptdata, productId: packageId)
            case .error(let error):
                AppFunctions.sharedInstance.showDarkStyleToastMesage(message: error.localizedDescription)
            }
        }
    }
    
    func setUISliderThumbValueWithLabel(slider: UISlider) -> CGPoint {
        let slidertTrack: CGRect = slider.trackRect(forBounds: slider.bounds)
        let sliderFrm: CGRect = slider .thumbRect(forBounds: slider.bounds, trackRect: slidertTrack, value: slider.value)
        return CGPoint(x: sliderFrm.origin.x + slider.frame.origin.x + 11, y: slider.frame.origin.y + 40)
    }
    
    // MARK:- ACTIONS -
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func menuAction() {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        debugPrint(sender.value)
        self.lblSliderValue.isHidden = false
        self.btnSubscribe.isHidden = false
        let intSldValue = Int(round(sender.value)) - (Int(round(sender.value)) % 5)
        self.lblSliderValue.text = "\(intSldValue)"
        self.lblUsersPerMonth.text = "\(intSldValue)" + " " + "users".localized()
        self.lblSliderValue.center = self.setUISliderThumbValueWithLabel(slider: sender)
        self.lblValidity.text = ""
        var objBossSubscribed = BossSubscribedObject([:])
        if let data = defaults.value(forKey: SUBSCRIBED_PACKAGE) as? Data, let object = try? JSONDecoder().decode(BossSubscribedObject.self, from: data) {
            objBossSubscribed = object
        }
        
        if intSldValue > 100 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[12].packagePrice + "/" + "month".localized()//"$399.99"
            self.currentSelectedPackage = PACKAGES.PLATINUM_MONTHLY
            //self.lblUsersPerMonth.text = "150" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 150 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 150 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 55 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[11].packagePrice + "/" + "month".localized()//"$249.99"
            self.currentSelectedPackage = PACKAGES.DELUX_MONTHLY
            //self.lblUsersPerMonth.text = "100" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 100 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 100 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 50 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[10].packagePrice + "/" + "month".localized()//"$164.99"
            self.currentSelectedPackage = PACKAGES.PREMIUM_MONTHLY
            //self.lblUsersPerMonth.text = "55" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 55 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 55 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 45 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[9].packagePrice + "/" + "month".localized()//"$149.99"
            self.currentSelectedPackage = PACKAGES.OPAL_MONTHLY
            //self.lblUsersPerMonth.text = "50" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 50 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 50 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 40 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[8].packagePrice + "/" + "month".localized()//"$134.99"
            self.currentSelectedPackage = PACKAGES.PEARL_MONTHLY
            //self.lblUsersPerMonth.text = "45" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 45 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 45 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 35 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[7].packagePrice + "/" + "month".localized()//"$119.99"
            self.currentSelectedPackage = PACKAGES.EMERALD_MONTHLY
            //self.lblUsersPerMonth.text = "40" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 40 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 40 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 30 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[6].packagePrice + "/" + "month".localized()//"$104.99"
            self.currentSelectedPackage = PACKAGES.RUBY_MONTHLY
            //self.lblUsersPerMonth.text = "35" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 35 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 35 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 25 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[5].packagePrice + "/" + "month".localized()//"$89.99"
            self.currentSelectedPackage = PACKAGES.SAPPHIRE_MONTHLY
            //self.lblUsersPerMonth.text = "30" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 30 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 30 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 20 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[4].packagePrice + "/" + "month".localized()//"$74.99"
            self.currentSelectedPackage = PACKAGES.EXTRALARGE_MONTHLY
            //self.lblUsersPerMonth.text = "25" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 25 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 25 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 15 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[3].packagePrice + "/" + "month".localized()//"$59.99"
            self.currentSelectedPackage = PACKAGES.LARGE_MONTHLY
            //self.lblUsersPerMonth.text = "20" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 20 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 20 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 10 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[2].packagePrice + "/" + "month".localized()//"$44.99"
            self.currentSelectedPackage = PACKAGES.MEDIUM_MONTHLY
            //self.lblUsersPerMonth.text = "15" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 15 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 15 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else if intSldValue > 5 {
            self.lblPackagePrice.text = self.arrPackagesMonthly[1].packagePrice + "/" + "month".localized()//"$29.99"
            self.currentSelectedPackage = PACKAGES.SMALL_MONTHLY
            //self.lblUsersPerMonth.text = "10" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 10 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 10 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        } else {
            self.lblPackagePrice.text = self.arrPackagesMonthly[0].packagePrice + "/" + "month".localized()//"$14.99"
            self.currentSelectedPackage = PACKAGES.EXTRASMALL_MONTHLY
            //self.lblUsersPerMonth.text = "5" + " " + "users".localized()
            if objBossSubscribed.no_of_users == 0 {
                self.setSubscribeButton()
            } else if objBossSubscribed.no_of_users > 5 {
                self.setDowngradeButton()
            } else if objBossSubscribed.no_of_users < 5 {
                self.setUpgradeButton()
            } else {
                self.setSubscribeButton()
                self.lblValidity.text = "Expires on".localized() + " " + objBossSubscribed.subscription_enddate
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.lblSliderValue.text = "\(intSldValue)"
            self.lblSliderValue.center = self.setUISliderThumbValueWithLabel(slider: sender)
        })
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        if let url = URL(string: cancelSubscriptionURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (completed) in
                
            })
        }
    }
    
    @IBAction func btnRestoreTapped(_ sender: UIButton) {
        self.RestorePurchaseTryCount = 0
        self.restorePurchase()
    }
    
    @IBAction func btnSubscribeTapped(_ sender: UIButton) {
        if let data = defaults.value(forKey: SUBSCRIBED_PACKAGE) as? Data, let object = try? JSONDecoder().decode(BossSubscribedObject.self, from: data), Int(self.sldUsers.value) < object.active_employee {
            self.active_employee = object.active_employee
            AppFunctions.displayConfirmationAlert(self, title: "Downgrade subscription".localized(), message: "You cannot dowgrade to selected plan as your active employee count is greater than the plan you trying to subscribe. Please archive employee before you downgrade your subscription.".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "OK".localized(), actionBlock: { (isConfirmed) in
                if isConfirmed {
                    //Redirect to employee screen
                    let vc = AppFunctions.bossEmployeeStoryBoard().instantiateViewController(withIdentifier: "EmployeeListVC") as! EmployeeListVC
                    vc.isFromSideMenu = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        } else if let data = defaults.value(forKey: SUBSCRIBED_PACKAGE) as? Data, let object = try? JSONDecoder().decode(BossSubscribedObject.self, from: data), self.currentSelectedPackage == object.objGetPlan.ios_plan_id {
            self.active_employee = object.active_employee
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "You are already subscribed with the current package. Slide right or left to upgrade or downgrade.".localized())
        } else if self.lblPackagePrice.text!.contains("Trial") || self.lblSliderValue.isHidden {
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "Please select user and package".localized())
        } else if Int(self.lblSliderValue.text!)! < self.active_employee {
            AppFunctions.displayConfirmationAlert(self, title: "Downgrade subscription".localized(), message: "You cannot dowgrade to selected plan as your active employee count is greater than the plan you trying to subscribe. Please archive employee before you downgrade your subscription.".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "OK".localized(), actionBlock: { (isConfirmed) in
                if isConfirmed {
                    //Redirect to employee screen
                    let vc = AppFunctions.bossEmployeeStoryBoard().instantiateViewController(withIdentifier: "EmployeeListVC") as! EmployeeListVC
                    vc.isFromSideMenu = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        } else {
            self.subscribePackage(packageId: self.currentSelectedPackage)
        }
    }
}

// MARK:- UITABLEVIEW DATASOURCE & DELEGATE -

extension BossSubscriptionsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BossSubscriptionsCell") as! BossSubscriptionsCell
        cell.lblTitle.text = self.arrInfo[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - API -
extension BossSubscriptionsVC {
    func refreshPurchaseReceipts(productId: String) { // CALL WHEN WE GOT PRODUCT ID FROM API
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: IAP_SHARED_SECRET)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            AppFunctions.hideProgress()
            switch result {
            case .success(let receipt):
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    debugPrint("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    self.setSubscribeButton()
                case .expired(let expiryDate, let items):
                    debugPrint("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    defaults.set(false, forKey: IS_SUBSCRIBED_USER)
                    defaults.synchronize()
                    
                    //IF USER SUBSCRIPTION IS EXPIRED THEN WE NEED TO SHOW SUBSCRIBE BUTTON
                    self.setTrialPeriod()
                    self.setSubscribeButton()
                    defaults.set(false, forKey: IS_SUBSCRIBED_USER)
                    defaults.removeObject(forKey: SUBSCRIBED_PACKAGE)
                    defaults.synchronize()
                    
                //self.getCompanySettingsAPI(isNeedToRefreshReceipt: false)
//                    AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "Your subscription is expired".localized())
                case .notPurchased:
                    debugPrint("The user has never purchased \(productId)")
                }
            case .error(let error):
                debugPrint("Receipt verification failed: \(error)")
            }
        }
    }
    
    @objc func restorePurchase() {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: IAP_SHARED_SECRET)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            AppFunctions.hideProgress()
            if case .error(let error) = result {
                print("refresh receipt Error  : \(error)")
                
                AppFunctions.hideProgress()
                self.RestorePurchaseTryCount += 1
                
                if self.RestorePurchaseTryCount < 2 {
                    self.perform(#selector(BossSubscriptionsVC.restorePurchase), with: nil, afterDelay: 0.5)
                }
                AppFunctions.hideProgress()
            } else if case .success(let success) = result {
                if (success["latest_receipt_info"] != nil) {
                    if let purchaseReceiptInfo: NSArray = success["latest_receipt_info"] as? NSArray {
                        if let dicReceiptData: NSDictionary = purchaseReceiptInfo.firstObject as? NSDictionary {
                            if dicReceiptData.value(forKey: "cancellation_date") == nil {
                                if let productID = dicReceiptData["product_id"] as? String {
                                    debugPrint("productID: \(productID)")
                                    self.GettingLatestReceiptOnRestore(productId: productID)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func GettingLatestReceiptOnRestore(productId: String) {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        let recuptUrl = Bundle.main.appStoreReceiptURL
        var receipt : Data!
        
        do {
            receipt = try Data(contentsOf: recuptUrl!, options: NSData.ReadingOptions())
        } catch {
            print("Unresolved error")
        }
        
        if receipt == nil {
            AppFunctions.hideProgress()
            return
        }
        
        let receiptdata:NSString! = receipt.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed) as NSString
        
        AppFunctions.hideProgress()
        
        self.callUserSubscription(ReceiptData: receiptdata as String, productId: productId)
    }
}

//MARK:- CustomSlider
class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 10))
    }
}

//MARK:- API CALL -

extension BossSubscriptionsVC {
    //CHECK SUBSCRIPTION API
    func callCheckSubscription() {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["device_type"] = DEVICE_TYPE
        
        AppFunctions.showDefaultProgress()
        
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_CHECK_SUBSCRIPTION, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) -> Void in
            
            AppFunctions.hideProgress()
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let subscription = payload["subscription"] as? Dictionary<String, Any> {
                                self.lblSliderValue.isHidden = false
                                self.btnCancel.superview?.isHidden = false
                                self.btnSubscribe.isHidden = false
                                
                                defaults.set(true, forKey: IS_SUBSCRIBED_USER)
                                defaults.synchronize()
                                
                                let bossSubscribedObject = BossSubscribedObject(subscription)
                                self.delegate?.productPurchased(productPurchased: bossSubscribedObject.plan_id)
                                self.lblPackagePrice.text = bossSubscribedObject.price + "/" + "month".localized()
                                
                                if self.arrPackagesMonthly.count > 0 {
                                    switch bossSubscribedObject.objGetPlan.ios_plan_id {
                                    case PACKAGES.EXTRASMALL_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[0].packagePrice + "/" + "month".localized()//"$14.99"
                                    case PACKAGES.SMALL_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[1].packagePrice + "/" + "month".localized()//"$29.99"
                                    case PACKAGES.MEDIUM_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[2].packagePrice + "/" + "month".localized()//"$44.99"
                                    case PACKAGES.LARGE_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[3].packagePrice + "/" + "month".localized()//"$59.99"
                                    case PACKAGES.EXTRALARGE_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[4].packagePrice + "/" + "month".localized()//"$74.99"
                                    case PACKAGES.SAPPHIRE_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[5].packagePrice + "/" + "month".localized()//"$89.99"
                                    case PACKAGES.RUBY_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[6].packagePrice + "/" + "month".localized()//"$104.99"
                                    case PACKAGES.EMERALD_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[7].packagePrice + "/" + "month".localized()//"$119.99"
                                    case PACKAGES.PEARL_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[8].packagePrice + "/" + "month".localized()//"$134.99"
                                    case PACKAGES.OPAL_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[9].packagePrice + "/" + "month".localized()//"$149.99"
                                    case PACKAGES.PREMIUM_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[10].packagePrice + "/" + "month".localized()//"$164.99"
                                    case PACKAGES.DELUX_MONTHLY:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[11].packagePrice + "/" + "month".localized()//"$249.99"
                                    default:
                                        self.lblPackagePrice.text = self.arrPackagesMonthly[12].packagePrice + "/" + "month".localized()//"$399.99"
                                    }
                                }
                                
                                self.lblUsersPerMonth.text = bossSubscribedObject.no_of_users.string! + " " + "users".localized()
                                self.lblValidity.text = "Expires on".localized() + " " + bossSubscribedObject.subscription_enddate
                                self.sldUsers.value = Float(bossSubscribedObject.no_of_users)
                                self.lblSliderValue.text = "\(Int(self.sldUsers.value))"
                                self.currentSelectedPackage = bossSubscribedObject.objGetPlan.ios_plan_id
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.lblSliderValue.center = self.setUISliderThumbValueWithLabel(slider: self.sldUsers)
                                }
                                if let data = try? JSONEncoder().encode(bossSubscribedObject) {
                                    defaults.set(data, forKey: SUBSCRIBED_PACKAGE)
                                    defaults.synchronize()
                                }
                            } else {
                                //TO SET WHEN TRIAL PERIOD
                                if let active_employee = payload["active_employee"] as? Int {
                                    self.active_employee = active_employee
                                }
                                self.setTrialPeriod()
                                self.setSubscribeButton()
                                defaults.set(false, forKey: IS_SUBSCRIBED_USER)
                                defaults.removeObject(forKey: SUBSCRIBED_PACKAGE)
                                defaults.synchronize()
                            }
                            self.vwMainBg.isHidden = false
                        }
                    } else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 {
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
                    } else if response["code"] as! Int == 423 {
                        //TO SET WHEN SUBSCRIPTION EXPIRED
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let active_employee = payload["active_employee"] as? Int {
                                self.active_employee = active_employee
                            }
                        }
                        //Subscription is expired
                        self.setTrialPeriod()
                        self.setSubscribeButton()
                        defaults.set(false, forKey: IS_SUBSCRIBED_USER)
                        defaults.removeObject(forKey: SUBSCRIBED_PACKAGE)
                        defaults.synchronize()
                        self.vwMainBg.isHidden = false
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
    
    //USER SUBSCRIPTION API
    func callUserSubscription(ReceiptData receiptData: String, productId: String) {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["device_type"] = DEVICE_TYPE
        params["product_id"] = productId
        params["receipt_data"] = receiptData
        params["purchase_type"] = "monthly"
        params["package_name"] = productId
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_SUBSCRIPTION_CREATE, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) -> Void in
            
            AppFunctions.hideProgress()
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        self.lblSliderValue.isHidden = false
                        self.btnCancel.superview?.isHidden = false
                        self.btnSubscribe.isHidden = false
                        
                        defaults.set(true, forKey: IS_SUBSCRIBED_USER)
                        defaults.synchronize()
                        
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: "Subscription done successfully".localized())
                        
                        self.delegate?.productPurchased(productPurchased: productId)
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            if let subscription = payload["subscription"] as? Dictionary<String, Any> {
                                //Set Subscription Details here
                                let bossSubscribedObject = BossSubscribedObject(subscription)
                                //self.delegate?.productPurchased(productPurchased: productId)
                                if let data = try? JSONEncoder().encode(bossSubscribedObject) {
                                    defaults.set(data, forKey: SUBSCRIBED_PACKAGE)
                                    defaults.synchronize()
                                    //Set current subscription - and if current subscription is not available than it should show "You have not subscribed any plan/package"
                                    self.lblPackagePrice.text = bossSubscribedObject.price + "/" + "month".localized()
                                    
                                    if self.arrPackagesMonthly.count > 0 {
                                        switch bossSubscribedObject.objGetPlan.ios_plan_id {
                                        case PACKAGES.EXTRASMALL_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[0].packagePrice + "/" + "month".localized()//"$14.99"
                                        case PACKAGES.SMALL_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[1].packagePrice + "/" + "month".localized()//"$29.99"
                                        case PACKAGES.MEDIUM_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[2].packagePrice + "/" + "month".localized()//"$44.99"
                                        case PACKAGES.LARGE_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[3].packagePrice + "/" + "month".localized()//"$59.99"
                                        case PACKAGES.EXTRALARGE_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[4].packagePrice + "/" + "month".localized()//"$74.99"
                                        case PACKAGES.SAPPHIRE_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[5].packagePrice + "/" + "month".localized()//"$89.99"
                                        case PACKAGES.RUBY_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[6].packagePrice + "/" + "month".localized()//"$104.99"
                                        case PACKAGES.EMERALD_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[7].packagePrice + "/" + "month".localized()//"$119.99"
                                        case PACKAGES.PEARL_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[8].packagePrice + "/" + "month".localized()//"$134.99"
                                        case PACKAGES.OPAL_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[9].packagePrice + "/" + "month".localized()//"$149.99"
                                        case PACKAGES.PREMIUM_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[10].packagePrice + "/" + "month".localized()//"$164.99"
                                        case PACKAGES.DELUX_MONTHLY:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[11].packagePrice + "/" + "month".localized()//"$249.99"
                                        default:
                                            self.lblPackagePrice.text = self.arrPackagesMonthly[12].packagePrice + "/" + "month".localized()//"$399.99"
                                        }
                                    }
                                    
                                    self.lblUsersPerMonth.text = bossSubscribedObject.no_of_users.string! + " " + "users".localized()
                                    self.lblValidity.text = "Expires on".localized() + " " + bossSubscribedObject.subscription_enddate
                                    self.sldUsers.value = Float(bossSubscribedObject.no_of_users)
                                    self.lblSliderValue.text = "\(Int(self.sldUsers.value))"
                                    self.currentSelectedPackage = bossSubscribedObject.objGetPlan.ios_plan_id
                                    self.setSubscribeButton()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.lblSliderValue.center = self.setUISliderThumbValueWithLabel(slider: self.sldUsers)
                                    }
                                }
                            }
                        }
                    }
                    else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 {
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
