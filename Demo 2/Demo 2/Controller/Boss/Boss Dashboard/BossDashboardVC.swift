//
//  BossDashboardVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import DropDown
import SideMenuSwift
import SwiftyJSON
import Charts

class BossDashboardVC: BaseVC {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblTopPerformer: UILabel!
    
    //TOP EMPLOYEE OPTIONS
    @IBOutlet weak var vwTopOptions: UIView!
    @IBOutlet weak var btnWeeklyPerformer: UIButton!
    @IBOutlet weak var btnMonthlyPerformer: UIButton!
    @IBOutlet weak var btnAllTimePerformer: UIButton!
    
    private var selectedPerformerType: PerformerType = PerformerType.weekly
    
    //CHART
    @IBOutlet weak var chartScrollVW: UIScrollView!
    @IBOutlet weak var lblNoChartDataFound: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var constraintWidthOfBarChartView: NSLayoutConstraint!
    
    //SUMMARY
    @IBOutlet weak var viewSummary: UIView!
    @IBOutlet weak var lblSummaryTitle: UILabel!
    @IBOutlet weak var lblPunchedInEmployee: UILabel!
    
    //ESTIMATED PAYROLL
    @IBOutlet weak var viewPayroll: UIView!
    @IBOutlet weak var lblPayrollTitle: UILabel!
    
    //PAYROLL OPTIONS
    @IBOutlet weak var vwPayrollOptions: UIView!
    @IBOutlet weak var btnDailyPayroll: UIButton!
    @IBOutlet weak var btnWeeklyPayroll: UIButton!
    @IBOutlet weak var btnMonthlyPayroll: UIButton!
    
    private var selectedPayrollType: PayrollType = PayrollType.daily
    
    //PAYROLL DATA
    @IBOutlet weak var lblWorkingHoursTitle: UILabel!
    @IBOutlet weak var lblWorkingHours: UILabel!
    @IBOutlet weak var lblOvertimeHoursTitle: UILabel!
    @IBOutlet weak var lblOvertimeHours: UILabel!
    @IBOutlet weak var lblEstimatedPayrollTitle: UILabel!
    @IBOutlet weak var lblEstimatedPayroll: UILabel!
    
    //TRIAL
    @IBOutlet weak var vwTrial: UIView!
    @IBOutlet weak var constraintBottomOfTrialView: NSLayoutConstraint!
    @IBOutlet weak var lblTrialPeriodTitle: UILabel!
    @IBOutlet weak var lblTrialPeriodDesc: UILabel!
    
    var objBossDashboard = BossDashboardObject.init([:])
    var arrPunchInEmployeeList: [PunchInEmployeeObject] = []
    
    var arrxAxisData: [String] = []
    var arryAxisData: [Double] = []
    
