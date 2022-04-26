//
//  ExpenseReportCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class ExpenseReportCell: UITableViewCell {
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var tblVW: ContentSizedTableView!
    
//    var objExpenseReport: ExpenseReportDateObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        tblVW.delegate = self
//        tblVW.dataSource = self
        tblVW.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblVW.frame.size.width, height: 1))
        
        let nib = UINib(nibName: "ExpenseReportUserHeaderView", bundle: nil)
        self.tblVW.register(nib, forHeaderFooterViewReuseIdentifier: "ExpenseReportUserHeaderView")
        
        tblVW.register(UINib(nibName: "ExpenseReportCategoryCell", bundle: nil), forCellReuseIdentifier: "ExpenseReportCategoryCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

/*
extension ExpenseReportCell: UITableViewDelegate ,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.objExpenseReport != nil {
            return self.objExpenseReport.arrReports.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.objExpenseReport != nil {
            let objCategory = self.objExpenseReport.arrReports[section]
            return objCategory.arrExpenseCategory.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseReportCategoryCell", for: indexPath) as! ExpenseReportCategoryCell
        
        let objEmployee = self.objExpenseReport.arrReports[indexPath.section]
        let objExpenseCategory = objEmployee.arrExpenseCategory[indexPath.row]
        
        cell.lblName.text = objExpenseCategory.cat_name
        cell.lblAmount.text = appDelegate.objLoggedInUser.objCompanyInfo.currency + objExpenseCategory.total
        
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44.0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tblVW.dequeueReusableHeaderFooterView(withIdentifier: "ExpenseReportUserHeaderView") as! ExpenseReportUserHeaderView
        
        let objEmployee = self.objExpenseReport.arrReports[section]
        header.lblEmployeeName.text = objEmployee.employee_name
        header.lblAmount.text = appDelegate.objLoggedInUser.objCompanyInfo.currency +  objEmployee.totalSum
        
        if section == 0 {
            header.lblSeperator.isHidden = true
        } else {
            header.lblSeperator.isHidden = false
        }
        
        return header
    }
}
*/
