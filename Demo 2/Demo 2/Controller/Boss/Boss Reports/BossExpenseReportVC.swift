//
//  BossExpenseReportVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts

class BossExpenseReportVC: BaseVC {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var chartView: PieChartView!
    
    @IBOutlet weak var tblVW: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var collectionVW: SelfSizedCollectionView!
    
    private var OFFSET: Int = 0
    private var PAGING_LIMIT: Int = 30
    private var requestState: REQUEST = .notStarted
    
    var strStartDate: String = ""
    var strEndDate: String = ""
    var strEmployeeUserIDs: String = ""
    var arrFilteredData:[String] = []
    var arrEmployeeList: [EmployeeListObject] = []
    var arrSelectedEmployee: [EmployeeListObject] = []
    
    var arrCategoryList: [BossReportExpenseGraphCategory] = []
    var arrSelectedCategory: [BossReportExpenseGraphCategory] = []
    
    var arrExpenseReports: [ExpenseReportListObject] = []
    
    var total_expense: String = ""
    
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
    
    var colors: [NSUIColor] = []
    
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
    private func nextPageForExpenseReportListIfNeeded(at section: Int) {
        if self.arrExpenseReports.count >= 30 {
            if section == (self.arrExpenseReports.count - 1) {
                if requestState != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.arrExpenseReports.count
                    self.PAGING_LIMIT = 30
                    self.getReportExpenseAPI()
                }
            }
        }
    }
}

// MARK:- UITABLEVIEW DATASOURCE & DELEGATE METHOD -

extension BossExpenseReportVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrExpenseReports.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objExpense = self.arrExpenseReports[section]
        return objExpense.arrExpenseCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseReportCategoryCell", for: indexPath) as! ExpenseReportCategoryCell
        
        let objExpenseReport = self.arrExpenseReports[indexPath.section]
        let objCategory = objExpenseReport.arrExpenseCategory[indexPath.row]
        
        cell.lblName.text = objCategory.cat_name
        cell.lblAmount.text = appDelegate.objLoggedInUser.objCompanyInfo.currency +  objCategory.total
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = Colors.viewBGColor
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let objExpense = self.arrExpenseReports[section]
        
        let header = self.tblVW.dequeueReusableHeaderFooterView(withIdentifier: "ExpenseReportUserHeaderView") as! ExpenseReportUserHeaderView
        
        header.lblEmployeeName.text = objExpense.employee_name
        header.lblAmount.text = appDelegate.objLoggedInUser.objCompanyInfo.currency + objExpense.totalSum
        
        if section == 0 {
            header.lblSeperator.isHidden = true
        } else {
            header.lblSeperator.isHidden = false
        }
        self.nextPageForExpenseReportListIfNeeded(at: section)
        return header
    }
}

// MARK:- UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD -
extension BossExpenseReportVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BossExpenseReportCollectionCell", for: indexPath as IndexPath) as! BossExpenseReportCollectionCell
        
        let objCategory = self.arrCategoryList[indexPath.item]
        cell.vwColor.backgroundColor = self.colors[indexPath.item]
        
        cell.lblTitle.text = objCategory.cat_name
        cell.lblAmount.text = appDelegate.objLoggedInUser.objCompanyInfo.currency + objCategory.total
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let objExpenseCategory = self.arrCategoryList[indexPath.row]
        
        var finalWidth: CGFloat = 0.0
        
        var categoryWidth: CGFloat = 0.0
        var amountWidth: CGFloat = 0.0
        
        
        finalWidth = categoryWidth + amountWidth
        
        return CGSize(width: finalWidth + 32, height: 40)
    }
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
    }

}

//MARK:- Summary Filter Delegate
extension BossExpenseReportVC: bossReportFilterDelegate {
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
        self.getReportExpenseAPI()
    }
}

