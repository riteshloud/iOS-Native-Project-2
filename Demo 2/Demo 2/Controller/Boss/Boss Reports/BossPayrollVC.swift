//
//  BossPayrollVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 10/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyJSON

class BossPayrollVC: BaseVC {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tblPayroll: UITableView!
    @IBOutlet weak var lblNoRecordFound: UILabel!
    
    private var OFFSET: Int = 0
    private var PAGING_LIMIT: Int = 30
    private var requestState: REQUEST = .notStarted
    
    var strStartDate: String = ""
    var strEndDate: String = ""
    var strEmployeeUserIDs: String = ""
    var arrFilteredData:[String] = []
    var arrEmployeeList: [EmployeeListObject] = []
    var arrSelectedEmployee: [EmployeeListObject] = []
    
    var arrPayroll: [PayrollReportListObject] = []
    
    private lazy var btnFilter: MessageBadgeButton = {
        let btnFilter = MessageBadgeButton()
        btnFilter.translatesAutoresizingMaskIntoConstraints = false
        btnFilter.setImage(#imageLiteral(resourceName: "ic_nav_filter"))
        btnFilter.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btnFilter.widthAnchor.constraint(equalToConstant: 44).isActive = true
        btnFilter.addTarget(self, action: #selector(self.filterAction), for: .touchUpInside)
        //        btnFilter.updateBadge(0)
        btnFilter.changeBackgroundColor(.clear)
        return btnFilter
    }()
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    // MARK:- ACTIONS -
    
    @objc func menuAction() {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @objc func filterAction() {
        
        let vc = AppFunctions.bossReportStoryBoard().instantiateViewController(withIdentifier: "BossPayrollFilterVC") as! BossPayrollFilterVC
        vc.arrEmployeeList = self.arrEmployeeList
        vc.arrSelectedEmployee = self.arrSelectedEmployee
        vc.arrFilteredData = self.arrFilteredData
        vc.strStartDate = self.strStartDate
        vc.strEndDate = self.strEndDate
        
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Pagination Call
    private func nextPageForExpenseListIfNeeded(at section: Int) {
        if self.arrPayroll.count >= 30 {
            if section == (self.arrPayroll.count - 1) {
                if requestState != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.arrPayroll.count
                    self.PAGING_LIMIT = 30
                    self.getReportPayrollAPI()
                }
            }
        }
    }
}

//MARK:- Summary Filter Delegate
extension BossPayrollVC: bossReportFilterDelegate {
    func getSelectedReportFilter(_ startDate: String, _ endDate: String, _ arrSelectedEmployee: [EmployeeListObject]) {
        
        self.strStartDate = startDate
        self.strEndDate = endDate
        
        self.arrFilteredData.removeAll()
        self.arrSelectedEmployee = arrSelectedEmployee
        if !self.strStartDate.isEmpty && !self.strEndDate.isEmpty {
            self.arrFilteredData.append(self.strStartDate + " - " + self.strEndDate)
            
            self.lblTitle.text = "Report for ".localized() + AppFunctions.sharedInstance.formattedDateFromString(dateString: self.strStartDate, InputFormat: globalDateFormat, OutputFormat: "dd MMM, YYYY")! + " - " + AppFunctions.sharedInstance.formattedDateFromString(dateString: self.strEndDate, InputFormat: globalDateFormat, OutputFormat: "dd MMM, YYYY")!
        }
        else {
            self.lblTitle.text = "Report for current month ".localized() + AppFunctions.sharedInstance.formattedDateFromString(dateString: Date().getDateOnly(), InputFormat: globalDateFormat, OutputFormat: "MMMM, YYYY")!
        }
        
        //EMPLOYEE
        let arrEmployeeIds = arrSelectedEmployee.map({ (employee: EmployeeListObject) -> Int in
            employee.id
        })
        
        if arrEmployeeIds.count <= 0 {
        } else if arrEmployeeIds.count == 1 {
            self.arrFilteredData.append("\(arrEmployeeIds.count)" + " " + "Employee".localized())
        } else {
            self.arrFilteredData.append("\(arrEmployeeIds.count)" + " " + "Employees".localized())
        }
        
        self.strEmployeeUserIDs = (arrEmployeeIds.map{String($0)}).joined(separator: ",")
        
        if self.arrFilteredData.count > 0 {
            self.btnFilter.updateBadge(self.arrFilteredData.count)
            self.btnFilter.changeBackgroundColor(Colors.badgeBGColor)
            self.btnFilter.changeBadgeTextColor(.white)
        }
        else {
            self.btnFilter.updateBadge(0)
            self.btnFilter.changeBadgeTextColor(.clear)
            self.btnFilter.changeBackgroundColor(.clear)
        }
        
        self.OFFSET = 0
        self.PAGING_LIMIT = 30
        self.getReportPayrollAPI()
    }
}

// MARK:- UITABLEVIEW DATASOURCE & DELEGATE METHOD -

extension BossPayrollVC: UITableViewDataSource, UITableViewDelegate {
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = Colors.viewBGColor
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let objExpense = self.arrPayroll[section]
        
        let header = self.tblPayroll.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! CustomSectionHeader
        
        header.lblDate.text = AppFunctions.sharedInstance.formattedDateFromString(dateString: objExpense.date, InputFormat: API_RESPONSE_DATE_FORMAT, OutputFormat: headerDateFormat)
        header.lblDifference.isHidden = true
        
        self.nextPageForExpenseListIfNeeded(at: section)
        return header
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return self.arrPayroll.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        let objDatePayroll = self.arrPayroll[section]
        let arrRows = objDatePayroll.arrPayrollList
        return arrRows.count
        */
        return self.arrPayroll.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BossPayrollCell", for: indexPath) as! BossPayrollCell
        /*
        let objDatePayroll = self.arrPayroll[indexPath.section]
        let objPayroll = objDatePayroll.arrPayrollList[indexPath.row]
        */
        
        let objPayroll = self.arrPayroll[indexPath.row]
        cell.lblEmployeeName.text = objPayroll.objEmployee.name
        cell.lblEmployeeAmount.text = objPayroll.currency + "\(objPayroll.payable_amount)" 
        
        cell.lblStraightValue.text = objPayroll.straight + "h".localized()
        cell.lblRegularValue.text = objPayroll.regular_hours + "h".localized()
        cell.lblLeaveValue.text = objPayroll.vacation_sick + "h".localized()
        cell.lblTotalPaidHoursValue.text = objPayroll.total_paid_hours + "h".localized()
        cell.lblOvertimeValue.text = objPayroll.overtime + "h".localized()
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK:- REPORT PAYROLL API -

extension BossPayrollVC {
    func getReportPayrollAPI() {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params["startdate"] = AppFunctions.sharedInstance.formattedDateFromString(dateString: self.strStartDate, InputFormat: globalDateFormat, OutputFormat: API_REQUEST_DATE_FORMAT)
        params["enddate"] = AppFunctions.sharedInstance.formattedDateFromString(dateString: self.strEndDate, InputFormat: globalDateFormat, OutputFormat: API_REQUEST_DATE_FORMAT)
        params["employee_user_id"] = self.strEmployeeUserIDs
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_REPORT_PAYROLL, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payloadData = response["payload"]  as? Dictionary<String, Any> {
                            
                            if self.OFFSET == 0 {
                                self.arrPayroll.removeAll()
                                self.arrEmployeeList.removeAll()
                                //                                self.arrCategories.removeAll()
                                
                                //EMPLOYEE LIST
                                if let arrEmp = payloadData["employee_list"] as? [Dictionary<String, Any>] {
                                    for i in 0..<arrEmp.count  {
                                        let objEmployee = EmployeeListObject.init(arrEmp[i])
                                        self.arrEmployeeList.append(objEmployee)
                                    }
                                }
                                
                                /*
                                 //CATEGORY LIST
                                 if let arrCat = payloadData["category-list"] as? [Dictionary<String, Any>] {
                                 for i in 0..<arrCat.count  {
                                 let objCategory = CategoryListObject.init(arrCat[i])
                                 self.arrCategories.append(objCategory)
                                 }
                                 }
                                 */
                            }
                            
                            //PAYROLL LIST
                            if let arrPay = payloadData["payroll_data"] as? [Dictionary<String, Any>] {
                                for i in 0..<arrPay.count  {
                                    let objDatePayroll = PayrollReportListObject.init(arrPay[i])
                                    self.arrPayroll.append(objDatePayroll)
                                }
                                
                                if self.PAGING_LIMIT >= 30 {
                                    if arrPay.count < self.PAGING_LIMIT {
                                        self.requestState = REQUEST.failedORNoMoreData
                                    }
                                }
                                
                                if self.arrPayroll.count > 0 {
                                    self.lblNoRecordFound.isHidden = true
                                } else {
                                    self.lblNoRecordFound.isHidden = false
                                }
                                
                                self.tblPayroll.isHidden = false
                                self.tblPayroll.reloadData()
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
