//
//  EmployeeListVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON

class EmployeeListVC: BaseVC {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    //SEARCHBAR
    @IBOutlet weak var vwSearchBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //STATUS
    @IBOutlet weak var vwEmployeeStatus: UIView!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnArchive: UIButton!
    
    @IBOutlet weak var tblEmpList: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var btnAddEmployee: UIButton!
    
    var statusDropDown = DropDown()
    
    private var selectedEmployeeType: EmployeeType = EmployeeType.active
    
    private var OFFSET: Int = 0
    private var PAGING_LIMIT: Int = 30
    private var activeEmployeeRequestState: REQUEST = .notStarted
    private var archivedEmployeeRequestState: REQUEST = .notStarted
    
    var arrActiveEmployee: [BossEmployeeListObject] = []
    var arrActiveSearchedEmployee:[BossEmployeeListObject] = []
    var arrArchivedEmployee: [BossEmployeeListObject] = []
    var arrArchivedSearchedEmployee:[BossEmployeeListObject] = []
    var objCompanyDefaultSetting: CompanyDefaultSettingObject = CompanyDefaultSettingObject.init([:])
    
    var searchActive: Bool = false
    
    var activeEmployeeOption: [String] {
        return [" Settings".localized(), " In/Out".localized()]
    }
    
    var archiveEmployeeOption: [String] {
        return [" Restore".localized(), " Delete".localized()]
    }
    
    func configWithMenuStyle() -> FTConfiguration {
        let config = FTConfiguration()
        config.backgoundTintColor = UIColor.white
        config.selectedCellBackgroundColor = Colors.optionSelectedColor
        config.borderColor = UIColor.lightGray
        config.globalShadow = true
        config.shadowAlpha = 0.05
        config.menuWidth = 120
        config.menuSeparatorColor = UIColor.clear
        config.menuRowHeight = 40
        config.cornerRadius = 2
        config.textColor = Colors.labelColor
        config.textAlignment = .left
        config.textFont = UIFont.init(name: Fonts.NunitoRegular, size: 15.0)!
        config.borderColor = UIColor.clear
        
        config.borderWidth = 0.0
        return config
    }
    
    var isFromSideMenu: Bool = false
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    @objc private func addNewlyCreatedEmployeeInList(_ notification: NSNotification) {
        if let objEmployee = notification.userInfo?["employee"] as? BossEmployeeListObject {
            self.arrActiveEmployee.insert(objEmployee, at: 0)
            switch selectedEmployeeType {
            case .active:
                if self.arrActiveEmployee.count > 0 {
                    self.lblNoRecord.isHidden = true
                } else {
                    self.lblNoRecord.isHidden = false
                }
            case .archived:
                if self.arrArchivedEmployee.count > 0 {
                    self.lblNoRecord.isHidden = true
                } else {
                    self.lblNoRecord.isHidden = false
                }
            }
            
            self.tblEmpList.reloadData()
        }
    }
    
    @objc private func updateExistingEmployeeInList(_ notification: NSNotification) {
        if let objUpdatedEmployee = notification.userInfo?["employee"] as? BossEmployeeListObject {
            
            if let row = self.arrActiveEmployee.firstIndex(where: {$0.id == objUpdatedEmployee.id}) {
                self.arrActiveEmployee[row] = objUpdatedEmployee
                self.tblEmpList.reloadData()
            }
        }
    }
    
    @objc private func deleteEmployeeFromList(_ notification: NSNotification) {
        if let employeeID = notification.userInfo?["id"] as? Int {
            if let objEmployee = self.arrActiveEmployee.filter({ $0.id == employeeID}).first {
                debugPrint(objEmployee)
                
                if self.arrArchivedEmployee.count > 0 {
                    self.arrArchivedEmployee.insert(objEmployee, at: 0)
                }
                
                if let row = self.arrActiveEmployee.firstIndex(where: {$0.id == employeeID}) {
                    self.arrActiveEmployee.remove(at: row)
                }
                
                switch selectedEmployeeType {
                case .active:
                    if self.arrActiveEmployee.count > 0 {
                        self.lblNoRecord.isHidden = true
                    } else {
                        self.lblNoRecord.isHidden = false
                    }
                case .archived:
                    if self.arrArchivedEmployee.count > 0 {
                        self.lblNoRecord.isHidden = true
                    } else {
                        self.lblNoRecord.isHidden = false
                    }
                }
                
                self.tblEmpList.reloadData()
            }
        }
    }
    
