//
//  EmployeeTabBarVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class EmployeeTabBarVC: UITabBarController, UITabBarControllerDelegate {

    //MARK: - Outlets and Variables
    var timesheetTab = UITabBarItem()
    var jobTab = UITabBarItem()
    var dashboardTab = UITabBarItem()
    var vacationSickTab = UITabBarItem()
    var moreTab = UITabBarItem()
    
    var isEmployeeLoginForFirstTime: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navTimesheet = UINavigationController.init(rootViewController: (AppFunctions.employeeTimesheetStoryBoard().instantiateViewController(withIdentifier: "EmployeeTimesheetListVC")))
        
        let navJob = UINavigationController.init(rootViewController: (AppFunctions.employeeJobStoryBoard().instantiateViewController(withIdentifier: "EmployeeJobListVC")))
        
        let controller = AppFunctions.employeeDashboardStoryBoard().instantiateViewController(withIdentifier: "EmployeeDashboardVC") as! EmployeeDashboardVC
        if self.isEmployeeLoginForFirstTime {
            controller.isWantToShowSyncingProgress = true
        }
        let navDashboard = UINavigationController.init(rootViewController: (controller))
        
        let navVacationSick = UINavigationController.init(rootViewController: (AppFunctions.employeeVacationSickStoryBoard().instantiateViewController(withIdentifier: "EmployeeVacationSickListVC")))
        
        let navMore = UINavigationController.init(rootViewController: (AppFunctions.employeeSettingMenuStoryBoard().instantiateViewController(withIdentifier: "EmployeeSettingMenuVC")))
        
        self.viewControllers = [navTimesheet, navJob, navDashboard, navVacationSick, navMore]
        self.delegate = self
        
        timesheetTab    = (self.tabBar.items?[0])!
        jobTab          = (self.tabBar.items?[1])!
        dashboardTab    = (self.tabBar.items?[2])!
        vacationSickTab = (self.tabBar.items?[3])!
        moreTab         = (self.tabBar.items?[4])!
        
        timesheetTab.title = "Timesheet"
        timesheetTab.image = UIImage(named:"ic_timesheet_0")?.withRenderingMode(.alwaysOriginal)
        timesheetTab.selectedImage = UIImage(named:"ic_timesheet_1")?.withRenderingMode(.alwaysOriginal)
        
        jobTab.title = "Jobs"
        jobTab.image = UIImage(named:"ic_job_0")?.withRenderingMode(.alwaysOriginal)
        jobTab.selectedImage = UIImage(named:"ic_job_1")?.withRenderingMode(.alwaysOriginal)
        
        dashboardTab.title = "Dashboard"
        dashboardTab.image = UIImage(named:"ic_dashboard_0")?.withRenderingMode(.alwaysOriginal)
        dashboardTab.selectedImage = UIImage(named:"ic_dashboard_1")?.withRenderingMode(.alwaysOriginal)
        
        vacationSickTab.title = "Vacation / Sick"
        vacationSickTab.image = UIImage(named:"ic_vacation_0")?.withRenderingMode(.alwaysOriginal)
        vacationSickTab.selectedImage = UIImage(named:"ic_vacation_1")?.withRenderingMode(.alwaysOriginal)
        
        moreTab.title = "More"
        moreTab.image = UIImage(named:"ic_more_0")?.withRenderingMode(.alwaysOriginal)
        moreTab.selectedImage = UIImage(named:"ic_more_1")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.isTranslucent = false
        self.selectedIndex = 2
    }
}