    var isWebServiceCalled: Bool = false
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isWebServiceCalled {
            self.callBossDashboardAPI()
        }
    }
    
    // MARK:- HELPER -
    
    func selectWeeklyPerfomner() {
        self.deSelectMonthlyPerformer()
        self.deSelectAllTimePerformer()
        
        self.btnWeeklyPerformer.backgroundColor = .white
        self.btnWeeklyPerformer.setTitleColor(Colors.BossDashboardOptionSelectedColor, for: [])
        
        if self.objBossDashboard.arrWeeklyPerformer.count <= 0 {
            self.chartScrollVW.isHidden = true
            self.lblNoChartDataFound.isHidden = false
        } else {
            self.chartScrollVW.isHidden = false
            self.lblNoChartDataFound.isHidden = true
            
            self.arrxAxisData.removeAll()
            self.arryAxisData.removeAll()
            
            for i in 0..<self.objBossDashboard.arrWeeklyPerformer.count {
                let objWeeklyPerformer = self.objBossDashboard.arrWeeklyPerformer[i]
                
                let empName = objWeeklyPerformer.name.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil)
                self.arrxAxisData.append(empName)
                self.arryAxisData.append(objWeeklyPerformer.total_hours)
            }
            
            self.setBarChartData(self.arrxAxisData, values: self.arryAxisData)
        }
    }
    
    func deSelectWeeklyPerformer() {
        self.btnWeeklyPerformer.backgroundColor = .clear
        self.btnWeeklyPerformer.setTitleColor(Colors.labelColor, for: [])
    }
    
    func selectMonthlyPerformer() {
        self.deSelectWeeklyPerformer()
        self.deSelectAllTimePerformer()
        
        self.btnMonthlyPerformer.backgroundColor = .white
        self.btnMonthlyPerformer.setTitleColor(Colors.BossDashboardOptionSelectedColor, for: [])
        
        if self.objBossDashboard.arrMonthlyPerformer.count <= 0 {
            self.chartScrollVW.isHidden = true
            self.lblNoChartDataFound.isHidden = false
        } else {
            self.chartScrollVW.isHidden = false
            self.lblNoChartDataFound.isHidden = true
            
            self.arrxAxisData.removeAll()
            self.arryAxisData.removeAll()
            
            for i in 0..<self.objBossDashboard.arrMonthlyPerformer.count {
                let objMonthlyPerformer = self.objBossDashboard.arrMonthlyPerformer[i]
                
                let empName = objMonthlyPerformer.name.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil)
                self.arrxAxisData.append(empName)
                self.arryAxisData.append(objMonthlyPerformer.total_hours)
            }
            
            self.setBarChartData(self.arrxAxisData, values: self.arryAxisData)
        }
    }
    
    func deSelectMonthlyPerformer() {
        self.btnMonthlyPerformer.backgroundColor = .clear
        self.btnMonthlyPerformer.setTitleColor(Colors.labelColor, for: [])
    }
    
    func selectAllTimePerformer() {
        self.deSelectWeeklyPerformer()
        self.deSelectMonthlyPerformer()
        
        self.btnAllTimePerformer.backgroundColor = .white
        self.btnAllTimePerformer.setTitleColor(Colors.BossDashboardOptionSelectedColor, for: [])
        
        if self.objBossDashboard.arrAllTimePerformer.count <= 0 {
            self.chartScrollVW.isHidden = true
            self.lblNoChartDataFound.isHidden = false
        } else {
            self.chartScrollVW.isHidden = false
            self.lblNoChartDataFound.isHidden = true
            
            self.arrxAxisData.removeAll()
            self.arryAxisData.removeAll()
            
            for i in 0..<self.objBossDashboard.arrAllTimePerformer.count {
                let objAllTimePerformer = self.objBossDashboard.arrAllTimePerformer[i]
                
                let empName = objAllTimePerformer.name.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil)
                self.arrxAxisData.append(empName)
                self.arryAxisData.append(objAllTimePerformer.total_hours)
            }
            
            self.setBarChartData(self.arrxAxisData, values: self.arryAxisData)
        }
    }
    
    func deSelectAllTimePerformer() {
        self.btnAllTimePerformer.backgroundColor = .clear
        self.btnAllTimePerformer.setTitleColor(Colors.labelColor, for: [])
    }
    
    //PAYROLL
    func selectDailyPayroll() {
        self.deSelectWeeklyPayroll()
        self.deSelectMonthlyPayroll()
        
        self.btnDailyPayroll.backgroundColor = .white
        self.btnDailyPayroll.setTitleColor(Colors.BossDashboardOptionSelectedColor, for: [])
        
        self.lblWorkingHours.text = self.objBossDashboard.strDailyWH
        self.lblOvertimeHours.text = self.objBossDashboard.strDailyOH
        self.lblEstimatedPayroll.text = self.objBossDashboard.objCompanySetting.currency + self.objBossDashboard.strDailyPH
    }
    
    func deSelectDailyPayroll() {
        self.btnDailyPayroll.backgroundColor = .clear
        self.btnDailyPayroll.setTitleColor(Colors.labelColor, for: [])
    }
    
    func selectWeeklyPayroll() {
        self.deSelectDailyPayroll()
        self.deSelectMonthlyPayroll()
        
        self.btnWeeklyPayroll.backgroundColor = .white
        self.btnWeeklyPayroll.setTitleColor(Colors.BossDashboardOptionSelectedColor, for: [])
        
        self.lblWorkingHours.text = self.objBossDashboard.strWeeklyWH
        self.lblOvertimeHours.text = self.objBossDashboard.strWeeklyOH
        self.lblEstimatedPayroll.text = self.objBossDashboard.objCompanySetting.currency + self.objBossDashboard.strWeeklyPH
    }
    
    func deSelectWeeklyPayroll() {
        self.btnWeeklyPayroll.backgroundColor = .clear
        self.btnWeeklyPayroll.setTitleColor(Colors.labelColor, for: [])
    }
    
    func selectMonthlyPayroll() {
        self.deSelectDailyPayroll()
        self.deSelectWeeklyPayroll()
        
        self.btnMonthlyPayroll.backgroundColor = .white
        self.btnMonthlyPayroll.setTitleColor(Colors.BossDashboardOptionSelectedColor, for: [])
        
        self.lblWorkingHours.text = self.objBossDashboard.strMonthlyWH
        self.lblOvertimeHours.text = self.objBossDashboard.strMonthlyOH
        self.lblEstimatedPayroll.text = self.objBossDashboard.objCompanySetting.currency + self.objBossDashboard.strMonthlyPH
    }
    
    func deSelectMonthlyPayroll() {
        self.btnMonthlyPayroll.backgroundColor = .clear
        self.btnMonthlyPayroll.setTitleColor(Colors.labelColor, for: [])
    }
    
    // MARK:- ACTIONS -
    
    @objc func menuAction() {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnTrialPeriodTapped(_ sender: UIButton) {
        let vc = AppFunctions.bossSubscriptionsStoryBoard().instantiateViewController(withIdentifier: "BossSubscriptionsVC") as! BossSubscriptionsVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPerformerOptionsTapped(_ sender: UIButton) {
        if sender.accessibilityIdentifier == "WEEKLY" {
            self.selectedPerformerType = .weekly
            self.selectWeeklyPerfomner()
        } else if sender.accessibilityIdentifier == "MONTHLY" {
            self.selectedPerformerType = .monthly
            self.selectMonthlyPerformer()
        } else if sender.accessibilityIdentifier == "ALL TIME" {
            self.selectedPerformerType = .alltime
            self.selectAllTimePerformer()
        }
    }
    
    @IBAction func btnPayrollOptionsTapped(_ sender: UIButton) {
        if sender.accessibilityIdentifier == "DAILY" {
            self.selectedPayrollType = .daily
            self.selectDailyPayroll()
        } else if sender.accessibilityIdentifier == "WEEKLY" {
            self.selectedPayrollType = .weekly
            self.selectWeeklyPayroll()
        } else if sender.accessibilityIdentifier == "MONTHLY" {
            self.selectedPayrollType = .monthly
            self.selectMonthlyPayroll()
        }
        
//        self.callBossDashboardAPI()
    }
}

// MARK:- API CALL

extension BossDashboardVC {
    func callBossDashboardAPI() {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        /*
        var strType = ""
        
        if self.selectedPayrollType == .daily {
            strType = "day"
        } else if self.selectedPayrollType == .weekly {
            strType = "week"
        } else if self.selectedPayrollType == .monthly {
            strType = "month"
        }
        */
        
        self.isWebServiceCalled = true
        
        let params: [String:Any] = [:]
        //params["type"] = strType
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_DASHBOARD, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            self.isWebServiceCalled = false
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payload = response["payload"] as? Dictionary<String, Any> {
                            self.objBossDashboard = BossDashboardObject.init(payload)
                            
                            //UPDATE GLOBAL DATE FORMAT AND TIME FORMAT
                            AppFunctions.sharedInstance.setGlobalDateFormat(strFormat: self.objBossDashboard.objCompanySetting.date_format)
                            AppFunctions.sharedInstance.setGlobalTimeFormat(strFormat: self.objBossDashboard.objCompanySetting.time_format)
                            AppFunctions.sharedInstance.setGlobalTimeZone(strTimezone: self.objBossDashboard.objCompanySetting.time_zone)
                            
                            let trialPeriod = self.objBossDashboard.trial_period
                            let subscription = self.objBossDashboard.subscription
                            
                            if trialPeriod == "1" {
                                self.setupData()
                                self.viewContainer.isHidden = false
                                
                                //Show trial view
                                self.vwTrial.isHidden = false
                                self.constraintBottomOfTrialView.constant = 15
                                
                                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                            } else {
                                if subscription == "1" {
                                    self.setupData()
                                    self.viewContainer.isHidden = false
                                    
                                    //Hide trial view
                                    self.vwTrial.isHidden = true
                                    self.constraintBottomOfTrialView.constant = 0
                                    
                                    //Set Subscription Details here
                                    if let plan_details = payload["plan_details"] as? Dictionary<String, Any> {
                                        let bossSubscribedObject = BossSubscribedObject(plan_details)
                                        if let data = try? JSONEncoder().encode(bossSubscribedObject) {
                                            defaults.set(data, forKey: SUBSCRIBED_PACKAGE)
                                            defaults.synchronize()
                                        }
                                    }
                                    
                                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                                } else {
                                    //Hide trial view
                                    self.vwTrial.isHidden = true
                                    self.constraintBottomOfTrialView.constant = 0
                                    
                                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                                    let controller = AppFunctions.bossFreeTrialExpiredStoryBoard().instantiateViewController(withIdentifier: "BossFreeTrialExpiredVC") as! BossFreeTrialExpiredVC
                                    controller.modalPresentationStyle = .overCurrentContext
                                    controller.navigationControllerLocal = self.navigationController
                                    self.present(controller, animated: true, completion: nil)
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
    
    //MARK:- SETUP DATA
    
    func setupData() {
        let punchinEmployeeList = self.objBossDashboard.arrPunchInEmployee
        self.arrPunchInEmployeeList.removeAll()
        self.arrPunchInEmployeeList.append(contentsOf: punchinEmployeeList)
            
        if self.selectedPerformerType == .weekly {
            self.selectWeeklyPerfomner()
        }
        else if self.selectedPerformerType == .monthly {
            self.selectMonthlyPerformer()
        }
        else if self.selectedPerformerType == .alltime {
            self.selectAllTimePerformer()
        }
        
        self.selectDailyPayroll()
        
        self.lblTrialPeriodTitle.text = "Trial Period".localized()
        self.lblTrialPeriodDesc.text = "\(self.objBossDashboard.expire_day) " + "days left for your trial period".localized()
    }
}

//MARK:- SET BAR CHART DATA
extension BossDashboardVC {
    func setBarChartData(_ dataPoints: [String], values: [Double]) {
        /*
        if CGFloat(((self.arrxAxisData.count) * 60) + 60) > self.chartScrollVW.frame.size.width {
            self.constraintWidthOfBarChartView.constant = CGFloat(((self.arrxAxisData.count) * 60) + 60)
        }
        else {
            self.constraintWidthOfBarChartView.constant = self.chartScrollVW.frame.size.width
        }
        */
        
        self.constraintWidthOfBarChartView.constant = CGFloat(((self.arrxAxisData.count) * 60) + 60)
        
        self.barChartView.chartDescription.text = ""
        DispatchQueue.main.async() {
            self.barChartView.animate(yAxisDuration: 1.5)
        }
        
        self.barChartView.drawGridBackgroundEnabled = false
        self.barChartView.setScaleEnabled(true)
        self.barChartView.pinchZoomEnabled = false
        self.barChartView.scaleXEnabled = false
        self.barChartView.scaleYEnabled = false
        self.barChartView.rightAxis.enabled = false
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.drawGridLinesEnabled = true
        self.barChartView.leftAxis.gridColor = Colors.gridLineColor
        self.barChartView.xAxis.labelCount = dataPoints.count
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        self.barChartView.dragYEnabled = false
        
        var barChartEntry = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            let value = BarChartDataEntry(x: Double(i), y: self.arryAxisData[i])
            barChartEntry.append(value)
        }
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = "h "
        leftAxisFormatter.positiveSuffix = "h "
        
        let leftAxis = self.barChartView.leftAxis
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        leftAxis.axisMaximum = values.max()! + 1.5 // THIS LINE IS TO ADD EXTRA 80 VALUE TO X AXIS SO THERE'S SOME TOP SPACE FROM BAR
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        let set1 = BarChartDataSet(entries: barChartEntry, label: "")
        set1.drawIconsEnabled = false
        set1.drawValuesEnabled = false
        set1.setColor(ChartColorTemplates.colorFromString("#457CEE"))
        
        set1.formLineWidth = 1
        set1.formSize = 0
        set1.valueTextColor = UIColor.red
        
        if Constants.DeviceType.IS_IPHONE_5 {
            set1.valueFont = UIFont(name: Fonts.NunitoRegular, size: 11.0)!
        } else if Constants.DeviceType.IS_IPHONE_6 {
            set1.valueFont = UIFont(name: Fonts.NunitoRegular, size: 13.0)!
        } else if Constants.DeviceType.IS_IPHONE_6P {
            set1.valueFont = UIFont(name: Fonts.NunitoRegular, size: 14.0)!
        } else if Constants.DeviceType.IS_IPHONE_X {
            set1.valueFont = UIFont(name: Fonts.NunitoRegular, size: 15.0)!
        } else if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            set1.valueFont = UIFont(name: Fonts.NunitoRegular, size: 15.0)!
        } else if Constants.DeviceType.IS_IPAD {
            set1.valueFont = UIFont(name: Fonts.NunitoRegular, size: 17.0)!
        }
        
        let data = BarChartData()
        data.barWidth = 0.5
        self.barChartView.data = data
        
        if dataPoints.count <= 0 {
            self.barChartView.isUserInteractionEnabled = false
            self.barChartView.leftAxis.labelTextColor = UIColor.clear
            self.barChartView.xAxis.labelTextColor = UIColor.clear
            self.barChartView.extraRightOffset = 0
        }
        else {
            self.barChartView.isUserInteractionEnabled = true
            self.barChartView.leftAxis.labelTextColor = Colors.ActiveArchiveNormalColor
            self.barChartView.xAxis.labelTextColor = Colors.ActiveArchiveNormalColor
            self.barChartView.extraRightOffset = 10.0
        }
        
        self.barChartView.rightAxis.enabled = false
        self.barChartView.xAxis.labelPosition = .bottom
        
        self.barChartView.setNeedsDisplay()
    }
}

//MARK:- BossSubscriptionsVC
extension BossDashboardVC: BossSubscriptionsDelegate {
    func productPurchased(productPurchased: String) {
        //Hide vwTrial
        self.vwTrial.isHidden = true
        self.constraintBottomOfTrialView.constant = 0
    }
}
