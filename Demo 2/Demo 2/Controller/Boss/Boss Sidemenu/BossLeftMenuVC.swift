//
//  BossLeftMenuVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import SideMenuSwift

struct SideMenuOption {
    var title: String
    var image: UIImage
    var isExpanded: Bool
    let names: [String]
    
}

class BossLeftMenuVC: BaseVC {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    //HEADER
    @IBOutlet weak var lblBossName: UILabel!
    @IBOutlet weak var lblBossEmail: UILabel!
    @IBOutlet weak var vwBoss: UIView!
    @IBOutlet weak var lblBossTitle: UILabel!
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var tblVW: UITableView!
    
    var arrOptions = [
        SideMenuOption(title: "Dashboard".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_dashboard"), isExpanded: false, names: []),
        SideMenuOption(title: "Employees".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_employee"), isExpanded: false, names: []),
        SideMenuOption(title: "Timesheet".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_timesheet"), isExpanded: false, names: []),
        SideMenuOption(title: "View on map".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_viewonmap"), isExpanded: false, names: []),
        SideMenuOption(title: "Clients".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_clients"), isExpanded: false, names: []),
        SideMenuOption(title: "Jobs".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_jobs"), isExpanded: false, names: []),
        SideMenuOption(title: "Invoice".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_Invoice"), isExpanded: false, names: []),
        SideMenuOption(title: "Expenses".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_expenses"), isExpanded: false, names: ["Employee expenses", "Categories"]),
        SideMenuOption(title: "Reports".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_reports"), isExpanded: false, names: ["Summary", "Payroll", "Expenses"]),
        SideMenuOption(title: "Vacation / Sick".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_vacationsick"), isExpanded: false, names: []),
        SideMenuOption(title: "Settings".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_settings"), isExpanded: false, names: []),
        SideMenuOption(title: "Subscription".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_subscription"), isExpanded: false, names: []),
        SideMenuOption(title: "Logout".localized(), image: #imageLiteral(resourceName: "ic_sidemenu_logout"), isExpanded: false, names: []),
    ]
    
    var strSelectedItem: String = ""
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
         
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK:- HELPER -
    
    // MARK:- ACTIONS -
    @objc func handleExpandClose(button: UIButton) {
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in self.arrOptions[section].names.indices {
            debugPrint(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = self.arrOptions[section].isExpanded
        self.arrOptions[section].isExpanded = !isExpanded
        
        //button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        if isExpanded {
            self.tblVW.deleteRows(at: indexPaths, with: .fade)
        } else {
            self.tblVW.insertRows(at: indexPaths, with: .fade)
        }
        
        //MEANS SINGLE ITEM
        if self.arrOptions[button.tag].names.count <= 0 {
            let headerTitle = self.arrOptions[button.tag].title
            
            if headerTitle != "Logout".localized() {
                self.strSelectedItem = headerTitle
            }
            
            if headerTitle == "Dashboard".localized() {
                let vc = AppFunctions.bossDashboardStoryBoard().instantiateViewController(withIdentifier: "BossDashboardVC") as! BossDashboardVC
                let navController = UINavigationController.init(rootViewController: vc)
                appDelegate.drawerController.contentViewController = navController
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            }
            else if headerTitle == "Employees".localized() {
                if AppFunctions.checkInternet() == false {
                    AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
                    return
                }
                let vc = AppFunctions.bossEmployeeStoryBoard().instantiateViewController(withIdentifier: "EmployeeListVC") as! EmployeeListVC
                vc.isFromSideMenu = true
                let navController = UINavigationController.init(rootViewController: vc)
                appDelegate.drawerController.contentViewController = navController
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            }
            else if headerTitle == "Subscription".localized() {
                if AppFunctions.checkInternet() == false {
                    AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
                    return
                }
                let vc = AppFunctions.bossSubscriptionsStoryBoard().instantiateViewController(withIdentifier: "BossSubscriptionsVC") as! BossSubscriptionsVC
                vc.isFromSideMenu = true
                let navController = UINavigationController.init(rootViewController: vc)
                appDelegate.drawerController.contentViewController = navController
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            }
            else if headerTitle == "Logout".localized() {
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    AppFunctions.displayConfirmationAlert(self, title: "Logout".localized(), message: "Are you sure you want to logout?".localized(), btnTitle1: "No".localized(), btnTitle2: "Yes".localized(), actionBlock: { (isConfirmed) in
                        if isConfirmed {
                            appDelegate.logoutUser()
                        }
                    })
                }
            }
        }
        
        self.tblVW.reloadData()
    }
}

//MARK:- UITableView Delegate & DataSource
extension BossLeftMenuVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.arrOptions[section].isExpanded {
            return 0
        }
        
        return self.arrOptions[section].names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
        //        cell.constraintLeadingOfImageVW.constant = 37.0
        
        let name = self.arrOptions[indexPath.section].names[indexPath.row]
        cell.lblOption.text = name
        
        if name == "Employee expenses".localized() {
            cell.imgVwOption.image = #imageLiteral(resourceName: "ic_sidemenu_employee_expenses")
        } else if name == "Categories".localized() {
            cell.imgVwOption.image = #imageLiteral(resourceName: "ic_sidemenu_categoies")
        } else if name == "Summary".localized() {
            cell.imgVwOption.image = #imageLiteral(resourceName: "ic_sidemenu_summary_reports")
        } else if name == "Payroll".localized() {
            cell.imgVwOption.image = #imageLiteral(resourceName: "ic_sidemenu_payroll")
        } else if name == "Expenses".localized() {
            cell.imgVwOption.image = #imageLiteral(resourceName: "ic_sidemenu_expenses_report")
        }
        
        cell.vwContent.backgroundColor = .white
        if name == self.strSelectedItem {
            cell.vwContent.backgroundColor = Colors.sidemenuSelectedOptionBgColor
        } else {
            cell.vwContent.backgroundColor = .white
        }
        
        cell.lblSeprator.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = self.arrOptions[indexPath.section].names[indexPath.row]
        self.strSelectedItem = name
        
        if name == "Employee expenses".localized() {
            if AppFunctions.checkInternet() == false {
                AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
                return
            }
        }
        else if name == "Payroll".localized() {
            let vc = AppFunctions.bossReportStoryBoard().instantiateViewController(withIdentifier: "BossPayrollVC") as! BossPayrollVC
            let navController = UINavigationController.init(rootViewController: vc)
            appDelegate.drawerController.contentViewController = navController
            appDelegate.drawerController.hideMenu(animated: true, completion:nil)
        }
        else if name == "Expenses".localized() {
            let vc = AppFunctions.bossReportStoryBoard().instantiateViewController(withIdentifier: "BossExpenseReportVC") as! BossExpenseReportVC
            let navController = UINavigationController.init(rootViewController: vc)
            appDelegate.drawerController.contentViewController = navController
            appDelegate.drawerController.hideMenu(animated: true, completion:nil)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .red
        }
    }
    */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LeftMenuHeaderView") as? LeftMenuHeaderView
        
        let item = self.arrOptions[section]
        
        headerView?.vwContent.backgroundColor = .white
        
        if item.names.count <= 0 {
            headerView?.imgVWIndicator.isHidden = true
            
            if item.title == self.strSelectedItem {
                headerView?.vwContent.backgroundColor = Colors.sidemenuSelectedOptionBgColor
            } else {
                headerView?.vwContent.backgroundColor = .white
            }
        }
        else {
            headerView?.imgVWIndicator.isHidden = false
        }
        headerView?.lblName.text = item.title
        headerView?.imgVW.image = item.image
        
        if item.isExpanded {
            headerView?.imgVWIndicator.image = #imageLiteral(resourceName: "ic_sidemenu_up_arrow")
        } else {
            headerView?.imgVWIndicator.image = #imageLiteral(resourceName: "ic_sidemenu_down_arrow")
        }
        
        headerView?.btnExpandClose.tag = section
        headerView?.btnExpandClose.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor.clear
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == self.arrOptions.count - 1 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SidemenuFooterView") as? SidemenuFooterView
            
            if self.strSelectedItem == "Customer support".localized() {
                footerView?.vwContent.backgroundColor = Colors.sidemenuSelectedOptionBgColor
            } else {
                footerView?.vwContent.backgroundColor = .white
            }
            
            footerView?.lblSupportCenter.text = "Customer support".localized()
            footerView?.onSupportCenterAction = { [weak self] in
                self?.strSelectedItem = "Customer support".localized()

            }
            return footerView
        } else {
            return UIView.init(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.arrOptions.count - 1 {
            return UITableView.automaticDimension
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if section == self.arrOptions.count - 1 {
            return 130.0
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
}