// MARK:- REPORT PAYROLL API -
extension BossExpenseReportVC {
    func getReportExpenseAPI() {
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
        
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_REPORT_EXPENSES, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let payloadData = response["payload"]  as? Dictionary<String, Any> {
                            
                            if let fTE = payloadData["total_expense"] as? Double {
                                self.total_expense = String(format: "%.2f", fTE)
                            }
                            
                            if self.OFFSET == 0 {
                                self.arrExpenseReports.removeAll()
                                self.arrEmployeeList.removeAll()
                                self.arrCategoryList.removeAll()
                                
                                //EMPLOYEE LIST
                                if let arrEmp = payloadData["employee-list"] as? [Dictionary<String, Any>] {
                                    for i in 0..<arrEmp.count  {
                                        let objEmployee = EmployeeListObject.init(arrEmp[i])
                                        self.arrEmployeeList.append(objEmployee)
                                    }
                                }
                                
                                //CATEGORY LIST
                                if let arrCat = payloadData["total_expense_category"] as? [Dictionary<String, Any>] {
                                    for i in 0..<arrCat.count  {
                                        let objCategory = BossReportExpenseGraphCategory.init(arrCat[i])
                                        self.arrCategoryList.append(objCategory)
                                    }
                                }
                            }
                            
                            //EXPENSE REPORT LIST
                            if let arrExp = payloadData["expenses"] as? [Dictionary<String, Any>] {
                                for i in 0..<arrExp.count  {
                                    let objExpenseReport = ExpenseReportListObject.init(arrExp[i])
                                    self.arrExpenseReports.append(objExpenseReport)
                                }
                                
                                if self.PAGING_LIMIT >= 30 {
                                    if arrExp.count < self.PAGING_LIMIT {
                                        self.requestState = REQUEST.failedORNoMoreData
                                    }
                                }
                                
                                /*
                                if self.arrExpenseReports.count > 0 {
                                    self.lblNoRecord.isHidden = true
                                } else {
                                    self.lblNoRecord.isHidden = false
                                }
                                */
                                
                                self.tblVW.isHidden = false
                                self.tblVW.reloadData()
                                self.vwContent.isHidden = false
                                self.setPieChartData(self.arrCategoryList.count, range: 20)
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

//MARK:- Setup PieChart
extension BossExpenseReportVC {
    func setupChart() {
        self.chartView.usePercentValuesEnabled = true
        self.chartView.drawSlicesUnderHoleEnabled = false
        self.chartView.holeRadiusPercent = 0.75
        self.chartView.transparentCircleRadiusPercent = 0.2
        self.chartView.chartDescription.enabled = false
        self.chartView.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 5)
        
        self.chartView.drawCenterTextEnabled = true
        
        self.chartView.drawHoleEnabled = true
        self.chartView.rotationAngle = 0
        self.chartView.rotationEnabled = false
        self.chartView.highlightPerTapEnabled = false
        self.chartView.legend.enabled = false
        self.chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
    }
    
    func setPieChartData(_ count: Int, range: UInt32) {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        var centerText: NSMutableAttributedString!
        
        if count > 0 {
            centerText = NSMutableAttributedString(string: "\(appDelegate.objLoggedInUser.objCompanyInfo.currency + self.total_expense)\n\(self.arrCategoryList.count) category")
            
            centerText.setAttributes([NSAttributedString.Key.font: UIFont.init(name: Fonts.NunitoBold, size: 12.0)!, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, centerText.length))
            
            let number = self.arrCategoryList.count
            let array = Array(sequence(state: number, next: { return $0 > 0 ? ($0 % 10, $0 = $0/10).0 : nil }
            ).reversed())
            
            centerText.addAttributes([NSAttributedString.Key.font: UIFont.init(name: Fonts.NunitoBold, size: 11.0)!, NSAttributedString.Key.foregroundColor: Colors.labelColor], range: NSMakeRange(centerText.length - (9 + array.count), (9 + array.count)))
        }
        else {
            centerText = NSMutableAttributedString(string: "No data available".localized())
            centerText.setAttributes([NSAttributedString.Key.font: UIFont.init(name: Fonts.NunitoMedium, size: 13.0)!, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, centerText.length))
        }
        
        self.chartView.centerAttributedText = centerText
        
        let entries = (0..<self.arrCategoryList.count).map { (i) -> PieChartDataEntry in
            let objCategory = self.arrCategoryList[i]
            let title = objCategory.cat_name
            let value = (objCategory.total as NSString).doubleValue
            let fullvalue = title + " " + "$\(value)"
            
            return PieChartDataEntry(value: value, label: fullvalue, icon: nil)
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        self.colors.removeAll()
        for _ in 0..<entries.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        self.collectionVW.reloadData()
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(UIFont(name: Fonts.NunitoRegular, size: 12)!)
        data.setValueTextColor(.white)
        
        data.setDrawValues(false)
        chartView.drawEntryLabelsEnabled = false
        
        self.chartView.data = data
        self.chartView.highlightValues(nil)
    }
}