    // MARK:- HELPER -
    func selectActiveEmployee() {
        self.deSelectArchiveEmployee()
        self.btnActive.setTitleColor(.white, for: [])
        self.btnActive.backgroundColor = Colors.activeOrCompletedOrApprovedColor
    }
    
    func deSelectActiveEmployee() {
        self.btnActive.backgroundColor = .white
        self.btnActive.setTitleColor(Colors.ActiveArchiveNormalColor, for: [])
    }
    
    func selectArchiveEmployee() {
        self.deSelectActiveEmployee()
        self.btnArchive.setTitleColor(.white, for: [])
        self.btnArchive.backgroundColor = Colors.archiveOrDeletedOrCanceledColor
    }
    
    func deSelectArchiveEmployee() {
        self.btnArchive.backgroundColor = .white
        self.btnArchive.setTitleColor(Colors.ActiveArchiveNormalColor, for: [])
    }
    
    // MARK:- ACTIONS -
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func menuAction() {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnSearchEmployeeTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnEmployeeTypeTapped(_ sender: UIButton) {
        if sender.accessibilityIdentifier == "ACTIVE" {
            self.selectedEmployeeType = EmployeeType.active
            self.selectActiveEmployee()
        }
        else if sender.accessibilityIdentifier == "ARCHIVE" {
            self.selectedEmployeeType = EmployeeType.archived
            self.selectArchiveEmployee()
        }
        
        DispatchQueue.main.async {
            switch self.selectedEmployeeType {
            case .active:
                if self.arrActiveEmployee.count > 0 {
                    self.lblNoRecord.isHidden = true
                    self.tblEmpList.reloadData()
                } else {
                    self.OFFSET = 0
                    self.PAGING_LIMIT = 30
                    self.getEmployeeList(employeeType: 1)
                }
            case .archived:
                if self.arrArchivedEmployee.count > 0 {
                    self.lblNoRecord.isHidden = true
                    self.tblEmpList.reloadData()
                } else {
                    self.OFFSET = 0
                    self.PAGING_LIMIT = 30
                    self.getEmployeeList(employeeType: 2)
                }
            }
        }
    }
    
    @IBAction func btnAddEmployeeTapped(_ sender: UIButton) {
        //If number of employees limit is reached than need to show popup
        var objBossSubscribed = BossSubscribedObject([:])
        if let data = defaults.value(forKey: SUBSCRIBED_PACKAGE) as? Data,
           let object = try? JSONDecoder().decode(BossSubscribedObject.self, from: data) {
            objBossSubscribed = object
        }
        if objBossSubscribed.no_of_users != 0 && self.arrActiveEmployee.count > 0 && objBossSubscribed.no_of_users <= self.arrActiveEmployee.count {
            AppFunctions.displayConfirmationAlert(self, title: "Upgrade subscription".localized(), message: "You have reached the maximum limit of employees as per your subscription plan. Please upgrade your plan to add more employees.".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "Upgrade".localized(), actionBlock: { (isConfirmed) in
                if isConfirmed {
                    //Redirect to subscription screen
                    let vc = AppFunctions.bossSubscriptionsStoryBoard().instantiateViewController(withIdentifier: "BossSubscriptionsVC") as! BossSubscriptionsVC
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        } else {
            if !self.isFromSideMenu {
                //Show message that user cannot add employee because either trial or subscription is expired
            } else {
                let vc = AppFunctions.bossEmployeeStoryBoard().instantiateViewController(withIdentifier: "AddEmployeeVC") as! AddEmployeeVC
                vc.objCompanyDefaultSetting = self.objCompanyDefaultSetting
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnActiveMoreTapped(_ sender: UIButton) {
        var objActiveEmployee: BossEmployeeListObject!
        
        if self.searchActive {
            objActiveEmployee = self.arrActiveSearchedEmployee[sender.tag]
        }
        else {
            objActiveEmployee = self.arrActiveEmployee[sender.tag]
        }
        
        FTPopOverMenu.showForSender(sender: sender, with: activeEmployeeOption, menuImageArray: [UIImage.init(named: "ic_setting_new")!, UIImage.init(named: "ic_inout")!, UIImage.init(named: "ic_inout")!], popOverPosition: .automatic, config: self.configWithMenuStyle(), done: { (selectedIndex) in
            if selectedIndex == 0 {
                if AppFunctions.checkInternet() == false {
                    AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
                    return
                }
                
                let vc = AppFunctions.bossEmployeeSettingsStoryBoard().instantiateViewController(withIdentifier: "EmployeeSettingVC")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if selectedIndex == 1 {
                let vc = AppFunctions.bossEmployeeStoryBoard().instantiateViewController(withIdentifier: "AddPunchInOutVC")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, cancel: {
            debugPrint("cancel")
        })
    }
    
    @IBAction func btnArchiveMoreTapped(_ sender: UIButton) {
        var objArchiveEmployee: BossEmployeeListObject!
        
        if self.searchActive {
            objArchiveEmployee = self.arrArchivedSearchedEmployee[sender.tag]
        }
        else {
            objArchiveEmployee = self.arrArchivedEmployee[sender.tag]
        }
        
        FTPopOverMenu.showForSender(sender: sender, with: archiveEmployeeOption, menuImageArray: [UIImage.init(named: "ic_restore")!, UIImage.init(named: "ic_delete")!], popOverPosition: .automatic, config: self.configWithMenuStyle(), done: { (selectedIndex) in
            if selectedIndex == 0 {
                if let data = defaults.value(forKey: SUBSCRIBED_PACKAGE) as? Data, let object = try? JSONDecoder().decode(BossSubscribedObject.self, from: data), object.no_of_users <= self.arrActiveEmployee.count {
                    AppFunctions.displayConfirmationAlert(self, title: "Upgrade subscription".localized(), message: "You have reached the maximum limit of employees as per your subscription plan. Please upgrade your plan to add more employees.".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "Upgrade".localized(), actionBlock: { (isConfirmed) in
                        if isConfirmed {
                            //Redirect to subscription screen
                            let vc = AppFunctions.bossSubscriptionsStoryBoard().instantiateViewController(withIdentifier: "BossSubscriptionsVC") as! BossSubscriptionsVC
                            vc.delegate = self
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                } else {
                    AppFunctions.displayConfirmationAlert(self, title: "Restore Employee".localized(), message: "Would you like to restore this employee?".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "Restore".localized(), actionBlock: { (isConfirmed) in
                        if isConfirmed {
                            var objBossSubscribed = BossSubscribedObject([:])
                            if let data = defaults.value(forKey: SUBSCRIBED_PACKAGE) as? Data,
                               let object = try? JSONDecoder().decode(BossSubscribedObject.self, from: data) {
                                objBossSubscribed = object
                            }
                            if objBossSubscribed.no_of_users != 0 && self.arrActiveEmployee.count > 0 && objBossSubscribed.no_of_users <= self.arrActiveEmployee.count {
                                AppFunctions.displayConfirmationAlert(self, title: "Upgrade subscription".localized(), message: "You have reached the maximum limit of employees as per your subscription plan. Please upgrade your plan to add more employees.".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "Upgrade".localized(), actionBlock: { (isConfirmed) in
                                    if isConfirmed {
                                        //Redirect to subscription screen
                                        let vc = AppFunctions.bossSubscriptionsStoryBoard().instantiateViewController(withIdentifier: "BossSubscriptionsVC") as! BossSubscriptionsVC
                                        vc.delegate = self
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                })
                            } else {
                                if !self.isFromSideMenu {
                                    //Show message that user cannot add employee because either trial or subscription is expired
                                } else {
                                    self.restoreEmployeeAPI(SelectedEmployee: objArchiveEmployee)
                                }
                            }
                        }
                    })
                }
            }
            else if selectedIndex == 1 {
                AppFunctions.displayConfirmationAlert(self, title: "Delete Employee".localized(), message: "Would you like to delete this employee permanently?".localized(), btnTitle1: "Cancel".localized(), btnTitle2: "Delete".localized(), actionBlock: { (isConfirmed) in
                    if isConfirmed {
                        self.permanentDeleteEmployeeAPI(SelectedID: objArchiveEmployee.id)
                    }
                })
            }
        }, cancel: {
            debugPrint("cancel")
        })
    }
    
    //MARK:- Pagination Call
    private func nextPageForActiveEmployeeListIfNeeded(at indexPath: IndexPath) {
        if self.arrActiveEmployee.count >= 30 {
            if indexPath.row == (self.arrActiveEmployee.count - 1) {
                if activeEmployeeRequestState != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.arrActiveEmployee.count
                    self.PAGING_LIMIT = 30
                    self.getEmployeeList(employeeType: 1)
                }
            }
        }
    }
    
    private func nextPageForArchivedEmployeeListIfNeeded(at indexPath: IndexPath) {
        if self.arrArchivedEmployee.count >= 30 {
            if indexPath.row == (self.arrArchivedEmployee.count - 1) {
                if archivedEmployeeRequestState != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.arrArchivedEmployee.count
                    self.PAGING_LIMIT = 30
                    self.getEmployeeList(employeeType: 2)
                }
            }
        }
    }
}

// MARK:- SEARCH BAR DELEGATE -
extension EmployeeListVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.searchActive = false
        searchBar.setShowsCancelButton(false, animated: true)
        self.tblEmpList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        self.searchBar.resignFirstResponder()
        //        self.searchActive = false
        
        if searchBar.text?.count == 0 {
            self.searchActive = false
        }
        else {
            self.searchActive = true
            
            self.arrActiveSearchedEmployee = (self.arrActiveEmployee.filter{$0.objUserEmployee.name.localizedLowercase.localizedCaseInsensitiveContains(searchBar.text ?? "")} as NSArray) as! [BossEmployeeListObject]
            
            self.arrArchivedSearchedEmployee = (self.arrArchivedEmployee.filter{$0.objUserEmployee.name.localizedLowercase.localizedCaseInsensitiveContains(searchBar.text ?? "")} as NSArray) as! [BossEmployeeListObject]
        }
        
        self.searchBar.resignFirstResponder()
        self.tblEmpList.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.searchActive = false
        }
        else {
            self.searchActive = true
            
            self.arrActiveSearchedEmployee = (self.arrActiveEmployee.filter{$0.objUserEmployee.name.localizedLowercase.localizedCaseInsensitiveContains(searchText)} as NSArray) as! [BossEmployeeListObject]
            
            self.arrArchivedSearchedEmployee = (self.arrArchivedEmployee.filter{$0.objUserEmployee.name.localizedLowercase.localizedCaseInsensitiveContains(searchText)} as NSArray) as! [BossEmployeeListObject]
        }
        
        self.tblEmpList.reloadData()
    }
    
}

// MARK:- UITABLEVIEW DATASOURCE & DELEGATE METHOD -

extension EmployeeListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedEmployeeType {
        case .active:
            if self.searchActive == true {
                if self.searchBar.text == "" {
                    self.lblNoRecord.isHidden = true
                    return self.arrActiveEmployee.count
                } else {
                    if self.arrActiveSearchedEmployee.count > 0 {
                        self.lblNoRecord.isHidden = true
                    } else {
                        self.lblNoRecord.isHidden = false
                    }
                    return arrActiveSearchedEmployee.count
                }
            } else {
                if self.arrActiveEmployee.count > 0 {
                    self.lblNoRecord.isHidden = true
                } else {
                    self.lblNoRecord.isHidden = false
                }
                return self.arrActiveEmployee.count
            }
        case .archived:
            if self.searchActive == true {
                if self.searchBar.text == "" {
                    self.lblNoRecord.isHidden = true
                    return self.arrArchivedEmployee.count
                } else {
                    if self.arrArchivedSearchedEmployee.count > 0 {
                        self.lblNoRecord.isHidden = true
                    } else {
                        self.lblNoRecord.isHidden = false
                    }
                    return arrArchivedSearchedEmployee.count
                }
            } else {
                if self.arrArchivedEmployee.count > 0 {
                    self.lblNoRecord.isHidden = true
                } else {
                    self.lblNoRecord.isHidden = false
                }
                return self.arrArchivedEmployee.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch selectedEmployeeType {
        case .active:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeesCell", for: indexPath) as! EmployeesCell
            
            var objEmployee: BossEmployeeListObject!
            
            if self.searchActive {
                objEmployee = self.arrActiveSearchedEmployee[indexPath.row]
            }
            else {
                objEmployee = self.arrActiveEmployee[indexPath.row]
            }
            
            cell.lblEmployeeName.text = objEmployee.objUserEmployee.name
            
            cell.btnMore.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(btnActiveMoreTapped(_:)), for: .touchUpInside)
            
            nextPageForActiveEmployeeListIfNeeded(at: indexPath)
            cell.selectionStyle = .none
            return cell
            
        case .archived:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeesCell", for: indexPath) as! EmployeesCell
            
            var objEmployee: BossEmployeeListObject!
            
            if self.searchActive {
                objEmployee = self.arrArchivedSearchedEmployee[indexPath.row]
            }
            else {
                objEmployee = self.arrArchivedEmployee[indexPath.row]
            }
            
            cell.lblEmployeeName.text = objEmployee.objUserEmployee.name
            
            cell.btnMore.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(btnArchiveMoreTapped(_:)), for: .touchUpInside)
            
            nextPageForArchivedEmployeeListIfNeeded(at: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch selectedEmployeeType {
        case .active:
            
            var objEmployee: BossEmployeeListObject!
            
            if self.searchActive {
                objEmployee = self.arrActiveSearchedEmployee[indexPath.row]
            }
            else {
                objEmployee = self.arrActiveEmployee[indexPath.row]
            }
            
            let vc = AppFunctions.bossEmployeeStoryBoard().instantiateViewController(withIdentifier: "ViewEmployeeVC")
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .archived:
            debugPrint("")
        }
    }
}

//MARK:- API CALL -

extension EmployeeListVC {
    func getEmployeeList(employeeType: Int) {
        // Check Internet Available
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params[""] = employeeType
        params[""] = self.PAGING_LIMIT
        params[""] = self.OFFSET
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        if employeeType == 1 {
            self.activeEmployeeRequestState = REQUEST.started
        }
        else {
            self.archivedEmployeeRequestState = REQUEST.started
        }
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_EMPLOYEE_LIST, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        
                        if employeeType == 1 {
                            self.activeEmployeeRequestState = REQUEST.notStarted
                        }
                        else {
                            self.archivedEmployeeRequestState = REQUEST.notStarted
                        }
                        
                        if let payloadData = response["payload"]  as? Dictionary<String, Any> {
                            
                            // EMPLOYEE
                            if let arrEmployee = payloadData["employee"] as? [Dictionary<String, Any>] {
                                for i in 0..<arrEmployee.count  {
                                    let dictEmployee = arrEmployee[i]
                                    let objEmployee = BossEmployeeListObject.init(dictEmployee)
                                    
                                    if employeeType == 1 {
                                        self.arrActiveEmployee.append(objEmployee)
                                    }
                                    else {
                                        self.arrArchivedEmployee.append(objEmployee)
                                    }
                                }
                                
                                if self.PAGING_LIMIT >= 30 {
                                    if arrEmployee.count < self.PAGING_LIMIT {
                                        if employeeType == 1 {
                                            self.activeEmployeeRequestState = REQUEST.failedORNoMoreData
                                        }
                                        else {
                                            self.archivedEmployeeRequestState = REQUEST.failedORNoMoreData
                                        }
                                    }
                                }
                                
                                if employeeType == 1 {
                                    if self.arrActiveEmployee.count > 0 {
                                        self.lblNoRecord.isHidden = true
                                    } else {
                                        self.lblNoRecord.isHidden = false
                                    }
                                }
                                else {
                                    if self.arrArchivedEmployee.count > 0 {
                                        self.lblNoRecord.isHidden = true
                                    } else {
                                        self.lblNoRecord.isHidden = false
                                    }
                                }
                                
                                self.tblEmpList.isHidden = false
                                self.tblEmpList.reloadData()
                            }
                            
                            // COMPANY DEFAULT SETTING
                            if let companyDefaultSetting = payloadData["company-default-setting"] as? Dictionary<String, Any> {
                                self.objCompanyDefaultSetting = CompanyDefaultSettingObject.init(companyDefaultSetting)
                            }
                        }
                    }
                    else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        if employeeType == 1 {
                            self.activeEmployeeRequestState = REQUEST.failedORNoMoreData
                        }
                        else {
                            self.archivedEmployeeRequestState = REQUEST.failedORNoMoreData
                        }
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
                    }
                    else {
                        if employeeType == 1 {
                            self.activeEmployeeRequestState = REQUEST.failedORNoMoreData
                        }
                        else {
                            self.archivedEmployeeRequestState = REQUEST.failedORNoMoreData
                        }
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                    }
                }
            }
        }) { (error) in
            if employeeType == 1 {
                self.activeEmployeeRequestState = REQUEST.failedORNoMoreData
            }
            else {
                self.archivedEmployeeRequestState = REQUEST.failedORNoMoreData
            }
            AppFunctions.hideProgress()
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: NETWORK_ERROR)
        }
    }
    
    //RESTORE EMPLOYEE API
    func restoreEmployeeAPI(SelectedEmployee selectedEmployee: BossEmployeeListObject) {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params[""] = selectedEmployee.id
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_RESTORE_EMPLOYEE, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        
                        AppFunctions.sharedInstance.showDarkStyleToastMesage(message: (response["message"] as! String))
                        
                        if let objEmployee = self.arrArchivedEmployee.filter({ $0.id == selectedEmployee.id}).first {
                            
                            if self.arrActiveEmployee.count > 0 {
                                self.arrActiveEmployee.insert(objEmployee, at: 0)
                            }
                            
                            if let row = self.arrArchivedEmployee.firstIndex(where: {$0.id == selectedEmployee.id}) {
                                self.arrArchivedEmployee.remove(at: row)
                            }
                            
                            if self.arrArchivedEmployee.count > 0 {
                                self.lblNoRecord.isHidden = true
                            } else {
                                self.lblNoRecord.isHidden = false
                            }
                            
                            AppFunctions.sharedInstance.reloadTableView(tableView: self.tblEmpList)
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
    
    //PERMANENT DELETE EMPLOYEE API
    func permanentDeleteEmployeeAPI(SelectedID selectedID: Int) {
        if AppFunctions.checkInternet() == false {
            AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            return
        }
        
        var params: [String:Any] = [:]
        params[""] = selectedID
        
        let strJSONParam = AppFunctions.sharedInstance.convertParameter(inJSONString: params)
        debugPrint(strJSONParam)
        
        AppFunctions.showProgressWithTitle(title: pleaseWait)
        AFWrapper.requestPOSTURL(BASE_URL + Constants.URLS.BOSS_PERMANENT_DELETE_EMPLOYEE, params: params as [String : AnyObject], headers: nil, success: { (JSONResponse) in
            
            AppFunctions.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        if let row = self.arrArchivedEmployee.firstIndex(where: {$0.id == selectedID}) {
                            self.arrArchivedEmployee.remove(at: row)
                        }
                        
                        if self.arrArchivedEmployee.count > 0 {
                            self.lblNoRecord.isHidden = true
                        } else {
                            self.lblNoRecord.isHidden = false
                        }
                        
                        AppFunctions.sharedInstance.reloadTableView(tableView: self.tblEmpList)
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
}

//MARK:- BossSubscriptionsDelegate
extension EmployeeListVC: BossSubscriptionsDelegate {
    func productPurchased(productPurchased: String) {
        debugPrint("productPurchased: \(productPurchased)")
    }
}
